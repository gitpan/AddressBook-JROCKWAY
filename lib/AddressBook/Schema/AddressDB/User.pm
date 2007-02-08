#!/usr/bin/perl
# User.pm 
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>
    
package AddressBook::Schema::AddressDB::User;
use strict;
use base 'DBIx::Class';

__PACKAGE__->load_components( qw/ Core / );
__PACKAGE__->table('user');
__PACKAGE__->add_columns( id =>       { data_type => "INTEGER" },
			  username => { data_type => "TEXT" },
			  password => { data_type => "TEXT" }, 
			  person   => { data_type => "INTEGER"}, );

__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->has_many(map_user_role => 
		      'AddressBook::Schema::AddressDB::UserRole' => 'user');

__PACKAGE__->belongs_to(person => 'AddressBook::Schema::AddressDB::People');


1;
