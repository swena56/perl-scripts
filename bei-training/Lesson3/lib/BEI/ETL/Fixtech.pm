package BEI::ETL::Fixtech;

use strict;
use warnings;

use base 'BEI::ETL';
no warnings 'uninitialized';

=pod
	=head1 		FIXTECH - Technician Model Training information

		FIXTECH consists of a minimum of two PIPE delimited fields with a maximum number or three. One line per trained equipment, you can have hundreds of lines per tech.
	
	=head2 Schema

		Position	Field Description			Format
		0			Technician ID Number		VARCHAR(10)
		1			Branch Number				VARCHAR(4)
		2			Model Number				VARCHAR(30)
=cut

sub table_name {

	return "fixtech";  
}

sub scrub_line {

	my $self = shift;
	my $line = shift;
	chomp $line;

 	my @array = split /\|/, $line;
 	my $technician_id_number		= "$array[0]";
	my $branch_number 				= "$array[1]";
	my $model_number	 			= "$array[2]";

	$line = "$technician_id_number|$branch_number|$model_number\n";

	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	my $sql =  "CREATE TABLE IF NOT EXISTS $table (
			      technician_id_number		VARCHAR(10),
			      branch_number				VARCHAR(4),
			      model_number				VARCHAR(30)
				);";	
	return $sql;
}

1;