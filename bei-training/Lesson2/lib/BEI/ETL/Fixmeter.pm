package BEI::ETL::Fixmeter;

use constant TABLE_NAME => 'fixmeter';
use constant DB_NAME => 'fixmeter';

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
		=head1 

				FIXMETER

		=head1 Schema
		Multiple meter service call information

				FIXMETER consists of six PIPE delimited fields.

				Position	Field Description		Format
				0		Call ID				VARCHAR(15)
				1		Model				VARCHAR(30)
				2		Serial Number			VARCHAR(30)
				3		Completion Date		BEI Date [MM/DD/YY]
				4		Meter Code			VARCHAR (20)
				5		Meter Reading			INT(10)
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
		 	my $call_id 					= "@$value[0]";
			my $model 						= "@$value[1]";
			my $serial_number 				= "@$value[2]";
			my $completion_date 			= "@$value[3]";
			my $meter_code	 				= "@$value[4]";
			my $meter_reading				= "@$value[5]";
					
			my $line = "$call_id|$model|$serial_number|$completion_date|$meter_code|$meter_reading\n";

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
					call_id 					varchar(15),
					model 						varchar(30),
					serial_number 				varchar(30),
					completion_date 			varchar(10),
					meter_code 					varchar(20),
					meter_reading 				INT(10)
					);";
	
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