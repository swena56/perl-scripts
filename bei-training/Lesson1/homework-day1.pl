#!/usr/bin/perl -w
# homework-day1.pl

use warnings;
use strict;
use DBI;
use Parse::CSV;
use Data::Dumper;
use Data::Faker;
#use DateTime;

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

	my $createTableSql = "CREATE TABLE IF NOT EXISTS users (
									id int(11) NOT NULL auto_increment,
									first_name varchar(100) NULL,
									last_name varchar(100) NULL,
									birth_date varchar(100) NULL,
									title varchar(100) NULL,
									PRIMARY KEY (id));";

	print "Create database: $createTableSql\n";
	$dbh->do($createTableSql) or die("Cannot create database");	


	my $sth = $dbh->prepare("INSERT INTO users( first_name, last_name, birth_date, title ) values (?,?,?,?) ");	

	#bulk insert
	#TODO
	#my $outputfile = "";
	#open FH, ">", $output_file;

		while(my $value = $parser->fetch)
		{
		 	my $first_name = @$value[0];
			my $last_name = @$value[1];
			my $birth_date = @$value[2];		#date formatter   DateTime()
			my $title = @$value[3];

			$sth->execute($first_name, $last_name, $birth_date, $title) or die $DBI::errstr;

			#$sth->do($first_name, $last_name, $birth_date, $title) or die $DBI::errstr;
	#		print FH "$first_name, $last_name, $birth_date, $title\n";
		}

	#close FH;

	#another option is a temp space in DB
	#tab for sep_
	#$dbh->do("LOAD DATA LOCAL INFILE $outputfile INTO users ( first_name, last_name, birth_date, title ) ");

	#count rows
	my @rows = $dbh->selectrow_array("SELECT COUNT(*) FROM users");
	print "Number of rows in DB: $rows[0]\n";

	#disconnect from database
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
