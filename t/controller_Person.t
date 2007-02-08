use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'AddressBook' }
BEGIN { use_ok 'AddressBook::Controller::Person' }

ok( request('/person/list')->is_success, 'Request should succeed' );


