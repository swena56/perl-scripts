package BEI::ETL::Fixlabor;

use strict;
use warnings;

use base 'BEI::ETL';
no warnings 'uninitialized';

=pod
	=head1 FIXLABOR

		FIXLABOR consists of 12 PIPE delimited fields of tech time for the associated service calls
	
	=head2 Schema
	
		Position	Field Description			Format
		0			Call ID Number				VARCHAR(15)
		1			Model						VARCHAR(30)
		2			Serial						VARCHAR(30)
		3			Activity Code				VARCHAR(15)
		4			Assist						INT(1) 0=false 1=true
		 5			Date						BEI Date [MM/DD/YY]
		6			Tech Number 				VARCHAR(10)
		7			Dispatch Time, HHMM			BEI Time [HHMM]
		8			Arrival Time, HHMM			BEI Time [HHMM]
		9			Departure Time, HHMM		BEI Time [HHMM]
		10			Interrupt Hours				VARCHAR(4) *[HHMM] 
		11			Mileage						INT(10)

		*CUST TIME*: This field is slightly different than the other BEI Time fields in that it’s a ‘total’ time field that is displayed in total hours along with total minutes.  90 minutes is displayed (zero filled) as 0130.  2 hours is displayed as 0200.
=cut

sub table_name {

	return "fixlabor";  
}

sub scrub_line {

	my $self = shift;
	my $line = shift;
	chomp $line;

 	my @array = split /\|/, $line;
 	my $call_id 			= "$array[0]";
	my $model 				= "$array[1]";
	my $serial 				= "$array[2]";
	my $activity_code		= "$array[3]";
	my $assist 				= "$array[4]";
	my $date 				= "$array[5]";
	my $tech_number 		= "$array[6]";
	my $dispatch_time 		= "$array[7]";
	my $arrival_time 		= "$array[8]";
	my $departure_time 		= "$array[9]";
	my $interrupt_hours 	= "$array[10]";
	my $mileage 			= "$array[11]";

	$line = "$call_id|$model|$serial|$activity_code|$assist|$date|$tech_number|$dispatch_time|$arrival_time|$departure_time|$interrupt_hours|$mileage\n";

	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS $table (
					call_id				VARCHAR(15),
					model 				VARCHAR(30),
					serial 				VARCHAR(30),
					activity_code	 	VARCHAR(15),
					assist 				TINYINT(1), 
		 		 	date 				VARCHAR(10),
					tech_number 		VARCHAR(10),
					dispatch_time 		VARCHAR(4),
					arrival_time		VARCHAR(4),
					departure_time 		VARCHAR(4),
					interrupt_hours 	VARCHAR(4),
					mileage				INT(10)
				  );";
	return $sql;
}
1;