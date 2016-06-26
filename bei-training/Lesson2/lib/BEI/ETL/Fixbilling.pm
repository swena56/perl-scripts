Fixbilling.pm

=pod 
	=head1 FIXBILLING - Meter Billing Information

		FIXBILLING consists of five PIPE delimited fields.  One line per model, serial, metercode

	=head2 Schema
		Position	Field Description		Format
		0		Model				VARCHAR(30)
		1		Serial Number			VARCHAR(30)
		2		Billing Date			BEI Date [MM/DD/YY]
		3		Meter Code			VARCHAR (20)
		4		Meter Reading			INT(10)
=cut


