package BEI::ETL::Fixbilling;

use strict;
use warnings;

use base 'BEI::ETL';
no warnings 'uninitialized';

=pod
	=head1 FIXBILLING - Meter Billing Information

		FIXBILLING consists of five PIPE delimited fields.  One line per model, serial, metercode

	=head2 Schema

		Position	Field Description		Format
		0			Model					VARCHAR(30)
		1			Serial Number			VARCHAR(30)
		2			Billing Date			BEI Date [MM/DD/YY]
		3			Meter Code				VARCHAR (20)
		4			Meter Reading			INT(10)	
=cut

sub table_name {

	return "fixbilling";  
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
 	my $model 						= "$array[0]";
	my $serial_number 				= "$array[1]";
	my $billing_date	 			= "$array[2]";
	my $meter_code		 			= "$array[3]";
	my $meter_reading 				= "$array[4]";
	
	$line = "$model|$serial_number|$billing_date|$meter_code|$meter_reading\n";

	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS $table (
					 model 				varchar(30),
					 serial_numl 		varchar(30),
					 billing_dl 		varchar(10),
					 meter_code 		varchar(20),
					 meter_readling 	INT(10)
				);";
	
	return $sql;
}
1;