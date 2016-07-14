#!/usr/bin/perl
use strict;
use CGI ':standard';
use CGI::Carp qw(fatalsToBrowser);
use Template;
use Data::Dumper;
use JSON;

use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson8/lib);
use BEI::DB 'connect';
use List::Util qw(min max);

my $template = Template->new(
	  INCLUDE_PATH => '/home/ubuntu/perl-scripts/bei-training/Lesson8/cgi-bin/serial_audit/dashboard/'
);

my $cgi = CGI->new();  
my $id = $cgi->param('id');
my $type = $cgi->param('type');

print "Content-type: text/html\n\n";
#TODO review how I am closing my connection, there might be an issue here
my $dbh = &connect();			

sub available_months {
	my @available_months;
	my $dbh = &connect();
	my $sth = $dbh->prepare("SELECT month(completion_datetime) FROM service GROUP BY month(completion_datetime) ORDER BY month(completion_datetime);");
	$sth->execute();
	while(my @row = $sth->fetchrow_array){
		push @available_months, @row;
	}
	$sth->finish();
	return @available_months;
}

if(!$type){
	print "Graph is not implemented in graphing engine for type: $type and id: $id";
	exit;
}

if($type eq "calltypes_by_totalcalls"){

	my $sth = $dbh->prepare("
	SELECT ct.call_type, COUNT(ct.call_type_id) as total_calls, MONTH(s.completion_datetime) as month_index, MONTHNAME(s.completion_datetime) as month
	FROM service AS s 
	JOIN call_types AS ct on s.call_type_id = ct.call_type_id
	WHERE ct.call_type = ?
	GROUP BY MONTH(s.completion_datetime)
	ORDER BY MONTH(s.completion_datetime);
	");
	$sth->execute($id);

	my @table_data;
	my @columns;
	my @num_calls;
	
	while(my $row = $sth->fetchrow_hashref){
		push @table_data, $row;	

		if($row->{total_calls} > 0){
			push @columns, $row->{month};
			push @num_calls, $row->{total_calls};	
		}
	}	
	$sth->finish();	

	my $debug = Dumper($type) . Dumper(@columns);
	my $min = (min @num_calls);
	my $max = (max @num_calls);
	my $num_of_months = scalar @columns;

	my $vars = {
		title => "Totals Calls - Call Types",
		about => "$id: @columns[0] - @columns[$num_of_months - 1] ",
		data_type => "calls",
		columns => [@columns],
		data => [@num_calls],
		height => 150,
		width => 400,
		min => ($min-1),
		max => $max,
		#debug => $debug,
	};

   my $output = '';
   $template->process('templates/graphs/horizontal_bar.tpl', $vars,\$output)  || die $template->error();
   print $output;

   exit;
}
if($type eq "models_by_partscost"){

	my $sth = $dbh->prepare("
	SELECT m.model_number, SUM(sp.cost) as total_parts_cost, MONTH(s.completion_datetime) as month_index, MONTHNAME(s.completion_datetime) as month
	FROM service AS s 
	JOIN serials ON s.serial_id = serials.serial_id
	JOIN models AS m ON m.model_id = serials.model_id
	JOIN service_parts AS sp ON sp.service_id = s.service_id
	JOIN parts AS p ON p.part_id = sp.part_id
	WHERE m.model_number = ?
	GROUP BY MONTH(s.completion_datetime)
	ORDER BY MONTH(s.completion_datetime);
	");
	$sth->execute($id);

	#initalize storage
	my @table_data;
	my @columns;
	my @parts_cost;

	while(my $row = $sth->fetchrow_hashref){
		push @table_data, $row;	
		push @columns, $row->{month};
		push @parts_cost, $row->{total_parts_cost};
	}	
	$sth->finish();	

	my $debug = Dumper($type) . Dumper(@columns);
	my $num_of_months = scalar @columns;
	my $min = (min @parts_cost);
	my $max = (max @parts_cost);
	
	my $vars = {
		title => "Total Parts Cost - Model: $id",
		about => "@columns[0] - @columns[$num_of_months - 1] ",
		columns => [@columns],
		data => [@parts_cost],
		height => 150,
		width => 450,
		min => 700,
		max => 400,
		#debug => $debug,
	};

	my $output = '';
   $template->process('templates/graphs/horizontal_bar.tpl', $vars,\$output)  || die $template->error();
   print $output;
   exit;
}
if($type eq "models_by_totalcalls"){

	my $sth = $dbh->prepare("
	SELECT m.model_number, SUM(ct.call_type_id) as total_calls, MONTH(s.completion_datetime) as month_index, MONTHNAME(s.completion_datetime) as month
	FROM service AS s 
	JOIN serials ON s.serial_id = serials.serial_id
	JOIN models AS m ON m.model_id = serials.model_id
	JOIN call_types AS ct on s.call_type_id = ct.call_type_id
	WHERE m.model_number = ?
	GROUP BY MONTH(s.completion_datetime)
	ORDER BY MONTH(s.completion_datetime);
	");
	$sth->execute($id);

	my @table_data;
	my @columns;
	my @num_calls;
	my $num_rows =  $sth->rows;
	
		while(my $row = $sth->fetchrow_hashref){
			push @table_data, $row;	
			push @columns, $row->{month};
			push @num_calls, $row->{total_calls};
		}	
	
	$sth->finish();	
	my $debug = Dumper($type) . Dumper(@columns);

	my $num_of_months = scalar @columns;
	my $vars = {
	title => "Totals Calls - Model",
	about => "$id: @columns[0] - @columns[$num_of_months - 1] ",
	columns => [@columns],
	data => [@num_calls],
	height => 150,
	width => 400,
	min => 1,
	max => 50,
	#debug => $debug,
	};

	my $output = '';
   $template->process('templates/graphs/horizontal_bar.tpl', $vars,\$output)  || die $template->error();

   print $output;

   exit;
}
if($type eq "parts_by_partscost"){
	#not returning all the months 'JC92-02429A'  GB0649645
		my $sth = $dbh->prepare("
	SELECT p.part_number, FORMAT(SUM(sp.cost),2) as total_parts_cost, MONTH(s.completion_datetime) as month_index, MONTHNAME(s.completion_datetime) as month
	FROM service AS s 
	JOIN serials ON s.serial_id = serials.serial_id
	JOIN service_parts AS sp ON sp.service_id = s.service_id
	JOIN parts AS p ON p.part_id = sp.part_id
	WHERE p.part_number = ?
	GROUP BY MONTH(s.completion_datetime)
	ORDER BY MONTH(s.completion_datetime);
	");
	$sth->execute($id);

	my @table_data;
	my @columns;
	my @num_calls;

	while(my $row = $sth->fetchrow_hashref){
		push @table_data, $row;	
		push @columns, $row->{month};
		push @num_calls, $row->{total_parts_cost};
	}	

	$sth->finish();	
	my $debug = Dumper($type) . Dumper(@columns);
	my $num_of_months = scalar @columns;

	my $vars = {
		title => "Total Parts Cost - Part Number: $id",
		about => "@columns[0] - @columns[$num_of_months - 1] ",
		columns => [@columns],
		data => [@num_calls],
		height => 150,
		width => 400,
		min => 700,
		max => 50,
		#debug => $debug,
	};

	my $output = '';
   $template->process('templates/graphs/horizontal_bar.tpl', $vars,\$output)  || die $template->error();
   print $output;
   exit;
}
if($type eq "techs_by_partscost"){

	#2057 
	my $sth = $dbh->prepare("
	SELECT t.technician_number, SUM(sp.cost) as total_parts_cost, MONTH(s.completion_datetime) as month_index, MONTHNAME(s.completion_datetime) as month
	FROM service AS s 
	JOIN serials ON s.serial_id = serials.serial_id
	JOIN technicians AS t ON t.technician_id = s.technician_id
	JOIN service_parts AS sp ON sp.service_id = s.service_id
	WHERE t.technician_number = ?
	GROUP BY MONTH(s.completion_datetime)
	ORDER BY MONTH(s.completion_datetime);
	");
	$sth->execute($id);

	my @table_data;
	my @columns;
	my @part_cost;

	while(my $row = $sth->fetchrow_hashref){
		push @table_data, $row;	
		push @columns, $row->{month};
		push @part_cost, $row->{total_parts_cost};
	}	
	$sth->finish();	

	my $debug = Dumper($type) . Dumper(@columns);
	my $num_of_months = scalar @columns;
	my $vars = {
		title => "Total Parts Cost - Technician Number: $id",
		about => "@columns[0] - @columns[$num_of_months - 1] ",
		columns => [@columns],
		data => [@part_cost],
		height => 150,
		width => 400,
		min => 10,
		max => 50,
		#debug => $debug,
	};

	my $output = '';
   $template->process('templates/graphs/horizontal_bar.tpl', $vars,\$output)  || die $template->error();

   print $output;
   exit;
}
if($type eq "techs_by_totalcalls"){
	#difficult to test, I do not have any data for this, yet to my knowledge
	my $sth = $dbh->prepare("
	SELECT t.technician_number, SUM(ct.call_type_id) as total_calls, MONTH(s.completion_datetime) as month_index, MONTHNAME(s.completion_datetime) as month
	FROM service AS s 
	JOIN serials ON s.serial_id = serials.serial_id
	JOIN technicians AS t ON t.technician_id = s.technician_id
	JOIN call_types AS ct on s.call_type_id = ct.call_type_id
	WHERE t.technician_number = ?
	GROUP BY MONTH(s.completion_datetime)
	ORDER BY MONTH(s.completion_datetime);
	");
	$sth->execute($id);

	my @table_data;
	my @columns;
	my @num_calls;

	while(my $row = $sth->fetchrow_hashref){
		push @table_data, $row;	
		push @columns, $row->{month};
		push @num_calls, $row->{total_calls};
	}	
	$sth->finish();	

	my $debug = Dumper($type) . Dumper(@columns);

	my $num_of_months = scalar @columns;
	my $vars = {
		title => "Total Calls - Technician Number: $id",
		about => "@columns[0] - @columns[$num_of_months - 1] ",
		columns => [@columns],
		data => [@num_calls],
		height => 150,
		width => 400,
		min => 50,
		max => 200,
		#debug => $debug,
	};

	my $output = '';
   $template->process('templates/graphs/horizontal_bar.tpl', $vars,\$output)  || die $template->error();

   print $output;
   exit;
}
exit;