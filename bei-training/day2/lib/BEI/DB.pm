package BEI::DB;

use Exporter 'import'; # gives you Exporter's import() method directly
@EXPORT_OK = qw(connect);  # symbols to export on request

use strict;
use warnings;
use DBI;

sub connect {

	# establish database connection
	my $database = shift || 'bei_training';
	my $hostname = 'localhost';
	my $port = '3306';
	my $user = 'bei-training';
	my $password = 'bei-training';

	my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
	my $dbh = DBI->connect($dsn, $user, $password,  {RaiseError => 1})
	              or die $DBI::errstr;	

	print "[+] Connected successfully to: mysql://$user:$password@".$hostname .":$port/$user\n\n";
	return $dbh;
}

1;