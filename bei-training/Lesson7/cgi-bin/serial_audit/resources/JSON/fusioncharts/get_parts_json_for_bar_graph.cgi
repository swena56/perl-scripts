#!/usr/bin/perl
use strict;
#use CGI;
use CGI ':standard';
use CGI::Pretty;
use CGI::Carp qw(fatalsToBrowser);
use Template;
use CGI::Ajax;
use Data::Dumper;

use XML::Writer;
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson6/lib);
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson6/templates);

use BEI::DB 'connect';
use JSON;

my $q = CGI->new();

my $service_id = $q->param('service_id');
my @results =  $q->param('results');

#print $q->header();  #is required for the browser to know what content
print header; 
print $q->header(-type => "text/xml", -charset => "utf-8");

$service_id = 712;
if($service_id ne "") {
		my $dbh = &connect();

		if($dbh){

		my $sth = $dbh->prepare("
SELECT sp.part_number, service_parts.service_id, s.serial_number, service_parts.cost, mc.meter_code
FROM service_parts
JOIN parts AS sp ON service_parts.part_id = sp.part_id
JOIN service AS ser ON service_parts.service_id = ser.service_id
JOIN serials AS s ON ser.serial_id = s.serial_id
JOIN service_meters AS sm ON sm.service_id = ser.service_id
JOIN meter_codes AS mc ON sm.meter_code_id = mc.meter_code_id
WHERE service_parts.service_id = ?"
			);

		$sth->execute($service_id);	
		my $num_rows = $sth->rows;

		
		my @table_data = [];
		
		my @columns = ('Part Number, Service ID, Serial Number, Part Cost, Meter Code');
		push @table_data,th($sth->{NAME});
		
		while (my @row = $sth->fetchrow_array) {	
		    push @table_data, @row;
		}

		#close database connection
		$sth->finish();
		my $op = JSON -> new -> utf8 -> pretty(1);
		my $json = $op -> encode({
			num_rows => $num_rows,
			columns => \@columns,
		    result => \@table_data
		});
		print $json;
	}
}

exit;
	#!/usr/bin/perl
use strict;
#use CGI;
use CGI ':standard';
use CGI::Pretty;
use CGI::Carp qw(fatalsToBrowser);
use Template;
use CGI::Ajax;
use Data::Dumper;

use XML::Writer;
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson6/lib);
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson6/templates);

use BEI::DB 'connect';
use JSON;

my $q = CGI->new();

my $service_id = $q->param('service_id');
my @results =  $q->param('results');

#print $q->header();  #is required for the browser to know what content
print header; 
print $q->header(-type => "text/xml", -charset => "utf-8");

$service_id = 712;
if($service_id ne "") {
		my $dbh = &connect();

		if($dbh){

		my $sth = $dbh->prepare("
SELECT sp.part_number, service_parts.service_id, s.serial_number, service_parts.cost, mc.meter_code
FROM service_parts
JOIN parts AS sp ON service_parts.part_id = sp.part_id
JOIN service AS ser ON service_parts.service_id = ser.service_id
JOIN serials AS s ON ser.serial_id = s.serial_id
JOIN service_meters AS sm ON sm.service_id = ser.service_id
JOIN meter_codes AS mc ON sm.meter_code_id = mc.meter_code_id
WHERE service_parts.service_id = ?"
			);

		$sth->execute($service_id);	
		my $num_rows = $sth->rows;

		
		my @table_data = [];
		
		my @columns = ('Part Number, Service ID, Serial Number, Part Cost, Meter Code');
		push @table_data,th($sth->{NAME});
		
		while (my @row = $sth->fetchrow_array) {	
		    push @table_data, @row;
		}

		#close database connection
		$sth->finish();
		my $op = JSON -> new -> utf8 -> pretty(1);
		my $json = $op -> encode({
			num_rows => $num_rows,
			columns => \@columns,
		    result => \@table_data
		});
		print $json;
	}
}

exit;
	