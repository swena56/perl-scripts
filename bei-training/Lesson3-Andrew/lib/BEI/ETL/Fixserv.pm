package BEI::ETL::Fixserv;

use constant TABLE_NAME => 'fixserv';
use constant DB_NAME => 'fixserv';

use Exporter 'import';
@EXPORT = 	qw(
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

			

		=head1 Schema
	
			FIXSERV
Service call detail file

FIXSERV consists of 27 PIPE delimited fields.

Position	Field Description	 		Format
0		NULL FIELD				NULL
1		Call ID Number				VARCHAR(15)
2		Model Number				VARCHAR(30)
3		Serial Number				VARCHAR(30)
4		Call Date				BEI Date [MM/DD/YY]
5		Call Time				BEI Time [HHMM]
6		Customer Time*			VARCHAR(4) *[HHMM]
7		Arrival Time				BEI Time [HHMM]
8		Call Completion Time			BEI Time [HHMM]
9		Call Type (EM/PM/SH/HP)		VARCHAR(10)
10		Problem Code				VARCHAR(4)
11		Location Code				VARCHAR(4)
12		Reason Code				VARCHAR(4)
13		Correction Code			VARCHAR(4)
14		Date Dispatched			BEI Date [MM/DD/YY]
15		Time Dispatched			BEI Time [HHMM]
16		Completion Date			BEI Date [MM/DD/YY]
17		Meter Reading (total meter)		INT(10)
18		Meter Reading of PRIOR Call		INT(10)
19		Date of PRIOR Service Call		BEI Date [MM/DD/YY]
20		PC-Type (leave NULL)			VARCHAR(4) || NULL
21		LC-Type (leave NULL)			VARCHAR(4) || NULL
22		NULL FIELD				NULL
23		Machine Status				VARCHAR(1)
24		Technician ID Number			VARCHAR(10)
25		Customer Number			VARCHAR(32)
26		Miles Driven				INT(10)	
27		Response Time				VARCHAR(4) [HHMM]

* Customer Time:
	This field is slightly different than the other BEI Time fields in that it’s a ‘total’ time field that is displayed in total hours along with total minutes.  90 minutes is displayed (zero filled) as 0130.  2 hours is displayed as 0200.

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

