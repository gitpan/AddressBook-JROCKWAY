package AddressBook::Model::AddressDBI;

use strict;
use base 'Catalyst::Model::DBI';

__PACKAGE__->config(
    dsn           => 'DBI:SQLite:database',
    user          => '',
    password      => '',
    options       => {},
);

sub count_users {
    my $self = shift;
    my $dbh  = $self->dbh;

    my $rows = $dbh->selectall_arrayref('SELECT COUNT(id) FROM user');
    return $rows->[0]->[0]; # first row, then the first column;
}

=head1 NAME

AddressBook::Model::AddressDBI - DBI Model Class

=head1 SYNOPSIS

See L<AddressBook>

=head1 DESCRIPTION

DBI Model Class.

=head1 AUTHOR

Jonathan Rockway,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
