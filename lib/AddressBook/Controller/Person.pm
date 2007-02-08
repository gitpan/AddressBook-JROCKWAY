package AddressBook::Controller::Person;

use strict;
use warnings;
use base qw(Catalyst::Controller::FormBuilder Catalyst::Controller::BindLex);

=head1 NAME

AddressBook::Controller::Person - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub list : Local {
    my ($self, $c) = @_;
    my $people : Stashed = $c->model('AddressDB::People');
    $c->stash->{template} = 'person/list.tt2';
}

sub add : Local Form('/person/edit') {
    my ($self, $c) = @_;    
    $c->stash->{template} = 'person/edit.tt2';
    $c->forward('edit', []);
}

sub edit : Local Form {
    my ($self, $c, $id) = @_;
    my $form = $self->formbuilder;

    if($id != eval{$c->user->person->id} &&
       !$c->check_any_user_role('editor')){
	
	$c->stash->{error} = 
	  'You are not authorized to edit this person.';
	
	$c->detach('/access_denied');
    }
    
    my $person = $c->model('AddressDB::People')->
      find_or_new({id => $id});
    
    if ($form->submitted && $form->validate) {
	# form was submitted and it validated
	
	$person->firstname($form->field('firstname'));
	$person->lastname ($form->field( 'lastname'));
	$person->update_or_insert;

	$c->flash->{message} =
	  ($id > 0 ? 'Updated ' : 'Added ') . $person->name;
	
	$c->response->redirect($c->uri_for('list'));
	
    }
    else {
	# first time through, or invalid form

	if(!$id){
	    $c->stash->{message} = 'Adding a new person';
	}

	$form->field(name  => 'firstname',
		     value => $person->firstname);

	$form->field(name  => 'lastname',
		     value => $person->lastname);
    }
}

sub delete : Local {
    my ($self, $c, $id) = @_;
    my $person = $c->model('AddressDB::People')->
      find({id => $id});
    
    # only editors can delete (users can't delete themselves)
    if(!$c->check_any_user_role('editor')){
	
	$c->stash->{error} = 
	  'You are not authorized to delete this person.';
	
	$c->detach('/access_denied');
    }
    
    if($person){
	$c->flash->{message} = 'Deleted ' . $person->name;
	$person->delete;
    }
    else {
	$c->flash->{error} = "No person $id";
    }
    
    $c->response->redirect($c->uri_for('list'));
    $c->detach();
}


=head1 AUTHOR

Jonathan Rockway,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
