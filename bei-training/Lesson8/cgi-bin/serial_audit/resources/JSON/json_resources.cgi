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
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson8/lib);


use BEI::DB 'connect';
use JSON;

my $q = CGI->new();

my $serial = $q->param('serial');


my $response = $q->param('response');

#print $q->header();  #is required for the browser to know what content

print  header('application/json');

sub serial_search {

	my $serial = shift || die("serial search needs serial number")

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
		while (my @row = $sth->fetchrow_array) {	
		    push @table_data, \@row;
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
			user_input => $serial,
		});
		
		print $json;
	}
}
}


sub render_meter_codes_template {

	my $input = shift || die("[!] Render Parts Table needs a service_id for parameter 1");
	
	if($dbh){

		my $sql = "	SELECT s.serial_number, mc.meter_code, mc.meter_description, sm.meter
					FROM service AS ser
					JOIN serials AS s ON ser.serial_id = s.serial_id
					JOIN service_meters AS sm ON ser.service_id = sm.service_id
					JOIN meter_codes AS mc ON sm.meter_code_id = mc.meter_code_id
					WHERE ser.service_id = ?";

		my $sth = $dbh->prepare($sql);

		$sth->execute($input);				
		$num_rows = $sth->rows;
		
		my $total_parts_cost = 0;

		@columns = ('Serial Number',  'Meter Code', 'Meter Description', 'Meter');
		
		#set message about data found
		my $message_text_color = ($num_rows <= 0) ? 'red' : 'green' ;					   
		my $message = "<p> <span style='color:$message_text_color;'> Found $num_rows parts</span></p>" ;

		my @table_data = [];
	    my $currency_type = "\$";

		while (my $row = $sth->fetchrow_hashref) {
			push @table_data, $row;
			
		}		  

		#close database connection
		$sth->finish();	
	    
	    my $debug = Dumper(@table_data);
		my $vars = {
		  	user_input => $input,
		  	columns => \@columns,
		  	title => 'Meter Codes List',
		  	table_data => \@table_data,
		  	var_dump_data => $debug,
		  	message => $message,
		  	commify => \&commify	  	
		};

		my $output = '';
		$template->process('section/model.tpl', $vars,\$output)  || die $template->error();

		return $output;
} 
    return "error loading template";
}

sub render_parts_template {
	my $input = shift || die("[!] Render Parts Table needs a service_id for parameter 1");
	
	if($dbh){

		my $sth = $dbh->prepare("
					SELECT sp.part_number, s.serial_number, ROUND(service_parts.cost,2)
				FROM service_parts
				JOIN parts AS sp ON service_parts.part_id = sp.part_id
				JOIN service AS ser ON service_parts.service_id = ser.service_id
				JOIN serials AS s ON ser.serial_id = s.serial_id
				JOIN service_meters AS sm ON sm.service_id = ser.service_id
				JOIN meter_codes AS mc ON sm.meter_code_id = mc.meter_code_id
				WHERE service_parts.service_id = ?"
		);

		$sth->execute($input);				
		$num_rows = $sth->rows;
		
		my $total_parts_cost = 0;

		@columns = ('Part Number',  'Serial Number', 'Part Cost');
		
		#set message about data found
		my $message_text_color = ($num_rows <= 0) ? 'red' : 'green' ;					   
		my $message = "<p> <span style='color:$message_text_color;'> Found $num_rows</span></p>" ;

		my @table_data = [];
	   
		my $currency_type = "\$";
		while (my @row = $sth->fetchrow_array) {
			
			$total_parts_cost += @row[2];
			@row[2] = ("$currency_type" . @row[2]);
			push @table_data, [@row];
		}		  

		#close database connection
		$sth->finish();	
			
	    my $debug = Dumper(@table_data);
		my $vars = {
		  	user_input => $input,
		  	columns => \@columns,
		  	title => 'Parts List',
		  	table_data => \@table_data,
		  	var_dump_data => $debug,
		  	message => $message,
		  	total_parts_cost => ("Total Parts Cost: $currency_type" . nearest( .01, $total_parts_cost ))
		};

		my $output = '';
		$template->process('section/model.tpl', $vars,\$output)  || die $template->error();

		return $output;
} 
    return "error loading template";
}
exit;