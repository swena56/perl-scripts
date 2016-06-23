package BEI::ETL::Fixserl;

use strict;
use warnings;

use base 'BEI::ETL';
no warnings 'uninitialized';

sub table_name {

	return "fixserl";  
}

sub bulk_load_sql {
	my $self = shift;
	my $table = $self->table_name();
	my $sql =  "LOAD DATA INFILE ? INTO TABLE " . $table . " " .  
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
		serial varchar(30),
		machine_description varchar(32),
		initial_meter_reading int(10),
		date_sold_or_rented varchar(10),
		model_number varchar(30),
		source_code varchar(1),
		meter_reading_on_last_service_call int(10),
		null_placeholder varchar(25),
		date_of_last_service_call varchar(10),
		customer_number varchar(32),
		program_type_code varchar(10),
		product_category_code varchar(6),
		sales_rep_id varchar(6),
		connectivity_code varchar(2),
		postal_code varchar(10),
		sic_number varchar(6),
		equipment_id varchar(10),
		primary_technician_id varchar(10),
		facility_management_equip varchar(15),
		is_under_contract bool,
		branch_id varchar(10),
		customer_bill_to_number varchar(32),
		customer_type varchar(15),
		territory_field varchar(15)
	);";
	
	return $sql;
}
1;