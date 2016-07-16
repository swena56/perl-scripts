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
	  INCLUDE_PATH => 	'$FindBin::Bin/'
	  			
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

chomp $export_csv;

if($export_csv eq "all"){
	$starting_page = 0;
	$max_per_page = 0;
} elsif($export_csv eq "page") {
	$starting_page = 0;
	my $max_per_page = 100;
}

my $dbh = &connect();
my $args = { 
	search_input => $search_input,
	direction =>	$direction,
	selected_column => $selected_column,
	max_per_page => 100,
	start_row => $starting_page,
	export_csv => $export_csv,
};


if( $start_date != "" ){
	$args->{start_date} .= $start_date;
}

if( $end_date != "" ){
	$args->{end_date} .= $end_date;
}

my $service_data = &get_service_data($dbh,$args);
my $cols = &build_service_data_cols();

my $pager = $service_data->{pager};
my $test_sql = $service_data->{sql};
my $debug =  "$test_sql , export:" . Dumper($export_csv) . Dumper($service_data->{pager});#{}"Debug: " . Dumper($service_data);
#my $debug =  "none";

my $download;
if($export_csv){

	#append date
	my $file = "text.csv";
	my $filepath= "/var/www/html/upload/$file";

	open(my $fh, '>', $filepath) or die "Could not open file ";

	print $fh "serial_number|model_number|call_type|call_datetime|dispatched_datetime|arrival_datetime|completion_datetime|technician_number|call_id_not_call_type|total_parts_cost|service_id \n";

	foreach my $csv_line (@{$service_data->{data}}){
		print $fh   $csv_line->{serial_number} ."|". $csv_line->{model_number}."|". $csv_line->{call_type}."|". $csv_line->{call_datetime}."|". $csv_line->{dispatched_datetime}."|". $csv_line->{arrival_datetime}."|". $csv_line->{completion_datetime}."|". $csv_line->{technician_number}."|". $csv_line->{call_id_not_call_type}."|". $csv_line->{total_parts_cost}."|". $csv_line->{service_id} . "\n";
	}
	close $fh;

	my $header = $q->header(-type=>'text/csv',-charset=>'UTF-8',-'Content-Disposition'=>'attachment; filename="http://localhost/upload/$file"');
	#my $header = header("header('Content-Type: application/force-download');");
	my $iframe =  "<iframe width='1' height='1' style='display:none;' frameborder='0' src='http://localhost/upload/$file'></iframe>";
	my $meta =  '<meta http-equiv="Refresh" content="0;url=\'http://localhost/upload/$file\'">';
	$download = $header . $iframe . $meta . " export:" . $export_csv;
	
	print $download;
	exit;
}
#unlink ($filepath);

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
	export_csv				=> $download,
});

print $q->header(-type => "application/json", -charset => "utf-8");
print $json;

exit;