#!/usr/bin/perl
use strict;
use CGI ':standard';
use CGI::Carp qw(fatalsToBrowser);
use Template;
use Data::Dumper;
use JSON;

use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson7/lib);
use BEI::DB 'connect';

my $template = Template->new(
	  INCLUDE_PATH => '/home/ubuntu/perl-scripts/bei-training/Lesson7/cgi-bin/serial_audit/templates/'
);

my $cgi = CGI->new();  
my $graph_data = $cgi->param('graph_data');

#print $cgi->header();
print "Content-type: text/html\n\n";

#parse the json data and plug the data in to the template variables
my $debug = Dumper($graph_data);

my $vars = {
	  	title => "D3 Graph",
	  	columns => $graph_data->{call_type},
	  	rows =>	$graph_data->{rows},
	  	json_data => $graph_data,
	  	debug => $debug,
	  	min => 10,
	};

	my $output = '';
   $template->process('section/graphs/horizontal.tpl', $vars,\$output)  || die $template->error();

   print $output;
exit;