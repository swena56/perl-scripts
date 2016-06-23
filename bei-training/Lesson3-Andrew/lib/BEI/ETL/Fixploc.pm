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
		 	my $product_code 							= "@$value[0]";
			my $meter_code_description 				= "@$value[1]";
			
			my $line = "$product_code|$vendor_part_number|$description|$identifier|$item_cost|$record_creation_date|$total_qty|$warehouse_qty|$warehouse_location_number|$qty_on_hand\n";

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

	=head1 FIXPLOC Parts location information

FIXPLOC consists of a minimum of  seven PIPE delimited fields with a dynamic maximum number.

	=head2 Schema
		Position	Field Description	Format
		0 	Product Code	VARCHAR(30)
		1	Vendor Part Number	VARCHAR(18)
		2	Description	VARCHAR(30)
		3	Identifier (S, P, O)	CHAR(1)
		4	Item Cost	VARCHAR(12)**
		5	Record Creation Date	BEI Date [MM/DD/YY]
		6	Total Qty. On Hand	INT(10)
		7	Warehouse Qty (number to follow)	INT(10)
		8	Warehouse Location Number	VARCHAR(10)
		9	Qty On Hand	INT(10)

		* dynamic warehouse fields to follow.  1 warehouse number followed by 1 qty on hand
		n                      Warehouse Location Number n	VARCHAR(10)
		n1                     Qty On Hand n1	INT(10)
		* and so on

		**Item Cost
	Can be in either float 2-point format w/ decimal point (99999.99) OR float 5-point format WITHOUT the decimal point 123456754321 [BEI will place a decimal point between the 7 and 5].  So 000000450024 will correspond to 4.50.
=cut 

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

=pod
	 
	=head1	FIXMDESC - Multiple meter codes and descriptions

	FIXMDESC consists of two PIPE delimited fields.

	Position	Field Description 			Format
	0		Meter Code				VARCHAR(20)
	1		Meter Code Description			VARCHAR(100)

*this file is used to store dealer meter codes and map them to standard BEI meter codes.  
This enables BEI to import multiple meters and create BEI reports based off this data.

=cut
sub create_table {
	my $dbh 			= shift or die("missing parameters");
	my $database_name 	= shift || TABLE_NAME;

	#create fixserl table
	my $create_fixserl_table_sql =  "CREATE TABLE IF NOT EXISTS " . DB_NAME . "(
		product_code				varchar(30),
		vendor_part_number			varchar(18),
		description 				varchar(30),
		identifier 					char(1),
		item_cost					varchar(12),
		record_creation_date 		varchar(10),
		total_qty 					int(10),
		warehouse_qty 			 	int(10),
		warehouse_location_number 	varchar(30),
		qty_on_hand					int(10)
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


