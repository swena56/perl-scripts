package BEI::ETL::Fixmeter;

use strict;
use warnings;

use base 'BEI::ETL';
no warnings 'uninitialized';

=pod
	=head1 		FIXMETER - Multiple meter service call information

		FIXMETER consists of six PIPE delimited fields.

	=head2 Schema

		Position	Field Description		Format
		0			Call ID					VARCHAR(15)
		1			Model					VARCHAR(30)
		2			Serial Number			VARCHAR(30)
		3			Completion Date			BEI Date [MM/DD/YY]
		4			Meter Code				VARCHAR (20)
		5			Meter Reading			INT(10)
=cut

sub table_name {

	return "fixmeter";  
}

sub scrub_line {

	my $self = shift;
	my $line = shift;
	chomp $line;

 	my @array = split /\|/, $line;
 	my $call_id 			= "$array[0]";
	my $model 				= "$array[1]";
	my $serial_number 		= "$array[2]";
	my $completion_date 	= "$array[3]";
	my $meter_code 			= "$array[4]";
	my $meter_reading 		= "$array[4]";

	$line = "\n";

	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS $table (
					call_id 			VARCHAR(15),
					model				VARCHAR(30),
					serial_number	 	VARCHAR(30),
					completion_date		VARCHAR(10),
					meter_code 			VARCHAR(20),
					meter_reading 		INT(10)
			     );";
	return $sql;
}

1;