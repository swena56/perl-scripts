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
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson7/lib);
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson7/cgi-bin/serial_audit/templates);

use BEI::DB 'connect';
use JSON;

my $q = CGI->new();


my $serial = $q->param('serial');
my $selected_index = $q->param('selected_index');

my $status = $q->param('status');
my $service_id = $q->param('service_id');
my @parts =  $q->param('parts');

my $response = $q->param('response');

#print $q->header();  #is required for the browser to know what content

print  header('application/json');


if($serial ne "") {
		my $dbh = &connect();

		if($dbh){
		
		my $currency_type = "\\\$";

		my $sth = $dbh->prepare("
		SELECT serial_number, model_number, call_type, completion_datetime, technician_number,
			s.call_id_not_call_type, CONCAT('$currency_type', ROUND(SUM(cost),2) ) AS total_parts_cost, s.service_id
		FROM service AS s 
		JOIN serials ON s.serial_id = serials.serial_id
		JOIN models AS m ON serials.model_id = m.model_id
		JOIN technicians AS t ON s.technician_id = t.technician_id
		JOIN call_types AS c ON s.call_type_id = c.call_type_id
		LEFT JOIN service_parts AS sp ON s.service_id = sp.service_id
		#WHERE serial_number LIKE '%?' 
		WHERE serial_number LIKE " . $dbh->quote('%'.$serial.'%') ."
		GROUP BY s.service_id
		ORDER BY completion_datetime DESC"
		);

		$sth->execute();	
		my $num_rows = $sth->rows;

		my @table_data;

		my @columns = ('Serial Number', 'Model Number', 'Call Type', 'Completion DateTime', 'Tech #',
					'Call ID', 'Total Part Cost', 'Service Call Actions');

		
		my @raw_columns = $sth->{NAME};
		while (my $row = $sth->fetchrow_hashref) {	
		    push @table_data, $row;
		}

		#close database connection
		$sth->finish();
		#
		my $op = JSON -> new -> utf8 -> pretty(1);
		my $json = $op -> encode({
			num_rows => $num_rows,
			columns => \@columns,
			result_data => \@table_data,
			raw_columns => \@raw_columns,
			user_input => $serial
		});
		
		print $json;
	}
}

exit;