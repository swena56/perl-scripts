#!/usr/bin/perl
use strict;
use warnings;
#use CGI;
use CGI ':standard';
use CGI::Pretty;
use CGI::Carp qw(fatalsToBrowser);
use Template;
use CGI::Ajax;
use Data::Dumper;

use XML::Writer;
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson8/lib);
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson8/cgi-bin/serial_audit/templates);

use BEI::DB 'connect';
use JSON;

my $q = CGI->new();

my $json = $q->param('json');


my $template = Template->new(
	  INCLUDE_PATH => 	'/home/ubuntu/perl-scripts/bei-training/Lesson8/cgi-bin/serial_audit/service_calls/'
);


my $search_input = $q->param('search_input');

my $response = $q->param('response');
my $order_by = $q->param('order_by');
my $direction = $q->param('direction');
my $num_results =  $q->param('num_results');
my $columns = $q->param('columns');
my $table_data = $q->param('table_data');
my $page = $q->param('page');

sub get_direction_symbol {

	my $column = shift;

	if($column eq $order_by){
		if($direction eq "DESC"){
			return "$column &#9650";
		} else {
			return "$column &#9660";	
		}
	} 

	return "$column";
}

my $direction_symbol;

if(!$order_by){
	$order_by = 'completion_datetime';
}

if(!$direction){
	$direction = 'DESC';
}



#Data I am going to need to load my table up

my @table_data = $table_data;
my @columns;
my $debug = "data I have so far parsed. Order By: $order_by, $table_data";

if(!$json) {
	$debug .= "No json data";
}



my $vars = {
	debug => $debug,
	search => $search_input,
	order_by => $order_by,
	direction => $direction,
	num_results => $num_results,
	table_data => \@table_data,
	#get_direction_symbol => \&get_direction_symbol,
};

my $output = '';
$template->process('search/results_table.tpl', $vars,\$output)  || die $template->error();
print header();
print $output;
exit;
