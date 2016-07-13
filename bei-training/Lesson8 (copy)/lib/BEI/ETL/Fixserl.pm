package BEI::ETL::Fixserl;


use Moose;

extends 'BEI::ETL';

has 'table_name' => (
	is => 'ro',
	default => 'fixserl'
);

no warnings 'uninitialized';

=pod 

=head1 FIXSERL -Complete machine list of all serial numbers.

	FIXSERL consists of 20 PIPE delimited fields.

=head2 Schema

	Position	Field Description	 			Format
	0			Serial Number					VARCHAR(30)
	1			Machine Description (model desc)VARCHAR(32)
	2			Initial Meter Reading			INT(10)
	3			Date Sold / Rented				BEI Date [MM/DD/YY]
	4			Model Number					VARCHAR(30)
	5			Source Code						CHAR(1)
	6			Meter Reading Last Service Call	INT(10)
	7			NULL FIELD						NULL
	8			Date of Last Service Call		BEI Date [MM/DD/YY]
	9			Customer Number					VARCHAR(32)
	10			Program Type/Contract 	Code	VARCHAR(10) *********
	11			Product Code/Item Category		VARCHAR(6)
	12			Sales Rep ID					VARCHAR(6)
	13			Connectivity Code				CHAR(2)
	14			Postal Code						VARCHAR(10)
	15			SIC Number						VARCHAR(6)
	16			Equipment ID					VARCHAR(10)
	17			Primary Technician ID Number	VARCHAR(10)
	18			Facility Management Equip		VARCHAR(15)
	19			Is Under Contract				INT(1) 0=false 1=true   TINYINT(1)
	20			Branch ID						VARCHAR(10)
	21			Customer Bill To Number			VARCHAR(32)
	22			Customer Type					VARCHAR(15)
	23			Territory Field					VARCHAR(15)
=cut 

sub scrub_line {

	my $self = shift;
	my $line = shift;
	chomp $line;

 	my @array = split /\|/, $line;
 	my $serial 							= "$array[0]";
	my $machine_description 			= "$array[1]";
	my $initial_meter_reading 			= "$array[2]";	
	my $date_sold_or_rented 			= "$array[3]";
	my $model_number					= "$array[4]";
	my $source_code 					= "$array[5]";
	my $meter_reading 					= "$array[6]";		
	my $null_placeholder 				= "$array[7]";				
	my $date_of_last_service_call 		= "$array[8]";
	my $customer_number 				= "$array[9]";
	my $program_type_code 				= "$array[10]";
	my $product_category_code 			= "$array[11]";
	my $sales_rep_id 					= "$array[12]";
	my $connectivity_code 				= "$array[13]";
	my $postal_code 					= "$array[14]";
	my $sic_number 						= "$array[15]";
	my $equipment_id 					= "$array[16]";
	my $primary_technician_id 			= "$array[17]";
	my $facility_management_equip 		= "$array[18]";
	my $is_under_contract 				= "$array[19]";
	my $branch_id 						= "$array[20]";
	my $customer_bill_to_number 		= "$array[21]";
	my $customer_type 					= "$array[22]";
	my $territory_field 				= "$array[23]";

	#$date_sold_or_rented = BEI::Utils::verify_and_convert_date($date_sold_or_rented);
	#example fixserl data
	#210210263|REXELL SHREDDER|0|06/08/05|4550S3||0|    ||34401|CH-110TC30|1220|||50265|    |SN-210210263|UA||0|  Z
	$line = "$serial|$machine_description|$initial_meter_reading" .
			   "|$date_sold_or_rented|$model_number|$source_code".
			   "|$meter_reading|$null_placeholder|$date_of_last_service_call".
			   "|$customer_number|$program_type_code|$product_category_code".
			   "|$sales_rep_id|$connectivity_code|$postal_code" .
			   "|$sic_number|$equipment_id|$primary_technician_id|$facility_management_equip".
			   "|$is_under_contract|$is_under_contract|$branch_id".
			   "|$customer_bill_to_number|$customer_type|$territory_field\n";

	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS $table (
					serial_id						VARCHAR(30),
					model_description 			VARCHAR(32),
					initial_meter_reading 			INT(10),
					date_sold_or_rented 			VARCHAR(10),
					model_number 					VARCHAR(30),
					source_code 					VARCHAR(1),
					meter_reading_on_last_service_call INT(10),
					null_placeholder 				VARCHAR(25),
					date_of_last_service_call 		VARCHAR(10),
					customer_number 				VARCHAR(32),
					program_type_code 				VARCHAR(10),
					product_category_code 			VARCHAR(6),
					sales_rep_id 					VARCHAR(6),
					connectivity_code 				VARCHAR(2),
					postal_code 					VARCHAR(10),
					sic_number 						VARCHAR(6),
					equipment_id 					VARCHAR(10),
					primary_technician_id 			VARCHAR(10),
					facility_management_equip 		VARCHAR(15),
					is_under_contract 				TINYINT(1),
					branch_id 						VARCHAR(10),
					customer_bill_to_number 		VARCHAR(32),
					customer_type 					VARCHAR(15),
					territory_field 				VARCHAR(15)
	);";
	


	return $sql;
}

1;