package BEI::ETL::Fixploc;

use Moose;

extends 'BEI::ETL';

has 'table_name' => (
	is => 'ro',
	default => 'fixploc'
);

no warnings 'uninitialized';

=pod
	=head1 			FIXPLOC
		Parts location information

		FIXPLOC consists of a minimum of  seven PIPE delimited fields with a dynamic maximum number.

	=head2 Schema

		Position	Field Description		Format
		0 			Product Code			VARCHAR(30)
		1			Vendor Part Number		VARCHAR(18)
		2			Description				VARCHAR(30)
		3			Identifier (S, P, O)	CHAR(1)
		4			Item Cost				VARCHAR(12)**
		5			Record Creation Date	BEI Date [MM/DD/YY]
		6			Total Qty. On Hand		INT(10)
		7			Warehouse Qty (number to follow)	INT(10)
		8			Warehouse Location Number VARCHAR(10)
		9			Qty On Hand						INT(10)

		* dynamic warehouse fields to follow.  1 warehouse number followed by 1 qty on hand
		n                      Warehouse Location Number n	VARCHAR(10)
		n1                     Qty On Hand n1	INT(10)
		* and so on

		**Item Cost
		Can be in either float 2-point format w/ decimal point (99999.99) OR float 5-point format WITHOUT the decimal point 123456754321 [BEI will place a decimal point between the 7 and 5].  So 000000450024 will correspond to 4.50.
=cut

sub scrub_line {

	my $self = shift;
	my $line = shift;
	chomp $line;

 	my @array = split /\|/, $line;
 	my $product_code				= "$array[0]";
	my $vendor_part_number			= "$array[1]";
	my $description 	 			= "$array[2]";
	my $identifier 					= "$array[3]";
	my $item_cost	 				= "$array[4]";
	my $record_creation_date		= "$array[5]";
	my $total_qty					= "$array[6]";
	my $warehouse_qty 				= "$array[7]";
	my $warehouse_location_num		= "$array[8]";
	my $qty_on_hand		 			= "$array[9]";
	
	#02008051|02008051|CHARGE ROLLER CLEANING ROLLER|10|1033|1|2088|2|5001|6|6001|1| Z
	$line = "$product_code|$vendor_part_number|$description|$identifier|$item_cost|$record_creation_date|$total_qty|$warehouse_qty|$warehouse_location_num|$qty_on_hand\n";

	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS $table (
					product_code 			VARCHAR(30),
					vendor_part_number 		VARCHAR(18),
					description 			VARCHAR(30),
					identifier 				CHAR(1),
					item_cost				VARCHAR(12),
					record_creation_date 	VARCHAR(10),
					total_qty 				INT(10),
					warehouse_qty			INT(10),
					warehouse_location_number VARCHAR(10),
					qty_on_hand 			INT(10)
		        );";
	return $sql;
}
1;