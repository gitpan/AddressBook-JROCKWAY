#!/usr/bin/perl
# random_addresses.pl 
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>
# Run like "perl script/random_addresses.pl | perl script/import_csv.pl"

my @names = qw(Foo Bar Baz Test Jonathan Rockway Person Another A);
my @locations = qw(Home Work Mobile Fax Test);
my @streets = qw(Green Oak Elm 60th Fake State Halsted);

for(1..1000){
    my $first = $names[rand @names];
    my $last  = $names[rand @names];
    my $where = $locations[rand @locations];
    my $number = int rand 9900 + 100;
    my $street = $streets[rand @streets];
    my $address = "$number $street St.";
    my $phone = join '-', (int rand 800 + 100, int rand 899 + 100,
			   int rand 8999 + 1000);
    my $email = "$first.$last\@$where.example.com";
    print "$first,$last,$where,$address,$phone,$email\n";
}
