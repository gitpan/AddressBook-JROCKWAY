#!/usr/bin/perl
# Test.pm 
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package AddressBook::Controller::Test;
use strict;
use warnings;
use base 'Catalyst::Controller';

sub count_users : Local {
    my ($self, $c) = @_;

    my $count = $c->model('AddressDBI')->count_users();
    $c->response->body("There are $count users.");
}


1;
