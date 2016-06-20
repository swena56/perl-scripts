#!/usr/bin/perl -w
# homework-day1.pl

use warnings;
use strict;
use DBI;
use Text::CSV;
use Data::Dumper;
use Data::Faker;

#create fakedata csv file
my $csv_file = "data.csv";
my $numPeople = 10;
my $faker = Data::Faker->new();

print "Generating $numPeople fake records for: $csv_file ";
open FH,  '>', $csv_file;
print FH "FirstName, LastName, BirthDay, Title, ";

for(1..$numPeople)
{
	my @full_name = split(/ /, $faker->name);
	my $first_name = $full_name[0];
	my $last_name = $full_name[1];
	my $birthDate = $faker->date;
	my $title = $faker->job_title;

	print FH "$first_name, $last_name, $birthDate, $title, ";
}
close FH;
print "...done\n\n";

#open csv 
print "Opening CSV file: $csv_file\n";
open FH, $csv_file;
	my @lines = <FH>;
close FH;
print Dumper(@lines) , "\n";;


# create table in mysql to house this information
# FirstName, LastName, BirthDay, Title






#create person object

#save person object


# establish database connection
my $database = 'bei_training';
my $hostname = 'localhost';
my $port = '3306';
my $user = 'bei-training';
my $password = 'bei-training';

my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
my $dbh = DBI->connect($dsn, $user, $password,  {RaiseError => 1})
              or die $DBI::errstr;
if($dbh)
{
	print "Connected successfully to: mysql://$user:$password@".$hostname .":$port/$user\n\n";

	my $createTableSql = "CREATE TABLE IF NOT EXISTS " . $dbh->quote($database) . " (
									'id' int(11) NOT NULL auto_increment,
									'first_name' varchar(100) NULL,
									'last_name' varchar(100) NULL,
									'birthdate' varchar(100) NULL,
									'title' varchar(100) NULL,
									PRIMARY KEY ('id')

	);";



	print "Create database: $createTableSql\n";
	$dbh->do($createTableSql);
	
}

$dbh->disconnect(); 

=pod
	
	=head1 Homework For Day1 at BEI

	CSV file 
	use Data::Faker;
 
	my $faker = Data::Faker->new();
	 
	print "Name:    ".$faker->name."\n";
	print "Company: ".$faker->company."\n";
	print "Address: ".$faker->street_address."\n";
	print "         ".$faker->city.", ".$faker->us_state_abbr." ".$faker->us_zip_code."\n";
=cut