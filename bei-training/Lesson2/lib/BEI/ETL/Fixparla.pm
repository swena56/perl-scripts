package BEI::ETL::Fixparla;

use constant TABLE_NAME => 'fixparla';
use constant DB_NAME => 'fixparla';

use Exporter 'import';
@EXPORT = qw(
					scrub_csv
					import_csv
				 	create_table
				 	drop_table
				); 

#optional dev imports
use strict;
use warnings;
no warnings 'uninitialized';

use Parse::CSV;
use Data::Dumper;

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
		 	my $serial 						= "@$value[0]";
			my $part_number 				= "@$value[1]";
			my $part_description 			= "@$value[2]";
			my $add_sub_indicator 			= "@$value[3]";
			my $quantity_used 				= "@$value[4]";
			my $call_id 					= "@$value[5]";
			my $model_number 				= "@$value[6]";
			my $serial_number 				= "@$value[7]";
			my $installation_date 			= "@$value[8]";
			my $init_meter_reading 			= "@$value[9]";
			my $parts_cost 					= "@$value[10]";
			my $customer_number 			= "@$value[11]";
			
			my $line = "$serial|$part_number|part_description|$add_sub_indicator|$quantity_used|$model_number".
					   "|$serial_number|$installation_date|$init_meter_reading|$parts_cost|customer_number\n";

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

		print "[+] (" . DB_NAME .") Successfully scrubbed $input_csv => $input_csv.scrubbed\n";

		return  "$input_csv.scrubbed";
	}

	print  "[!] (" . DB_NAME . ") Failed to parse and scrub csv file \n";
	return '';
}

sub import_csv {

	my ($dbh, $file) = @_;

	#error checking
	die("[!] " . DB_NAME . " File does not exist: $file\n") if(!(-e $file));
	die("[!] " . DB_NAME . " Database handler does not exist\n") if(!$dbh);

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

sub create_table {

	my $dbh 			= shift || die("[!] Missing database handle for parameter 1");

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS ".DB_NAME." (
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
	
	$dbh->do($sql) || die("[!] Cannot create " . DB_NAME ." database\n");	

	print "[+] Successfully created " . DB_NAME ." database: $sql\n";
}

sub drop_table {

	my $dbh 			= shift or die("[!] Missing database handler as parameter 1\n");
	
	#drop table
	my $drop_fixserl_sql = "DROP TABLE IF EXISTS " . DB_NAME;
	$dbh->do($drop_fixserl_sql) or die("[!] Cannot drop " . DB_NAME ." database\n");	

	print "[+] Successfully dropped " . DB_NAME ." database\n";
}

1;