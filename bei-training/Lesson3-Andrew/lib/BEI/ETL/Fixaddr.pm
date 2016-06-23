package BEI::ETL::Fixploc;  #not done

use constant TABLE_NAME => 'fixploc';
use constant DB_NAME => 'fixploc';

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

	=head1 FIXADDR - Customer Number Address Information

		FIXADDR consists of five PIPE delimited fields.

	=head2	Schema
		Position	Field Description		Format
		0		Customer Number		VARCHAR(32)
		1		Address			VARCHAR(200)
		2		City				VARCHAR(200)
		3		State / Province			VARCHAR(200)
		4		Postal Code			VARCHAR(10)

FIXADDR Customer Number field should match the Customer Number field in the FIXSERL file, which can be mapped back to a serial number – model number entity.

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
			my $customer_number	 			= "@$value[0]";
			my $address			 			= "@$value[1]";
			my $city			 			= "@$value[2]";
			my $state_or_province 			= "@$value[3]";
			my $postal_code		 			= "@$value[4]";

			my $line = "$customer_number|$address|$city|$state_or_province|$postal_code\n"

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

sub import_csv {
	my ($dbh, $file) = @_;

	#error checking
	die("[!] " . DB_NAME . " File does not exist: $file\n") 		if(!(-e $file));
	die("[!] " . DB_NAME . " Database handler does not exist\n") 	if(!$dbh);

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
	my $dbh 				= shift || 	die("[!] " . DB_NAME . " - Missing database handle for parameter 1");
	my $database_name 		= shift || 	TABLE_NAME;
	my $create_table_sql 	= shift || 	"CREATE TABLE IF NOT EXISTS " . TABLE_NAME . "(
												customer_number		VARCHAR(32)
												address				VARCHAR(200)
												city				VARCHAR(200)
												state_or_province	VARCHAR(200)
												postal_code			VARCHAR(10)
										);";
	
	$dbh->do($create_table_sql) or die("[!] Cannot create $database_name database\n");	

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


