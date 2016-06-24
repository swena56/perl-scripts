package BEI::ETL::Fixmdesc;

use strict;
use warnings;

use base 'BEI::ETL';
no warnings 'uninitialized';

=pod
	=head1 	FIXMDESC - Multiple meter codes and descriptions

		FIXMDESC consists of two PIPE delimited fields.
	
	=head2 Schema

	Position	Field Description 			Format
	0			Meter Code					VARCHAR(20)
	1			Meter Code Description		VARCHAR(100)

	*this file is used to store dealer meter codes and map them to standard BEI meter codes.  
	
	This enables BEI to import multiple meters and create BEI reports based off this data.
=cut

sub table_name {

	return "fixmdesc";  
}

sub scrub_line {

	my $self = shift;
	my $line = shift;
	chomp $line;

 	my @array = split /\|/, $line;
 	my $meter_code					= "$array[0]";
	my $meter_code_description		= "$array[1]";
	
	$line = "\n";

	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS $table (
					meter_code 				varchar(20),
					meter_code_description 	varchar(100)
				);";
	return $sql;
}

1;