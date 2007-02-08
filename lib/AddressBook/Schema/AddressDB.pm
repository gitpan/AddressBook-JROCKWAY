package AddressBook::Schema::AddressDB;

# Created by DBIx::Class::Schema::Loader v0.03009 @ 2006-12-10 21:20:12

# perl script/addressbook_create.pl model AddressDB DBIC::Schema \
# AddressBook::Schema::AddressDB create=static dbi:SQLite:database

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_classes;

1;

