#!/usr/bin/perl
# import_csv.pl 
# imports CSV files into the address book
# format: firstname, lastname, address location, address, phone, email

use Text::CSV_XS;
use FindBin qw($Bin);
use Path::Class;
use lib dir($Bin, '..', 'lib')->stringify;
use AddressBook::Schema::AddressDB;
use YAML 'LoadFile';
use strict;

my $config = LoadFile(file($Bin, '..', 'addressbook.yml'));
my $dsn    = $config->{'Model::AddressDB'}->{connect_info}->[0];
my $HOME   = dir($Bin, '..');
$dsn =~ s/__HOME__/$HOME/;

my $schema = 
  AddressBook::Schema::AddressDB->connect($dsn)
  or die "Failed to connect to database at $dsn";

while(my $line = <>){
    eval {
	my $csv = Text::CSV_XS->new();    
	$csv->parse($line) or die "Invalid data";
	my ($first, $last, $location, $address, $phone, $email) 
	  = $csv->fields();
	
	my $person = $schema->resultset('People')->
	  find_or_create({ firstname => $first,
			   lastname  => $last, 
			 });
	
	$schema->resultset('Addresses')->
	  create({ person   => $person,
		   location => $location,
		   postal   => $address,
		   phone    => $phone,
		   email    => $email,       
		 });
	print "Added @{[$person->name]}'s $location address.\n";
    };
    if($@){
	warn "Problem adding address: $@";
    }
}

