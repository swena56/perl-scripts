#!/usr/bin/perl -w
# homework-day1.pl

use warnings;
use strict;
use DBI;
use Parse::CSV;
use Data::Dumper;
use Data::Faker;

#create fakedata csv file
my $csv_file = "data.csv";
my $numPeople = 10;
my $faker = Data::Faker->new();

print "Generating $numPeople fake records for: $csv_file ";
open FH,  '>', $csv_file;
#print FH "FirstName,LastName,BirthDay,Title\n";

for(1..$numPeople)
{
	my @full_name = split(/ /, $faker->name);
	my $first_name = $full_name[0];
	my $last_name = $full_name[1];
	my $birthDate = $faker->date;
	my $title = $faker->job_title;

	print FH "$first_name,$last_name,$birthDate,$title\n";
}

close FH;
print "...done\n\n";

#open and parse csv 
print "Opening CSV file: $csv_file\n";
open FH, $csv_file;
	my @lines = <FH>;
close FH;
#print Dumper(@lines) , "\n";;

my $parser = Parse::CSV->new(
								file       => 'data.csv',
								sep_char   => ',',
								#names      => [ 'FirstName', 'LastName', 'BirthDay', 'Title'],								
							);
#my $column_count = 4;




 


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
	
	#data base drivers
	#my @ary = DBI->available_drivers;
	#my %drivers = DBI->installed_drivers();

	my $createTableSql = "CREATE TABLE IF NOT EXISTS users (
									id int(11) NOT NULL auto_increment,
									first_name varchar(100) NULL,
									last_name varchar(100) NULL,
									birth_date varchar(100) NULL,
									title varchar(100) NULL,
									PRIMARY KEY (id));";

	print "Create database: $createTableSql\n";
	$dbh->do($createTableSql) or die("Cannot create database");	

	while(my $value = $parser->fetch)
	{
	 	my $first_name = @$value[0];
		my $last_name = @$value[1];
		my $birth_date = @$value[2];
		my $title = @$value[3];

		#insert data
		my $sth = $dbh->prepare("INSERT INTO users( first_name, last_name, birth_date, title ) 
			values ('$first_name', '$last_name', '$birth_date', '$title')" );
		$sth->execute() or die $DBI::errstr;
		print "Inserted Person: $first_name, $last_name, $birth_date, $title\n\n";
	}

	#count rows
	my $sth = $dbh->prepare("SELECT COUNT(*) FROM users");
	$sth->execute() or die $DBI::errstr;
	while (my @row = $sth->fetchrow_array())
	{
		print "Number of rows in DB: @row\n";
	}
	$sth->finish();

	$dbh->disconnect(); 
}



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
