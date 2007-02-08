package AddressBook::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller::FormBuilder';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

AddressBook::Controller::Root - Root Controller for AddressBook

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 default

=cut

sub default : Private {
    my ( $self, $c ) = @_;

    $c->response->status('404');
    $c->stash->{template} = 'not_found.tt2';
}

sub access_denied : Private {
    my ($self, $c) = @_;
    $c->stash->{template} = 'denied.tt2';
}

sub login : Global Form {
    my ($self, $c) = @_;
    my $form = $self->formbuilder;

    if($form->submitted && $form->validate){
	if($c->login($form->field('username'), $form->field('password'))){
	    $c->flash->{message} = 'Logged in successfully.';
	    $c->res->redirect($c->uri_for('/'));
	    $c->detach();
	}
	else {
	    $c->stash->{error} = 'Login failed.';
	}
    }
}

sub logout : Global {
    my ($self, $c) = @_;

    $c->logout;
    $c->flash->{message} = 'Logged out.';
    $c->res->redirect($c->uri_for('/'));
}

=head1 index

=cut

sub index : Private {};

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Jonathan Rockway,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
