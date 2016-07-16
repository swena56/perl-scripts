#!/usr/bin/perl
use strict;
#use CGI;
use CGI ':standard';
use CGI::Carp qw(fatalsToBrowser);
use Template;
my $template = Template->new(
	  INCLUDE_PATH => '/home/ubuntu/perl-scripts/bei-training/Lesson9/tpls/'
);
my $template_output = '';
my $main_content = '';
use CGI::Ajax;
use Data::Dumper;
use Math::Round;
use JSON;
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson9/lib);
use BEI::DB 'connect';

my $cgi = CGI->new();  
my $page = $cgi->param('page');
my $bypass = $cgi->param('bypass');

my %apps = (

	home => {
		name => 'Home',
		call => 'home',
		addr => 'index.cgi',
		tpls => 'main_content/index.tpl' 
	},
	
	service_calls => {
		name => 'Service Calls',
		call => 'service_calls',
		addr => 'service_calls/index.cgi',
		tpls => 'service_calls/index.tpl',
		vars => {
			
		}
	},

	dashboard => {
		name => 'Analytics Dashboard',
		call => 'dashboard',
		addr =>'dashboard/index.cgi',
		tpls => 'dashboard/index.tpl'
	}
);

my $layouts = {};
my $active_page = $apps{service_calls};


#assign default template variables
my $template_vars = {
	title => "Application Name Here",
	menu_items => \%apps,
	active_page => $active_page,
	bypass_layout => '',
	main_content => '',
	debug => ''
};


print header();
if(!$bypass){
	$template->process('header/index.tpl', $template_vars,\$template_output)  || die $template->error();
	$template->process('nav_bar/index.tpl', $template_vars,\$template_output)  || die $template->error();
	$template->process('main_content/index.tpl', $template_vars,\$template_output)  || die $template->error();
	$template->process('footer/index.tpl', $template_vars,\$template_output)  || die $template->error();
}

print $template_output;


exit;

















=pod
if($page eq 'home'){
	my $vars = {
		title => "HOME",
		menu_items => \%apps,
		active_page => $active_page,
		bypass_layout => '',
		main_content => '',
		debug => ''
	};
	$active_page = $apps{home};
	$template->process('index.tpl', $vars,\$main_content)  || die $template->error();	
	
}

if($page eq 'service_calls'){
	my $service_calls_vars = {
		title => "Service Calls",
		menu_items => \%apps,
		active_page => $active_page,
		bypass_layout => '',
		main_content => '',
		debug => ''
	};
	$active_page = $apps{service_calls};
	$template->process('service_calls/index.tpl', $service_calls_vars,\$main_content)  || die $template->error();	
}

if($page eq 'dashboard'){
	my $vars = {
		title => "dashboard",
		menu_items => \%apps,
		active_page => $active_page,
		bypass_layout => '',
		main_content => '',
		debug => ''
	};
	$active_page = $apps{dashboard};
	$template->process('dashboard/index.tpl', $vars,\$main_content)  || die $template->error();	
}
=cut
