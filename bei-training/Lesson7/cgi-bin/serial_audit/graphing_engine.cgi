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
my $table = $cgi->param('table');
my $id = $cgi->param('id');

print "Content-type: text/html\n\n";
		my $dbh = &connect();

#MP7502SP  needs to be between the last three months
my $sth = $dbh->prepare("
SELECT m.model_number, s.completion_datetime
FROM service AS s 
JOIN serials ON s.serial_id = serials.serial_id
JOIN models AS m ON m.model_id = serials.model_id
WHERE m.model_number = ?;
");
		$sth->execute($table);

		my @table_data;

		my $num_rows =  $sth->rows;
		if($num_rows > 0){   

			while(my $row = $sth->fetchrow_hashref){
				push @table_data, $row;	
			}	
		}
		$sth->finish();	

my $vars = {
	  	title => "Trending data for: $table",
	  	columns => ['model_number'],
	  	data => [34,3,2,5,6,8,4,3,2],
	  	height => 480,
	};

	my $output = '';
   $template->process('section/graphs/horizontal_bar.tpl', $vars,\$output)  || die $template->error();

   print $output;
exit;