#!/usr/bin/perl
# Search.pm 
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package AddressBook::Controller::Search;

use strict;
use warnings;
use base qw(Catalyst::Controller::FormBuilder Catalyst::Controller::BindLex);

sub search : Global Form {
    my ($self, $c, $query) = @_;
    my $form = $self->formbuilder;
    
    # get query from the URL (or the form if there's nothing there)
    $query ||= $form->field('query')
      if($form->submitted && $form->validate);
    
    return unless $query; # no query? we're done
    
    $c->stash->{query} = $query;
    my @tokens = split /\s+/, $query;
    my $result : Stashed;
    
    if('Names' eq $form->field('domain')){
	$result = $c->forward('search_names', \@tokens);
	$c->stash->{'template'} = 'search/name_results.tt2'
    }
    else {
	$result = $c->forward('search_addresses', \@tokens);
	$c->stash->{'template'} = 'search/address_results.tt2'
    }
    
    
    my $page = $c->request->param('page');
    $page = 1 if($page !~ /^\d+$/);
    $result  = $result->page($page);
    my $pager : Stashed  = $result->pager;
}
  
  sub search_addresses : Private {
    my ($self, $c, @tokens) = @_;
    
    my @address_fields = qw/postal phone email location/;
    @address_fields    = cross(\@address_fields, \@tokens);
    
    return $c->model('AddressDB::Addresses')->search(\@address_fields);
}

sub search_names : Private {
    my ($self, $c, @tokens) = @_;
    
    my @people_fields = qw/firstname lastname/;
    @people_fields    = cross(\@people_fields, \@tokens);

    return $c->model('AddressDB::People')->search(\@people_fields);
}

sub cross {
    my $columns = shift || [];
    my $tokens  = shift || [];

    map {s/%/\\%/g} @$tokens;
    
    my @result;
    foreach my $column (@$columns){
	push @result, (map +{$column => {-like => "%$_%"}}, @$tokens);
    }

    return @result;
}
  
1;
