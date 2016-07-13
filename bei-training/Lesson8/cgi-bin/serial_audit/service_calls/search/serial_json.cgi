#!/usr/bin/perl
use strict;
#use CGI;
use CGI ':standard';
use CGI::Pretty;
use CGI::Carp qw(fatalsToBrowser);
use Template;
use CGI::Ajax;
use Data::Dumper;
 use POSIX;
use XML::Writer;
use Text::CSV::Hashify;
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson8/lib);
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson8/cgi-bin/serial_audit/templates);

use BEI::DB 'connect';
use JSON;

my $q = CGI->new();


my $search_input = $q->param('search_input');

my $response = $q->param('response');

my $direction = $q->param('direction');
my $page = $q->param('page');
my $selected_column = $q->param('selected_column');
my $starting_row = $q->param('starting_row');
my $starting_page = $q->param('starting_page');
my $export_csv = $q->param('export_csv');

#make sure we have a starting row
#make sure we have a starting row
my $max_per_page = 100;

#set direction if none is provided, reject anything else
if(!$direction){
	$direction = 'DESC';
}

if(!$selected_column){
	$selected_column = "serial_number";
}




my $dbh = &connect();

my $currency_type = "\\\$";

#get total number of pages
my $sth = $dbh->prepare("
SELECT count(*) AS count
FROM service AS s 
JOIN serials ON s.serial_id = serials.serial_id
WHERE serial_number LIKE " . $dbh->quote('%'.$search_input.'%') );
$sth->execute();
my $row = $sth->fetchrow_hashref;
my $num_rows = $row->{count};
my $total_pages =  0;


while($max_per_page * $total_pages < $num_rows){
	$total_pages += 1;
}

$starting_row = 1 if(!$starting_row || $starting_row < 0);
$starting_row = $total_pages if( $starting_row > $total_pages);

#my ($total_records) = $db->selectrow_array("SELECT COUNT(*) FROM ( $sql ) AS sql_src",undef,@binds);

if($export_csv eq 'all'){
	$starting_row = 0;
	$max_per_page = $num_rows;
}

#query the selected pages
$sth = $dbh->prepare("
SELECT serial_number, model_number, call_type, call_datetime, dispatched_datetime, arrival_datetime, completion_datetime, technician_number,
s.call_id_not_call_type, SUM(cost) AS total_parts_cost, s.service_id
FROM service AS s 
JOIN serials ON s.serial_id = serials.serial_id
JOIN models AS m ON serials.model_id = m.model_id
JOIN technicians AS t ON s.technician_id = t.technician_id
JOIN call_types AS c ON s.call_type_id = c.call_type_id
LEFT JOIN service_parts AS sp ON s.service_id = sp.service_id
WHERE serial_number LIKE " . $dbh->quote('%'.$search_input.'%') ." 
GROUP BY s.service_id 
ORDER BY ".$dbh->quote($selected_column). " limit $starting_row, $max_per_page " );

$sth->execute();
my $total_num_rows_on_page = $sth->rows;

my $current_row = $starting_row + $total_num_rows_on_page;

my @table_data;

my %column_hash = (
		'serial_number' => 'Serial Number',
		'model_number' => 'Model Number',
		'call_type' => 'Call Type',
		'call_datetime' => 'Call Date/Time',
		'dispatched_datetime' => 'Dispatched Date/Time',
		'arrival_datetime' => 'Arrival Date/Time', 
		'completion_datetime' => 'Completion Date/Time', 
		'technician_number' => 'Tech #',
		'call_id_not_call_type' => 'Call ID', 
		'total_parts_cost' => 'Total Parts Cost', 
		'service_id' => 'Service Id',
	);


#append Symbol to column that is data is being ordered by.
foreach my $key (keys(%column_hash)) {
    if(!$export_csv && $key eq $selected_column){
    	if($direction eq "ASC"){
    		$column_hash{$key} = $column_hash{$key} . " &#9650";	
    	} elsif($direction eq "DESC"){
    		$column_hash{$key} = $column_hash{$key} . " &#9660";	
    	}
    }
}

while ($row = $sth->fetchrow_hashref) {	
	#clean up my data before sending it to the front end

    push @table_data, $row;
}

my @table_data_sorted;

@table_data_sorted = sort { $a->{$selected_column} <=> $b->{$selected_column} } @table_data if($direction eq "ASC");
@table_data_sorted = sort { $b->{$selected_column} <=> $a->{$selected_column} } @table_data if($direction eq "DESC");


my $debug = "Debug order by this key: $direction, ";



if($export_csv){

	print $q->header();
		
	foreach my $key (keys(%column_hash)) {
		print $column_hash{$key} . "," ;
	}

	foreach my $csv_line (@table_data_sorted){
		 
	print $csv_line->{serial_number} .",". $csv_line->{model_number}.",". $csv_line->{call_type}.",". $csv_line->{call_datetime}.",". $csv_line->{dispatched_datetime}.",". $csv_line->{arrival_datetime}.",". $csv_line->{completion_datetime}.",". $csv_line->{technician_number}.",".
	$csv_line->{call_id_not_call_type}.",". $csv_line->{total_parts_cost}.",". $csv_line->{service_id} . "\n";
	}

	



} else {

	#close database connection
	$sth->finish();
	#
	my $op = JSON -> new -> utf8 -> pretty(1);
	my $json = $op -> encode({
		search => $search_input,
		num_rows => $num_rows,
		total_num_rows_on_page => $total_num_rows_on_page,
		starting_page => $starting_page,
		columns => \%column_hash,
		selected_column => $selected_column,
		result_data => \@table_data_sorted,
		total_pages => $total_pages,
		starting_row => $ starting_row,
		current_page => $page,
		current_row => $current_row,
		debug => $debug,
	});
	print $q->header(-type => "application/json", -charset => "utf-8");
	print $json;

}


exit;