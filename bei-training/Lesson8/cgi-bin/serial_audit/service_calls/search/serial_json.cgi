#!/usr/bin/perl
use strict;
use warnings;
use CGI ':standard';
use CGI::Carp qw(fatalsToBrowser);
use Template;
use CGI::Ajax;
use Data::Dumper;
use POSIX;
use XML::Writer;
use Text::CSV::Hashify;
use File::Copy qw( copy );
use File::Spec::Functions qw( catfile );
use JSON;
use FindBin;
use lib "$FindBin::Bin/../../../../lib";

my $template = Template->new(
	  INCLUDE_PATH => 	'$FindBin::Bin/../service_calls/'
);

use BEI::DB 'connect';
use BEI::DB::Service qw(
	get_service_data 
	build_service_data_cols
	buildPagerFromData
);  #expose to module test this

my $q = CGI->new();

my $search_input = $q->param('search_input');
my $direction = $q->param('direction');
my $selected_column = $q->param('selected_column');
my $starting_page = $q->param('starting_page')	|| 	0;
my $start_date = $q->param('start_date');
my $end_date = $q->param('end_date');

my $export_csv = $q->param('export_csv');
my $max_per_page = 100;

if($export_csv eq 'all'){
	$starting_page = 0;
	$max_per_page = 0;
}

my $dbh = &connect();
my $args = { 
	search_input => $search_input,
	direction =>	$direction,
	selected_column => $selected_column,
	max_per_page => 100,
	start_row => $starting_page,
};


if( $start_date != "" ){
	$args->{start_date} .= $start_date;
}

if( $end_date != "" ){
	$args->{end_date} .= $end_date;
}

my $service_data = &get_service_data($dbh,$args);

my $cols = &build_service_data_cols();

#if( exists $cols->{ $selected_column } ){
#	if($direction eq "ASC"){
#		$cols->{ $selected_column } .=  " &#9650";	
#	} elsif($direction eq "DESC"){
#		$cols->{ $selected_column } .=   " &#9660";	
#	}
#}

my $pager = $service_data->{pager};
my $test_sql = $service_data->{sql};
my $debug =  "$test_sql " . Dumper($service_data->{pager});#{}"Debug: " . Dumper($service_data);

if($export_csv){

	#append date
	my $file = "text.txt";
	my $filepath= "/var/www/html/upload/$file";
	
	open(my $fh, '>', $filepath) or die "Could not open file ";


	foreach my $key (keys(%{$cols})) {
		print $fh   $cols->{$key} . "," ;
	}

	foreach my $csv_line (@{$service_data->{data}}){
		print $fh   $csv_line->{serial_number} .",". $csv_line->{model_number}.",". $csv_line->{call_type}.",". $csv_line->{call_datetime}.",". $csv_line->{dispatched_datetime}.",". $csv_line->{arrival_datetime}.",". $csv_line->{completion_datetime}.",". $csv_line->{technician_number}.",". $csv_line->{call_id_not_call_type}.",". $csv_line->{total_parts_cost}.",". $csv_line->{service_id} . "\n";
	}
	close $fh;

	#print header;
	#header("Content-type:application/pdf");

	#header("Content-Disposition:attachment;filename='downloaded.pdf'");	
	#print "<iframe width='1' height='1' style='display:none;' frameborder='0' src='http://localhost/upload/$file'></iframe>";
	#print '<meta http-equiv="Refresh" content="0;url=\'http://localhost/upload/$file\'">';

		print "Content-Type:application/x-download\n\n";   
		print "Content-Disposition:attachment;filename='http://localhost/upload/$file'";  
	#unlink ($filepath);
exit;

} else {

	my $pager = $service_data->{pager};
	my $op = JSON -> new -> utf8 -> pretty(1);
	my $json = $op -> encode({
		search 					=> $search_input,
		num_rows 				=> $pager->{num_rows},
		total_num_rows_on_page  => $pager->{total_num_rows_on_page},
		starting_page 			=> $pager->{starting_row},
		columns 				=> $cols,
		result_data 			=> $service_data->{data},
		total_pages 			=> $pager->{total_pages},
		current_page 			=> $pager->{current_page},
		current_row 			=> $pager->{current_row},
		debug 					=> $debug,
	});

	print $q->header(-type => "application/json", -charset => "utf-8");
	print $json;
}
exit;