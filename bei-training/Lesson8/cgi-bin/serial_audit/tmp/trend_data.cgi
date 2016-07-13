#!/usr/bin/perl
#NOT BEING USED, I am directly using the graphing engine
use strict;
use CGI ':standard';
use CGI::Pretty;
use Data::Dumper;
use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson7/lib);
use BEI::DB 'connect';
use JSON;
use Encode;
use JSON::XS;
my $q = CGI->new();
my $trend_type = $q->param('trend_type');
my $input = $q->param('input');

print  header('application/json');

		# need a group by method
		my $month_index = shift || 0;

		my $dbh = &connect();


		#MP7502SP  needs to be between the last three months
my $sth = $dbh->prepare("


SELECT m.model_number, s.completion_datetime
FROM service AS s 
JOIN serials ON s.serial_id = serials.serial_id
JOIN models AS m ON m.model_id = serials.model_id
WHERE m.model_number = ?;


");
		$sth->execute($input);

		my @table_data;

		my $num_rows =  $sth->rows;
		if($num_rows > 0){   

			while(my $row = $sth->fetchrow_hashref){
				push @table_data, $row;	
			}	
		}
		$sth->finish();	
		my $response = encode_json(\@table_data);

		print $response;
		exit;
