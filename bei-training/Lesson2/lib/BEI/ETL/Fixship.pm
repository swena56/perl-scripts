Fixship.pm

=pod 
 =head1 FIXSHIP


FIXSHIP consists of nine PIPE delimited fields of items shipped to customer for the period of time.

Position	Field Description			Format
0		Date					BEI Date [MM/DD/YY]
1		Item Number				VARCHAR(18)
2		Item Category				CHAR(1)
3		Service Category			VARCHAR(15)
4		Description				VARCHAR(30)
5		Quantity 				INT(10)
6		Price 					VARCHAR(12)**
7		Customer Ship To Number		VARCHAR(32)
8		Customer Number			VARCHAR(32)
9		Customer Bill To Number		VARCHAR(32)
=cut
