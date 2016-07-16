#!/usr/bin/perl
use strict;
use CGI ':standard';
use CGI::Carp qw(fatalsToBrowser);
use Template;
use CGI::Ajax;
use Data::Dumper;
use Math::Round;
use JSON;

use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson8/lib);
use BEI::DB 'connect';
use BEI::DB::Service 'get_call_dates_list';

my $cgi = CGI->new();  

my $template = Template->new(
	  INCLUDE_PATH => 	'/home/ubuntu/perl-scripts/bei-training/Lesson8/cgi-bin/serial_audit/service_calls/'
);

my $pjx = new CGI::Ajax( 				
	'render_meters_template' => \&render_meters_template,
	'render_parts_template' => \&render_parts_template,
);

my $search_input = $cgi->param('search_input');
my $order_by = $cgi->param('order_by');
my $direction = $cgi->param('direction');
my $page = $cgi->param('page');

#get list of active service dates
my $dbh = &connect();
my @active_calldates = &get_call_dates_list($dbh);
$dbh->disconnect;

print $pjx->build_html( $cgi, \&Show_HTML);	

sub render_meters_template {

	my $input = shift || die("[!] Render Parts Table needs a service_id for parameter 1");
	
	my $dbh = &connect();

	my $sql = "	SELECT s.serial_number, mc.meter_code, mc.meter_description, sm.meter, m.model_number
				FROM service AS ser
				JOIN serials AS s ON ser.serial_id = s.serial_id
				JOIN models AS m ON s.model_id = m.model_id
				JOIN service_meters AS sm ON ser.service_id = sm.service_id
				JOIN meter_codes AS mc ON sm.meter_code_id = mc.meter_code_id
				WHERE ser.service_id = ?";

	my $sth = $dbh->prepare($sql);

	$sth->execute($input);				
	my $num_rows = $sth->rows;
	
	my $total_parts_cost = 0;

	my @columns = ('Serial Number',  'Meter Code', 'Meter Description', 'Meter');
	
	#set message about data found
	my $message_text_color = ($num_rows <= 0) ? 'red' : 'green' ;					   
	my $message = "<p> <span style='color:$message_text_color;'> Found $num_rows parts</span></p>" ;

	my @table_data;
    my $currency_type = "\$";
    my $model_number;

	while (my $row = $sth->fetchrow_hashref) {
		$model_number = $row->{model_number} if(!defined($model_number));
		push @table_data, $row;		
	}		  

	#close database connection
	$sth->finish();		    
  
	my $vars = {
		title => "Meter Codes",
		model_number => $model_number,
	  	user_input => $input,
	  	columns => \@columns,		  	
	  	table_data => \@table_data,
	  	message => $message,
	  	commify => \&commify,	  	
	};

	my $output = '';
	$template->process('search/pop_models/meter_model.tpl', $vars,\$output);

	return $output;
}

sub render_parts_template {
	my $input = shift || die("[!] Render Parts Table needs a service_id for parameter 1");
	
	my $dbh = &connect();

	if($dbh){

		my $sth = $dbh->prepare("
				SELECT sp.part_number, s.serial_number, m.model_number, ROUND(service_parts.cost,2) AS parts_cost
				FROM service_parts
				JOIN parts AS sp ON service_parts.part_id = sp.part_id
				JOIN service AS ser ON service_parts.service_id = ser.service_id
				JOIN serials AS s ON ser.serial_id = s.serial_id
				JOIN models AS m ON s.model_id = m.model_id
				JOIN service_meters AS sm ON sm.service_id = ser.service_id
				JOIN meter_codes AS mc ON sm.meter_code_id = mc.meter_code_id
				WHERE service_parts.service_id = ?"
		);

		$sth->execute($input);				
		my $num_rows = $sth->rows;
		
		my @columns = ('Part Number',  'Serial Number', 'Part Cost');
		
		#set message about data found
		my $message_text_color = ($num_rows <= 0) ? 'red' : 'green' ;					   
		my $message = "<p> <span style='color:$message_text_color;'> Found $num_rows</span></p>" ;

		my @table_data;
	   	my $total_parts_cost = 0;
	   	my $model_number;

		my $currency_type = "\$";
		while (my $row = $sth->fetchrow_hashref) {
			$total_parts_cost += $row->{parts_cost};

			$model_number = $row->{model_number} if(!$model_number);

			$row->{parts_cost} = "$currency_type $row->{parts_cost}";
			push @table_data, $row;
		}		  

		#close database connection
		$sth->finish();	

	    my $debug = Dumper(@table_data);
		my $vars = {
		  	user_input => $input,
		  	columns => \@columns,
		  	title => 'Parts List',
		  	model_number => $model_number,
		  	table_data => \@table_data,
		  	var_dump_data => $debug,
		  	total_parts_cost => $total_parts_cost,
		  	currency_type => $currency_type,
		  	message => $message
		};

		my $output = '';
		$template->process('search/pop_models/parts_model.tpl', $vars,\$output);

		return $output;
	} 
    return "error loading parts model template";
}

sub Show_HTML {
	my $vars = {
		input => $search_input,
			service_date_range => \@active_calldates,
	};

	my $output = '';
	$template->process('index.tpl', $vars,\$output)  || die $template->error();
	
	return $output;
}

sub commify {
	my $str = reverse shift || die("commify needs a string to work.");
	$str =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
	return scalar reverse $str;
}

exit;