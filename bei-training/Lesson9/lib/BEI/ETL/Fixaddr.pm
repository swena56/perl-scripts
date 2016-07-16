package BEI::ETL::Fixmeter;

use Moose;

extends 'BEI::ETL';

has 'table_name' => (
	is => 'ro',
	default => 'fixmeter'
);

no warnings 'uninitialized';

=pod
	=head1 	FIXADDR - Customer Number Address Information

		FIXADDR consists of five PIPE delimited fields.
	=head2 Schema

		Position	Field Description		Format
		0			Customer Number			VARCHAR(32)
		1			Address					VARCHAR(200)
		2			City					VARCHAR(200)
		3			State / Province		VARCHAR(200)
		4			Postal Code				VARCHAR(10)

		FIXADDR Customer Number field should match the Customer Number field in the FIXSERL file, which can be mapped back to a serial number – model number entity.
=cut

sub bulk_load_sql {

	my $self = shift;
	my $table = $self->table_name();

	my $sql = "LOAD DATA INFILE ? INTO TABLE $table " .  
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
 	my $customer_number	 			= "$array[0]";
	my $address			 			= "$array[1]";
	my $city			 			= "$array[2]";
	my $state_or_province 			= "$array[3]";
	my $postal_code		 			= "$array[4]";

	$line = "$customer_number|$address|$city|$state_or_province|$postal_code\n";

	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS $table(
					customer_number		VARCHAR(32),
					address				VARCHAR(200),
					city				VARCHAR(200),
					state_or_province	VARCHAR(200),
					postal_code			VARCHAR(10)
				);";
	
	return $sql;
}

1;