#!/usr/bin/perl
# UserRole.pm 
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package AddressBook::Schema::AddressDB::UserRole;
use strict;
use base 'DBIx::Class';

__PACKAGE__->load_components( qw/ Core / );
__PACKAGE__->table( 'user_role' );
__PACKAGE__->add_columns( user => {data_type => "INTEGER"},
			  role => {data_type => "INTEGER"},);
__PACKAGE__->set_primary_key( qw/user role/ );

1;
