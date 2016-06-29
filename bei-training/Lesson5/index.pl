#!/usr/bin/perl
use strict;
use warnings;

use CGI;

use FindBin;
use File::Spec;
use lib "$FindBin::Bin/lib";

use Data::Dumper;
use BEI::DB 'connect';

use BEI::Utils qw(
    extract_zip
    verify_zip
    make_temp_directory
    normalize_file_names
    get_temp_file_listing
    get_file_line_count
    cleanup_temp_directory
);
print qq(Content-type: text/plain\n\n); 
print '<HTML>';
print "Content-type:text/html\r\n\r\n";
print '<html>';
print '<head>';
print '<title>Hello Word - First CGI Program</title>';
print '</head>';
print '<body>';

my $dbh = &connect();

if($dbh)
{
	print "<p> DB: connected </p>";
	print scalar localtime;
	my $sth = $dbh->prepare("SELECT * from serials");

	$sth->execute();
	while($sth)
	{
	my @data = $sth->fetchrow_array();
	print Dumper(@data);
	print "@data";
	}
}
print '<h2>Hello Word! This is my first CGI program</h2>';
print '</body>';
print '</html>';


