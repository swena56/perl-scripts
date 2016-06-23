Fixlabor.pm

=pod

 =head1 FIXLABOR

	FIXLABOR consists of 12 PIPE delimited fields of tech time for the associated service calls

=head2 Schema
	Position	Field Description			Format

	0		Call ID Number				VARCHAR(15)
	1		Model					VARCHAR(30)
	2		Serial					VARCHAR(30)
	3		Activity Code				VARCHAR(15)
	4		Assist					INT(1) 0=false 1=true
	 5		Date					BEI Date [MM/DD/YY]
	6		Tech Number 				VARCHAR(10)
	7		Dispatch Time, HHMM			BEI Time [HHMM]
	8		Arrival Time, HHMM			BEI Time [HHMM]
	9		Departure Time, HHMM			BEI Time [HHMM]
	10		Interrupt Hours				VARCHAR(4) *[HHMM] 
	11		Mileage					INT(10)

*CUST TIME*: This field is slightly different than the other BEI Time fields in that it’s a ‘total’ time field that is displayed in total hours along with total minutes.  90 minutes is displayed (zero filled) as 0130.  2 hours is displayed as 0200.
=cut
