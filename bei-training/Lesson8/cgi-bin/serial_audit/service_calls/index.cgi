#!/usr/bin/perl
use strict;
use CGI ':standard';
use CGI::Pretty;
use CGI::Carp qw(fatalsToBrowser);
use Template;
use CGI::Ajax;
use Data::Dumper;
use Math::Round;
use JSON;

use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson8/lib);
use BEI::DB 'connect';
my $cgi = CGI->new();  
print header;
my $template = Template->new(
	  INCLUDE_PATH => 	'/home/ubuntu/perl-scripts/bei-training/Lesson8/cgi-bin/serial_audit/service_calls/'
);

my $search_input = $cgi->param('search_input');
my $order_by = $cgi->param('order_by');
my $direction = $cgi->param('direction');
my $page = $cgi->param('page');



my $vars = {
				input => $search_input,
				page => $page,
				order_by => $order_by,
				direction => $direction,
			};

		my $output = '';
		$template->process('index.tpl', $vars,\$output)  || die $template->error();

		print $output;
exit;