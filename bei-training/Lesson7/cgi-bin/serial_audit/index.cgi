#!/usr/bin/perl
use strict;
#use CGI;
use CGI ':standard';
use CGI::Pretty;
use CGI::Carp qw(fatalsToBrowser);
use Template;
use CGI::Ajax;
use Data::Dumper;
use Math::Round;
use JSON;

use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson7/lib);

#use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson6/);

my $template = Template->new(
	  INCLUDE_PATH => '/home/ubuntu/perl-scripts/bei-training/Lesson7/cgi-bin/serial_audit/templates/'
	
);

use BEI::DB 'connect';
my $dbh = &connect();

my $cgi = CGI->new();
#print $cgi->header();  

my $serial = $cgi->param('serial');
my $status = $cgi->param('status');
my $service_id = $cgi->param('service_id');
my @parts =  $cgi->param('parts');

my @table_data;
my $num_rows = 0;
my $table_name;
my @columns;
my $message;

my $pjx = new CGI::Ajax( 'render_serials_table' => \&render_serials_table, 					
						'render_meter_codes_template' => \&render_meter_codes_template,
						'render_parts_template' => \&render_parts_template
						
						 );

if($status)
{


} else{
	print $pjx->build_html( $cgi, \&Show_HTML);	
}

sub commify {
	my $str = reverse shift || die("commify needs a string to work.");
	$str =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
	return scalar reverse $str;
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

sub Show_HTML {

	  my $vars = {
		title => "Serial Audit",
	    about  => 'about serial audit.....',
	    guest_welcome_message  => 'Welcome to Serial Audit Guest User ',
	    message => $message,
	    menu => [],
	    table_name => $table_name,
	    table_columns => \@columns,
	    table_data  => \@table_data,
	    number_results => $num_rows,
	    render_parts_template => \&render_parts_template, 
	    render_meter_codes_template => \&render_meter_codes_template,
	    footer  => 'By: Andrew Swenson',	   
	};

    my $output = '';
    $template->process('section/serial_table.tpl', $vars,\$output)  || die $template->error();
    

	    return $output;
  }

exit;