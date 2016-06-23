package BEI::ETL::Fixparla;

use strict;
use warnings;

use base 'BEI::ETL';
no warnings 'uninitialized';

=pod
		=head1 FIXPARLA

			Parts associated with service call detail file

			FIXPARLA consists of 11 PIPE delimited fields.

		=head1 Schema

			Position	Field Description 	 		Format
			0		Part Number				VARCHAR(18)
			1		Part Description				VARCHAR(32)
			2		Add / Sub indicator (+ or -)		CHAR(1)
			3		Quantity Used				INT(4)
			4		Call ID 	Number				VARCHAR(15)
			5		Model Number (problem unit)		VARCHAR(30)
			6		Serial Number (problem unit)		VARCHAR(30)
			7		Installation Date of Part			BEI Date [MM/DD/YY]
			8		Meter Reading at installation of Part	INT(10)
			9		Parts Cost (Dealer Cost Extended)	VARCHAR(12)**
			10		Customer Number			VARCHAR(32)

			**Item Cost:
			Can be in either float 2-point format w/ decimal point (99999.99) 
			OR 
			float 5-point format WITHOUT the decimal point 123456754321 
			[BEI will place a decimal point between the 7 and 5].  So 000000450024 will correspond to 4.50.

=cut

sub table_name {

	return "fixparla";  
}

sub bulk_load_sql {

	my $self = shift;
	my $table = $self->table_name();

	my $sql = "LOAD DATA INFILE ? INTO TABLE " . $table . " " .  
						"FIELDS TERMINATED BY '|' " .
						"ENCLOSED BY '' " .
						"LINES TERMINATED BY '\\n'";

	return $sql;
}

sub scrub_line {

	my $self = shift;
	my $line = shift;
	chomp $line;

 	my @array = split /\|/, $line;
 	my $serial 						= "$array[0]";
	my $part_number 				= "$array[1]";
	my $part_description 			= "$array[2]";
	my $add_sub_indicator 			= "$array[3]";
	my $quantity_used 				= "$array[4]";
	my $call_id 					= "$array[5]";
	my $model_number 				= "$array[6]";
	my $serial_number 				= "$array[7]";
	my $installation_date 			= "$array[8]";
	my $init_meter_reading 			= "$array[9]";
	my $parts_cost 					= "$array[10]";
	my $customer_number 			= "$array[11]";

	$line = "$serial|$part_number|part_description|$add_sub_indicator|$quantity_used|$model_number".
			"|$serial_number|$installation_date|$init_meter_reading|$parts_cost|customer_number\n";

	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS $table (
					part_number varchar(18),
					part_description varchar(32),
					add_sub_indicator char(1),
					quantity_used int(4),
					call_id varchar(15),
					model_number varchar(30),
					serial_number varchar(30),
					installation_date varchar(10),
					init_meter_reading varchar(10),
					parts_cost varchar(12),
					customer_number varchar(32)        );";
	
	
	return $sql;
}
1;