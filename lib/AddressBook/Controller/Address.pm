package AddressBook::Controller::Address;

use strict;
use warnings;
use base qw(Catalyst::Controller::FormBuilder Catalyst::Controller::BindLex );

=head1 NAME

AddressBook::Controller::Address - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub add : Local Form('/address/edit') {
    my ($self, $c, $person_id) = @_;
    $c->stash->{template} = 'address/edit.tt2';
    $c->forward('edit', [undef, $person_id]);
}

sub edit : Local Form {
    my ($self, $c, $address_id, $person_id) = @_;
    my $address : Stashed;
    my $form = $self->formbuilder;

    # check ACL
    if($person_id != eval{$c->user->person->id} &&
       !$c->check_any_user_role('editor')){

	$c->stash->{error} = 
	  'You are not authorized to edit addresses for this person.';

	$c->detach('/access_denied');
    }

    if(!$address_id && $person_id){ # we're adding a new address to $person
	# check that person exists
	my $person = $c->model('AddressDB::People')->find({id => $person_id});
	if(!$person){
	    $c->flash->{error} = 'No such person!';
	    $c->response->redirect($c->uri_for('/person/list'));
	    $c->detach();
	}
	
	# create the address
	$address = $c->model('AddressDB::Addresses')->
	  new({person => $person});
	
    }
    else {
	$address = $c->model('AddressDB::Addresses')->find({id => $address_id});
	
	if(!$address){
	    $c->flash->{error} = 'No such address!';
	    $c->response->redirect($c->uri_for('/person/list'));
	    $c->detach();
	}
    }
    
    if ($form->submitted && $form->validate){ 
	# transfer data from form to database
	$address->location($form->field('location'));
	$address->postal($form->field('postal'));
	$address->phone($form->field('phone'));
	$address->email($form->field('email'));
	$address->insert_or_update;
	$c->flash->{message} = ($address_id > 0 ? 'Updated ' : 'Added new ').
	  'address for '. $address->person->name;
	$c->response->redirect($c->uri_for('/person/list'));
	$c->detach();
    }
    else {
	# transfer data from database to form
	if(!$address_id){
	    $c->stash->{message} = 'Adding a new address ';
	}
	else {
	    $c->stash->{message} = 'Updating an address ';
	}
	$c->stash->{message} .= ' for '. $address->person->name;
	
	$form->field(name  => 'location',
		     value => $address->location);
	
	$form->field(name  => 'postal',
		     value => $address->postal);

	$form->field(name  => 'phone',
		     value => $address->phone);

	$form->field(name  => 'email',
		     value => $address->email);
    }
}

sub delete : Local {
    my ($self, $c, $address_id) = @_;

    my $address = $c->model('AddressDB::Addresses')->
      find({id => $address_id});

    if($address){
	# check ACL
	if($address->person->id != eval{$c->user->person->id} &&
	   !$c->check_any_user_role('editor')){
	    
	    $c->stash->{error} = 
	      'You are not authorized to delete addresses for this person.';
	    
	    $c->detach('/access_denied');
	}


	# "Deleted First Last's Home address"
	$c->flash->{message} = 
	  'Deleted ' . $address->person->name. q{'s }. 
	    $address->location. ' address';
	
	$address->delete;
    }
    else {
	$c->flash->{error} = 'No such address';
    }
    
    $c->response->redirect($c->uri_for('/person/list'));
    $c->detach();
}


=head1 AUTHOR

Jonathan Rockway,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
