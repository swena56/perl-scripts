#!/usr/bin/perl
use strict;
use CGI ':standard';
use CGI::Pretty;
use Data::Dumper;
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson7/lib);
use BEI::DB 'connect';
use JSON;

my $q = CGI->new();
my $trend_type = $q->param('trend_type');
my $input = $q->param('input');

print  header('application/json');

if($trend_type eq "models"){
	if($input){
		# need a group by method
		my $month_index = shift || 0;
		my $dbh = &connect();

		my $sth = $dbh->prepare("
		SELECT src.call_type, src.model_number, src.total_calls, src.month
		FROM (
		SELECT c.call_type, m.model_number, COUNT(c.call_type) AS total_calls, MONTH(completion_datetime) AS month
		FROM service AS s 
		JOIN serials ON s.serial_id = serials.serial_id
		JOIN call_types AS c ON s.call_type_id = c.call_type_id
		JOIN models AS m ON m.model_id = serials.model_id
		GROUP BY c.call_type
		) AS src
		ORDER BY src.total_calls DESC LIMIT 10;
		");
		$sth->execute();

		my @columns = ('Model Number', 'Amount', 'Date');
		my @table_data;

		my $num_rows =  $sth->rows;
		if($num_rows > 0){   

			while(my $row = $sth->fetchrow_hashref){
				push @table_data, $row;		
			}	
		}
		$sth->finish();	
		my $debug_dump = Dumper(@table_data);
		my $op = JSON -> new -> utf8 -> pretty(1);
		my $response = $op -> encode({
			title => "Model Trend data for $input",
			num_rows => $num_rows,
			columns => \@columns,
			result_data => \@table_data,
			querying_from => $trend_type,
			debug => $debug_dump,
			input => $input,
		});
				
		print $response;
		exit;
	}
}
exit;
