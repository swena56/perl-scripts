package BEI::ETL::Fixtech;

use strict;
use warnings;

use base 'BEI::ETL';
no warnings 'uninitialized';

=pod
	=head1 FIXSHIP

		FIXSHIP consists of nine PIPE delimited fields of items shipped to customer for the period of time.

	=head2 Schema

		Position	Field Description			Format
		0			Date						BEI Date [MM/DD/YY]
		1			Item Number					VARCHAR(18)
		2			Item Category				CHAR(1)
		3			Service Category			VARCHAR(15)
		4			Description					VARCHAR(30)
		5			Quantity 					INT(10)
		6			Price 						VARCHAR(12)**
		7			Customer Ship To Number		VARCHAR(32)
		8			Customer Number				VARCHAR(32)
		9			Customer Bill To Number		VARCHAR32)	
=cut

sub table_name {

	return "fixcallt";  
}

sub scrub_line {

	my $self = shift;
	my $line = shift;
	chomp $line;

 	my @array = split /\|/, $line;
 	my $date 						= "$array[0]";
	my $item_number 				= "$array[1]";
	my $item_category 				= "$array[2]";
	my $service_category 			= "$array[3]";
	my $description 				= "$array[4]";
	my $quantity 					= "$array[5]";
	my $price 						= "$array[6]";
	my $customer_ship_to_number		= "$array[7]";
	my $customer_number 			= "$array[8]";
	my $customer_bill_to_number		= "$array[9]";
	
	$line = "$date|$item_number|$item_category|$service_category|$description|$quantity|$price|$customer_ship_to_number|$customer_number|$customer_bill_to_number\n";
	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS $table (
					date 					VARCHAR(10),
					item_number				VARCHAR(18),
					item_category			CHAR(1),
					description				VARCHAR(30),
					quantity 				INT(10),
					price 					VARCHAR(12),
					customer_ship_to_number VARCHAR(32),
					customer_number 		VARCHAR(32),
					customer_bill_to_number VARCHAR()32
			    );";
	return $sql;
}

1;