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
use BEI::JSON_response 'serial_search';


my $cgi = CGI->new();  

my @table_data;
my $num_rows = 0;
my $table_name;
my @columns;
my $message;

my $pjx = new CGI::Ajax( 'render_serials_table' => \&render_serials_table, 					
						'render_meters_template' => \&render_meters_template,
						'render_parts_template' => \&render_parts_template,
						'top_ten_models_for_month_index' => \&top_ten_models_for_month_index,
						'top_ten_call_types_month_index' => \&top_ten_call_types_month_index
						 );

print $pjx->build_html( $cgi, \&Show_HTML);	

sub top_ten_call_types_month_index {

	# need a group by method
	my $month_index = shift || 0;
	my $dbh = &connect();

	#|Top Ten Models by total calls for the month         |
	my $sth = $dbh->prepare("
SELECT src.call_type, src.total_calls, src.month, src.completion_datetime
FROM (
SELECT c.call_type,COUNT(c.call_type) AS total_calls, completion_datetime, MONTH(completion_datetime) AS month
FROM service AS s 
JOIN serials ON s.serial_id = serials.serial_id
JOIN call_types AS c ON s.call_type_id = c.call_type_id
GROUP BY c.call_type) AS src
WHERE src.month = ?
ORDER BY src.total_calls DESC LIMIT 10;
");
	my @table_data;
	$sth->execute($month_index);
	if($sth->rows > 0){   

		while(my $row = $sth->fetchrow_hashref){
			push @table_data, $row;		
		}	
	}

	$sth->finish();	

	return \@table_data;
}

sub top_ten_models_for_month_index {

	# need a group by method
	my $month_index = shift || 0;
	my $dbh = &connect();

	#|Top Ten Models by total calls for the month         |
	my $sth = $dbh->prepare("
	SELECT src.model_number, src.model_count, src.completion_datetime 
	FROM (
	SELECT m.model_number AS model_number,COUNT(m.model_number) AS model_count, MONTH(completion_datetime) AS month, completion_datetime
	FROM service AS s 
	JOIN serials ON s.serial_id = serials.serial_id
	JOIN models AS m ON serials.model_id = m.model_id
	JOIN technicians AS t ON s.technician_id = t.technician_id
	JOIN call_types AS c ON s.call_type_id = c.call_type_id
	GROUP BY m.model_number
	) AS src
	WHERE src.month = ?
	ORDER BY src.model_count DESC LIMIT 10;
	");
	$sth->execute($month_index);

	my @columns = ('Model Number', 'Amount', 'Date');
	my @table_data;

	if($sth->rows > 0){   

		while(my $row = $sth->fetchrow_hashref){
			push @table_data, $row;		
		}	
	}



	$sth->finish();	

	my $debug_dump = Dumper(@table_data);

	my $vars = {
			title => "Top Ten Models",
		  	table_data => \@table_data,
		  	table_columns => \@columns,
		  	debug => $debug_dump,
		};

		return $vars;
}

sub render_meters_template {

	my $input = shift || die("[!] Render Parts Table needs a service_id for parameter 1");
	
	my $dbh = &connect();

	if($dbh){

		my $sql = "	SELECT s.serial_number, mc.meter_code, mc.meter_description, sm.meter, m.model_number
					FROM service AS ser
					JOIN serials AS s ON ser.serial_id = s.serial_id
					JOIN models AS m ON s.model_id = m.model_id
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
		$template->process('section/pop_models/meter_model.tpl', $vars,\$output)  || die $template->error();

		return $output;
} 
    return "error loading template";
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
		$num_rows = $sth->rows;
		
		

		@columns = ('Part Number',  'Serial Number', 'Part Cost');
		
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
		$template->process('section/pop_models/parts_model.tpl', $vars,\$output)  || die $template->error();

		return $output;
} 
    return "error loading parts model template";
}

sub Show_HTML {

	#+------------+
	#| dashboard  |
	#+------------+
	my $dbh = &connect();

#i need to worry about closing my db after dashboard
	my %dashboard_data = ( 'top_ten_call_types_month' => '');
	
	my @total_values_array;
	
	#|current month|
	my $current_month = '3';
	my $sth = $dbh->prepare("
		SELECT src.month_index, src.month
		FROM (
		SELECT MONTH(completion_datetime) as month_index, MONTHNAME(completion_datetime) as month 
		FROM service 
		GROUP BY month_index
		ORDER BY completion_datetime DESC LIMIT 1
		) AS src;
	");
	$sth->execute(); 	#expecting 1 row
	if($sth->rows == 1){   
		my $row = $sth->fetchrow_hashref;	
		#push @dashboard_data, $row;	
		$dashboard_data{'month'} .= $row->{'month'};
		$dashboard_data{'month_index'} .= $row->{'month_index'};
	}


	#|Total Calls |
	my $sth = $dbh->prepare("SELECT count(*) AS total_calls FROM service");
	$sth->execute(); 	#expecting 1 row
	if($sth->rows == 1){   
		my $row = $sth->fetchrow_hashref;	
		#push @dashboard_data, $row;	
		$dashboard_data{'total_calls'} .= $row->{'total_calls'};
	}

	#|Total Parts |
	my $sth = $dbh->prepare("SELECT count(*) AS total_parts FROM parts;");
	$sth->execute();	#expecting 1 row
	if($sth->rows == 1){   
		my $row = $sth->fetchrow_hashref;	
		$dashboard_data{'total_parts'} .= $row->{'total_parts'};
		#push @dashboard_data, $row;	
	}

	#|Total Serials w/ Calls |
	my $sth = $dbh->prepare("SELECT count(*) AS total_serials_w_calls 
								FROM service 
								JOIN serials AS s ON s.serial_id = service.serial_id;");
	$sth->execute();	#expecting 1 row
	if($sth->rows == 1){   
		my $row = $sth->fetchrow_hashref;	
		$dashboard_data{'total_serials_w_calls'} .= $row->{'total_serials_w_calls'};
		#push @dashboard_data, $row;	
	}

	#|Total Techs w/ Calls |
	my $sth = $dbh->prepare("SELECT count(*) AS total_techs_w_calls FROM technicians
JOIN service AS ser ON ser.technician_id = technicians.technician_id ;");
	$sth->execute();	#expecting 1 row
	if($sth->rows == 1){   
		my $row = $sth->fetchrow_hashref;	
		$dashboard_data{'total_techs_w_calls'} .= $row->{'total_techs_w_calls'};
		#push @dashboard_data, $row;	
	}

	#|Total Models w/ Calls|
	my $sth = $dbh->prepare("SELECT count(*) AS total_models_w_calls FROM models
							JOIN serials AS s ON s.model_id = models.model_id
							JOIN service AS ser ON ser.serial_id = s.serial_id ;");
	$sth->execute();	#expecting 1 row
	if($sth->rows == 1){   
		my $row = $sth->fetchrow_hashref;	
		$dashboard_data{'total_models_w_calls'} .= $row->{'total_models_w_calls'};
		#push @dashboard_data, $row;	
	}

	#|    Top Ten Calltypes by total calls for the month     |
my $sth = $dbh->prepare("
SELECT src.call_type, src.total_calls, src.month, src.completion_datetime
FROM (
SELECT c.call_type,COUNT(c.call_type) AS total_calls, MONTH(completion_datetime) AS month, completion_datetime
FROM service AS s 
JOIN serials ON s.serial_id = serials.serial_id
JOIN call_types AS c ON s.call_type_id = c.call_type_id
GROUP BY c.call_type) 
AS src
WHERE src.month = 5
ORDER BY src.total_calls DESC LIMIT 10;
");
	$sth->execute();	#expecting 1 row
	if($sth->rows > 0){   

		my @top_ten_call_types;
		while(my $row = $sth->fetchrow_hashref){
			push @top_ten_call_types, $row;
			#$dashboard_data{'top_ten_call_types_month'} .= $row;
		}	
		#
	}


#|      - Top Ten Techs by total calls for the month            |
	my $sth = $dbh->prepare("
SELECT src.technician_number, src.tech_count, src.month, src.completion_datetime 
FROM (
SELECT t.technician_number AS technician_number,COUNT(t.technician_id) AS tech_count, MONTH(completion_datetime) AS month, completion_datetime
FROM service AS s 
JOIN technicians AS t ON s.technician_id = t.technician_id
GROUP BY t.technician_number
) AS src
WHERE src.month = 5
ORDER BY src.tech_count  DESC LIMIT 10;
");
	$sth->execute();	#expecting 1 row
	if($sth->rows > 0){   

		my @top_ten_techs;
		while(my $row = $sth->fetchrow_hashref){
			push @top_ten_techs, $row;		
		}	
		#push @dashboard_data, @top_ten_techs;		
	}

#|      Top Ten Models by total calls for the month         |
	my $sth = $dbh->prepare("
SELECT src.model_number, src.model_count, src.month, src.completion_datetime 
FROM (
SELECT m.model_number AS model_number,COUNT(m.model_number) AS model_count, MONTH(completion_datetime) AS month, completion_datetime
FROM service AS s 
JOIN serials ON s.serial_id = serials.serial_id
JOIN models AS m ON serials.model_id = m.model_id
JOIN technicians AS t ON s.technician_id = t.technician_id
JOIN call_types AS c ON s.call_type_id = c.call_type_id
GROUP BY m.model_number
) AS src
WHERE src.month = 5
ORDER BY src.model_count DESC LIMIT 10;
");
	$sth->execute();	#expecting 1 row
	if($sth->rows > 0){   

		my @top_ten_models;
		while(my $row = $sth->fetchrow_hashref){
			push @top_ten_models, $row;		
		}	
		#push @dashboard_data, @top_ten_models;		
	}
	$sth->finish();	

	#print debug code
	my $debug = Dumper(%dashboard_data);
	#+-------------------+
	#| end of dashboard  |
	#+-------------------+
	#index start template
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
	    render_parts => \&render_parts_template, 
	    render_meter => \&render_meter_codes_template,
	    top_ten_models_for_month_index => \&top_ten_models_for_month_index,
	    top_ten_call_types_month_index => \&top_ten_call_types_month_index,
	    debug => $debug,
	    dashboard_title => 'Service Call Analytics Dashboard',
	    dashboard_data => \%dashboard_data,
#display_dashboard => \&display_dashboard,
	    footer  => 'By: Andrew Swenson',	   
	};

    my $output = '';
    $template->process('section/index.tpl', $vars,\$output)  || die $template->error();
    

	    return $output;
  }

#am not allowed to do this
sub display_dashboard {
		my $vars = {
		  	title => "Service Calls Analytics",
		};

		my $output = '';
		$template->process('section/dasboard_serials.tpl', $vars,\$output)  || die $template->error();

		return $output;
}

sub commify {
	my $str = reverse shift || die("commify needs a string to work.");
	$str =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
	return scalar reverse $str;
}
exit;