package BEI::ETL::Fixserl;

use constant TABLE_NAME => 'fixserl';
use constant DB_NAME => 'fixserl';

use Exporter 'import';
@EXPORT_OK = qw(		
					scrub_csv
					import_csv
					create_table 
					drop_table
				); 

#optional dev imports
use strict;
use warnings;
no warnings 'uninitialized';

#imports
use Parse::CSV;
use Data::Dumper;


=pod
	=head1
=cut
sub scrub_csv{
	
	my $input_csv = shift || die("[!] " . DB_NAME . " Missing input_file.csv as parameter 1.\n");
	my $dbh 	  = shift || die("[!] " . DB_NAME . " Missing database handler as parameter 2\n");

	if ($dbh) {	

		my $parser    = Parse::CSV->new(
								file       => "$input_csv",
								sep_char   => '|',						
							);
		
		my $output_file = "$input_csv.scrubbed";

		open FH, ">", $output_file;
				
		while ( my $value = $parser->fetch ) {	
		 	my $serial 							= "@$value[0]";
			my $machine_description 			= "@$value[1]";
			my $initial_meter_reading 			= "@$value[2]";	
			my $date_sold_or_rented 			= "@$value[3]";
			my $model_number					= "@$value[4]";
			my $source_code 					= "@$value[5]";
			my $meter_reading 					= "@$value[6]";		
			my $null_placeholder 				= "@$value[7]";				
			my $date_of_last_service_call 		= "@$value[8]";
			my $customer_number 				= "@$value[9]";
			my $program_type_code 				= "@$value[10]";
			my $product_category_code 			= "@$value[11]";
			my $sales_rep_id 					= "@$value[12]";
			my $connectivity_code 				= "@$value[13]";
			my $postal_code 					= "@$value[14]";
			my $sic_number 						= "@$value[15]";
			my $equipment_id 					= "@$value[16]";
			my $primary_technician_id 			= "@$value[17]";
			my $facility_management_equip 		= "@$value[18]";
			my $is_under_contract 				= "@$value[19]";
			my $branch_id 						= "@$value[20]";
			my $customer_bill_to_number 		= "@$value[21]";
			my $customer_type 					= "@$value[22]";
			my $territory_field 				= "@$value[23]";

			my $line = "$serial|$machine_description|$initial_meter_reading" .
					   "|$date_sold_or_rented|$model_number|$source_code".
					   "|$meter_reading|$null_placeholder|$date_of_last_service_call".
					   "|$customer_number|$program_type_code|$product_category_code".
					   "|$sales_rep_id|$connectivity_code|$postal_code" .
					   "|$sic_number|$equipment_id|$primary_technician_id|$facility_management_equip".
					   "|$is_under_contract|$is_under_contract|$branch_id".
					   "|$customer_bill_to_number|$customer_type|$territory_field\n";

			my $valid_data = 1;

			#print scrubbed data to file if it is valid
			if($valid_data){
				print FH "$line";
			}else{
				print "[!] Not valid data \n";
			}
		}
		close FH;	#close scrubbed output csv file

		#system("gedit $input_csv.scrubbed");  #open scrubbed file in gedit -> useful for debugging

		print "[+] (" . DB_NAME . ") Successfully scrubbed $input_csv => $input_csv.scrubbed\n";

		return  "$input_csv.scrubbed";
	}

	print  "[!] (" . DB_NAME . ") Failed to parse and scrub csv file \n";
	return '';
}

=pod
	=head1 Import Fixserl
	
	Parameters -> Database handle
			   -> Fixserl CSV file

	Makes a connection to the database, 
	
	Imports a scrubbed copy of the csv file into the fixserl table
=cut
sub import_csv {
	my ($dbh, $file) = @_;

	#error checking
	die("[!] Fixserl File does not exist: $file\n") if(!(-e $file));
	die("[!] Database handler does not exist\n") if(!$dbh);

	#remove all table and create new
	drop_table($dbh);
	create_table($dbh);
	
	print "[+] Attempting to scrub csv $file\n";
	#parse and scrub data
	my $scrubbed_csv = scrub_csv($file, $dbh);  

	print "[+] Scrubbed File being imported: $scrubbed_csv\n";

	my $bulk_load_sql = "LOAD DATA INFILE ? INTO TABLE " . TABLE_NAME . " " .  
						"FIELDS TERMINATED BY '|' " .
						"ENCLOSED BY '' " .
						"LINES TERMINATED BY '\\n'";

    print "[+] Attempting to process bulk load query: $bulk_load_sql \n";
	$dbh->do($bulk_load_sql, undef, $scrubbed_csv )  || die("[!] Failed to do Bulk load into: " . TABLE_NAME . "\n");	
	
	my $sth = $dbh->prepare("SELECT count(*) FROM ".TABLE_NAME);

	$sth->execute();
	my ($cnt) = $sth->fetchrow_array();

	#unlink $scrubbed_csv;
	print "[+] Successfully imported $file -($cnt) items added to " . TABLE_NAME ."\n";	
}

=pod
	=head1 Create Fixserl Database Table (Function)

	Listed below is a BEI specification of what Fixserl looks like.

	FIXSERL consists of 20 PIPE delimited fields.

	Position Field Description Format
	0 Serial Number VARCHAR(30)
	1 Machine Description (model desc) VARCHAR(32)
	2 Initial Meter Reading INT(10)
	3 Date Sold / Rented BEI Date [MM/DD/YY]
	4 Model Number VARCHAR(30)
	5 Source Code CHAR(1)
	6 Meter Reading Last Service Call INT(10)
	7 NULL FIELD NULL
	8 Date of Last Service Call BEI Date [MM/DD/YY]
	9 Customer Number VARCHAR(32)
	10 Program Type/Contract Code VARCHAR(10)
	11 Product Code/Item Category VARCHAR(6)
	12 Sales Rep ID VARCHAR(6)
	13 Connectivity Code CHAR(2)
	14 Postal Code VARCHAR(10)
	15 SIC Number VARCHAR(6)
	16 Equipment ID VARCHAR(10)
	17 Primary Technician ID Number VARCHAR(10)
	18 Facility Management Equip VARCHAR(15)
	19 Is Under Contract INT(1) 0=false 1=true
	20 Branch ID VARCHAR(10)
	21 Customer Bill To Number VARCHAR(32)
	22 Customer Type VARCHAR(15)
	23 Territory Field VARCHAR(15)

=cut
sub create_table {
	my $dbh 			= shift or die("missing parameters");
	my $database_name 	= shift || TABLE_NAME;

	#create fixserl table
	my $create_fixserl_table_sql =  "CREATE TABLE IF NOT EXISTS $database_name (
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
	
	$dbh->do($create_fixserl_table_sql) or die("[!] Cannot create $database_name database\n");	

	print "[+] Successfully created " . DB_NAME .", refer to schema if necessary.\n";
	#print "[+] SQL: $sql\n";
}

sub drop_table {

	my $dbh 			= shift or die("[!] Missing database handler as parameter 1\n");
	
	#drop table
	my $drop_fixserl_sql = "DROP TABLE IF EXISTS " . DB_NAME;
	$dbh->do($drop_fixserl_sql) or die("[!] Cannot drop " . DB_NAME ." database\n");	

	print "[+] Successfully dropped " . DB_NAME ." database\n";
}


