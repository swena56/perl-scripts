package BEI::ETL::Fixserv;

use strict;
use warnings;

use base 'BEI::ETL';
no warnings 'uninitialized';

=pod
	=head1 FIXSERV - Service call detail file

		FIXSERV consists of 27 PIPE delimited fields.

	=head2 Schema

		Position	Field Description	 		Format
		0			NULL FIELD					NULL
		1		Call ID Number				VARCHAR(15)
		2		Model Number				VARCHAR(30)
		3		Serial Number				VARCHAR(30)
		4		Call Date					BEI Date [MM/DD/YY]
		5		Call Time					BEI Time [HHMM]
		6		Customer Time*				VARCHAR(4) *[HHMM]
		7		Arrival Time				BEI Time [HHMM]
		8		Call Completion Time		BEI Time [HHMM]
		9		Call Type (EM/PM/SH/HP)		VARCHAR(10)
		10		Problem Code				VARCHAR(4)
		11		Location Code				VARCHAR(4)
		12		Reason Code					VARCHAR(4)
		13		Correction Code				VARCHAR(4)
		14		Date Dispatched				BEI Date [MM/DD/YY]
		15		Time Dispatched				BEI Time [HHMM]
		16		Completion Date				BEI Date [MM/DD/YY]
		17		Meter Reading (total meter)	INT(10)
		18		Meter Reading of PRIOR Call	INT(10)
		19		Date of PRIOR Service Call	BEI Date [MM/DD/YY]
		20		PC-Type (leave NULL)		VARCHAR(4) || NULL
		21		LC-Type (leave NULL)		VARCHAR(4) || NULL
		22		NULL FIELD					NULL
		23		Machine Status				VARCHAR(1)
		24		Technician ID Number		VARCHAR(10)
		25		Customer Number				VARCHAR(32)
		26		Miles Driven				INT(10)	
		27		Response Time				VARCHAR(4) [HHMM]

		* Customer Time:
			This field is slightly different than the other BEI Time fields in that it’s a ‘total’ time field that is displayed in total hours along with total minutes.  90 minutes is displayed (zero filled) as 0130.  2 hours is displayed as 0200.
=cut

sub table_name {

	return "fixparla";  
}

sub scrub_line {

	my $self = shift;
	my $line = shift;
	chomp $line;

 	my @array = split /\|/, $line;
 	my $null_field1					= "$array[0]";
	my $call_id 					= "$array[1]";
	my $model_number 				= "$array[2]";
	my $serial_number 				= "$array[3]";
	my $call_date 					= "$array[4]";
	my $call_time 					= "$array[5]";
	my $customer_time 				= "$array[6]";
	my $arrival_time 				= "$array[7]";
	my $call_completion_time 		= "$array[8]";
	my $call_type 					= "$array[9]";
	my $problem_code 				= "$array[10]";
	my $location_code 				= "$array[12]";
	my $reason_code 				= "$array[13]";
	my $correction_code 			= "$array[14]";
	my $date_dispatched 			= "$array[15]";
	my $time_dispatched 			= "$array[16]";
	my $completion_date 			= "$array[17]";
	my $meter_reading_total 		= "$array[18]";
	my $meter_reading_prior_call 	= "$array[19]";
	my $date_of_prior_call 			= "$array[20]";
	my $pc_type 					= "$array[21]";
	my $lc_type 					= "$array[22]";
	my $null_field2 				= "$array[23]";
	my $machine_status 				= "$array[24]";
	my $technician_id_number 		= "$array[25]";
	my $customer_number 			= "$array[26]";
	my $miles_driven 				= "$array[27]";
	my $response_time 				= "$array[28]";

	$line = "$null_field1|$call_id|$model_number|$serial_number|$call_date|$call_time|$customer_time".
			"|$arrival_time|$call_completion_time|$call_type|$problem_code|$location_code|$reason_code".
			"|$correction_code|$date_dispatched|$time_dispatched|$completion_date|$meter_reading_total".
			"|$meter_reading_prior_call|$date_of_prior_call|$pc_type|$lc_type|$null_field2|$machine_status".
			"|$technician_id_number|$customer_number|$miles_driven|$response_time\n";
	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS $table (
					null_field1					VARCHAR(10),
					call_id						VARCHAR(15),
					model_number				VARCHAR(30),
					serial_number				VARCHAR(30),
					call_date					VARCHAR(10),
					call_time 					VARCHAR(4),
					customer_time 				VARCHAR(4),
					arrival_time				VARCHAR(4),
					call_completion_time		VARCHAR(10),
					call_type 					VARCHAR(10),
					problem_code				VARCHAR(4),
					location_code				VARCHAR(4),
					reason_code 				VARCHAR(4),
					correction_code 			VARCHAR(4),
					date_dispatched 			VARCHAR(10),
					time_dispatched 			VARCHAR(4),
					completion_date 			VARCHAR(10),
					meter_reading_total 		INT(10),
					meter_reading_prior_call	INT(10),
					date_of_prior_call			VARCHAR(10),
					pc_type 					VARCHAR(4),
					lc_type 					VARCHAR(4),
					null_field2 				VARCHAR(10),
					machine_status 				VARCHAR(1),
					technician_id_number 		VARCHAR(10),
					customer_number 			VARCHAR(32),
					miles_driven				INT(10),
					response_time 				VARCHAR(4)
				);";
	return $sql;
}

1;