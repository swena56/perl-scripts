package BEI::DB;

use Exporter 'import'; # gives you Exporter's import() method directly
@EXPORT_OK = qw(connect);  # symbols to export on request

use strict;
use warnings;
use DBI;

use constant DB_NAME => 'bei_training';

=pod

	TODO
		-rewrite so connect will optionally allow any connection details passed
		-create database if it does not exist
=cut
sub connect {

	# establish database connection
	my $database = shift || DB_NAME;
	my $hostname = 'localhost';
	my $port = '3306';
	my $user = 'bei-training';
	my $password = 'bei-training';

	print "[+] Attempting to connect to DB at: mysql://$user:$password@".$hostname .":$port/$user";

	my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
	my $dbh = DBI->connect($dsn, $user, $password,  {RaiseError => 1})
	              or die $DBI::errstr;	

	print "...connection established.\n\n";
	return $dbh;
}


1;
