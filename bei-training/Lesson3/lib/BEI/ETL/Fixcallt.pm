package BEI::ETL::Fixcallt;

use strict;
use warnings;

use base 'BEI::ETL';
no warnings 'uninitialized';

=pod
	=head1 FIXCALLT - Dealer Calltype Information

		FIXCALLT consists of 2 PIPE delimited fields of tech time for the associated service calls 
 	
 	=head2 Schema

		Position 	Field Description 	Format 
		0 			Call Type 			VARCHAR(10) 
		1 			Description 		VARCHAR(100) 
=cut

sub table_name {

	return "fixcallt";  
}

sub bulk_load_sql {

	my $self = shift;
	my $table = $self->table_name();

	my $sql = "LOAD DATA INFILE ? INTO TABLE " . $table . " " .  
						"FIELDS TERMINATED BY '|' " .
						"ENCLOSED BY '' " .
						"LINES TERMINATED BY '\\n'";

	return $sql;
}

sub scrub_line {

	my $self = shift;
	my $line = shift;
	chomp $line;

 	my @array = split /\|/, $line;
 	my $call_type 						= "$array[0]";
	my $description 					= "$array[1]";
	

	$line = "$call_type|$description\n";

	return $line;
}

sub create_table_sql {

	my $self = shift;
	my $table = $self->table_name();

	#create fixserl table
	my $sql =  "CREATE TABLE IF NOT EXISTS $table (
					call_type 		VARCHAR(10),
					description 	VARCHAR(100)
			   );";
	
	return $sql;
}
1;