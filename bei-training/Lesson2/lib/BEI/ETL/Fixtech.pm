FixTech.pm

=pod
	=head1 FIXTECH - Technician Model Training information

		FIXTECH consists of a minimum of two PIPE delimited fields with a maximum number or three. One line per trained equipment, you can have hundreds of lines per tech.
	=head2 Schema
		Position	Field Description		Format
		0		Technician ID Number		VARCHAR(10)
		1		Branch Number			VARCHAR(4)
		2		Model Number			VARCHAR(30)
=cut 
my $sql = "tech_id varchar(10)";
my $tech_id;
my $branch_number;
my $model_number;