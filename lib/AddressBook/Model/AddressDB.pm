package AddressBook::Model::AddressDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'AddressBook::Schema::AddressDB',
    connect_info => [
        'dbi:SQLite:database',
        
    ],
);

sub get_users_resultset {
    my $self = shift;
    my $users = $self->resultset('User');
    my $user;
    my @result;
    while($user = $users->next){
	push @result, $user->username;
    }
    return @result;
}

sub get_users_dbi {
    my $self = shift;
    my $storage = $self->storage;
    return $storage->dbh_do( 
      sub {
	  my $self = shift;
	  my $dbh  = shift;
	  my @args = @_;
	  
	  my $sth = $dbh->prepare('SELECT username FROM user');
	  $sth->execute();
	  my @rows = @{$sth->fetchall_arrayref()};
	  return map { $_->[0] } @rows;
      });
}

=head1 NAME

AddressBook::Model::AddressDB - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<AddressBook>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<AddressBook::Schema::AddressDB>

=head1 AUTHOR

Jonathan Rockway,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
