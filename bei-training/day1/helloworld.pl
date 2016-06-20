#!/usr/bin/perl -w
# hello.pl by Andrew Swenson

use strict;
use warnings;
use DBI;

my $var = "andy";

print "\n This will create a new line $var";
print '\n This will literally type out \n ' , $var;
print "helloworld";  #I will use print over say

my $database = 'bei_training';
my $hostname = 'localhost';
my $port = '3306';
my $user = 'bei-training';
my $password = 'bei-training';

my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
my $dbh = DBI->connect($dsn, $user, $password);
if($dbh)
{
	print "\nConnected: $database\n";
}

$dbh->disconnect(); 
# call run long running external process

$dbh = DBI->connect($dsn, $user, $password);
$dbh->disconnect();   #twenty minutes for this connection to die






