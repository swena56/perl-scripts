#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use File::Spec;
use FindBin;

use lib "$FindBin::Bin/lib";
use BEI::DB 'connect';



use Data::Dumper;




my $dbh = &connect();



if($dbh)
{
	print "connected\n";
	my $serial = "00000-000";
	my $sql = "SELECT * FROM serials where serial_number=?";
	

	my $sth = $dbh->prepare($sql);
	$sth->execute($serial);

	while (my @data = $sth->fetchrow_array()) {
            print "@data\n";
           }
    
    my $sql2 = ""


    SELECT serial_number, model_number, technician_number 
	FROM service AS srv
	JOIN serials AS s ON srv.serial_id = s.serial_id
	JOIN models AS m ON s.model_id = m.model_id
	JOIN technicians AS t ON srv.technician_id = t.technician_id
	WHERE serial_number = '00000-000' 
	#AND call_id = 'SC64445'
	AND technician_number = '1037'
	AND model_number = 'LD117SPF';

	
	
}