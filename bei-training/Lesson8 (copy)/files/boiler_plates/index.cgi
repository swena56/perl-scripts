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

#initalization
my $cgi = CGI->new();  
my $pjx = new CGI::Ajax();
my $PROJECT_DIR = "/home/ubuntu/perl-scripts/bei-training/Lesson8/cgi-bin/serial_audit";
my $template = Template->new(
	  INCLUDE_PATH =>  $PROJECT_DIR . "/sub_app_name/templates"
);

#main entry point
sub Show_HTML {

  	my $vars = {
		
	};

    my $output = '';
    $template->process('index.tpl', $vars,\$output)  || die $template->error();
    
	return $output;
 }

print $cgi->header();
print $pjx->build_html( $cgi, \&Show_HTML);	
exit;