package AddressBook;

use strict;
use warnings;
use Catalyst::Runtime '5.70';
use Catalyst qw/ConfigLoader Static::Simple
		Session Session::State::Cookie Session::Store::DBIC
                Authentication
                Authentication::Store::DBIC
                Authentication::Credential::Password
		Authorization::Roles
		Authorization::ACL/;

our $VERSION = '0.03';
__PACKAGE__->config( name => 'AddressBook' );

__PACKAGE__->config( session => {
				 dbic_class => 'AddressDB::Session',
				 expires    => 3600,
				 flash_to_stash => 1,
				}
		   );
__PACKAGE__->config->{authentication}{dbic} = 
  {
   user_class    => 'AddressDB::User',
   user_field    => 'username',
   password_type => 'clear', # use salted_hash for real applications
  };

__PACKAGE__->config->{authorization}{dbic} = 
  {
   role_class           => 'AddressDB::Role',
   role_field           => 'role',
   role_rel             => 'map_user_role',
   user_role_user_field => 'user',
  };

# Start the application
__PACKAGE__->setup;

## ACLs
__PACKAGE__->deny_access_unless('/person', [qw/viewer/]);
__PACKAGE__->deny_access_unless('/search', [qw/viewer/]);
__PACKAGE__->deny_access_unless('/address', [qw/viewer/]);

# should always be allowed
__PACKAGE__->allow_access('/index');
__PACKAGE__->allow_access('/login');

1;
