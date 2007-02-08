#!/usr/bin/perl
# Roles.pm 
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package AddressBook::Schema::AddressDB::Role;
use strict;
use base 'DBIx::Class';

__PACKAGE__->load_components( qw/ Core / );
__PACKAGE__->table( 'role' );
__PACKAGE__->add_columns( id   => { data_type => "INTEGER" },
			  role => { data_type => "TEXT" },
			);
__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->has_many( map_user_role => 
		       'AddressBook::Schema::AddressDB::UserRole' => 'role' );

1;
