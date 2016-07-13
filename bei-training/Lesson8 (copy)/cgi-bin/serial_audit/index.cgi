#!/usr/bin/perl
use warnings;
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
print header;


my $template = Template->new(
	  INCLUDE_PATH => '/home/ubuntu/perl-scripts/bei-training/Lesson8/cgi-bin/serial_audit/'
);


sub get_table_data {

	my $sql = shift 				|| die("[!] sql required parameter 1");
	my $input = shift    			|| die("[!] Get table data needs parameter 2");
	my $dbh = &connect() 			|| die("[!] Failed to connect");
	my $sth = $dbh->prepare($sql)	|| die("[!] Failed to prepare sql: $sql");
	$sth->execute($input);				
	my @table_data;
	while (my $row = $sth->fetchrow_hashref) {
		push @table_data, $row;		
	}		  
	$sth->finish();	#close database connection
	return \@table_data;
}

sub get_meters_data {

	my $input = shift;

	my @results = get_table_data("
		SELECT s.serial_number, mc.meter_code, mc.meter_description, sm.meter, m.model_number
		FROM service AS ser
		JOIN serials AS s ON ser.serial_id = s.serial_id
		JOIN models AS m ON s.model_id = m.model_id
		JOIN service_meters AS sm ON ser.service_id = sm.service_id
		JOIN meter_codes AS mc ON sm.meter_code_id = mc.meter_code_id
		WHERE ser.service_id = ?",
		$input);

	my $vars = {
		title => "Meter Codes",
	  	user_input => $input,	  	
	  	table_data => \@results,  	
	};

	my $output = '';
	$template->process('/home/templates/pop_models/meter_model.tpl', $vars,\$output)  || die $template->error();

	return \@results;
}



#main entry point
sub Show_HTML {

  	my $vars = {
		title => 'Home',
		get_meters_data => \&get_meters_data,
		table_data => 
		#home_navbar => []
	};

    my $output = '';
    $template->process('/home/templates/home.tpl', $vars,\$output)  || die $template->error();
    
	return $output;
 }

print Show_HTML();

exit;