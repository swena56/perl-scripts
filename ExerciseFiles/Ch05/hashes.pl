#!/usr/bin/perl
# hashes.pl by Andrew Swenson

=pod
	.   Match any character
	\w  Match "word" character (alphanumeric plus "_")
	\W  Match non-word character
	\s  Match whitespace character
	\S  Match non-whitespace character
	\d  Match digit character
	\D  Match non-digit character
	\t  Match tab
	\n  Match newline
	\r  Match return
	\f  Match formfeed
	\a  Match alarm (bell, beep, etc)
	\e  Match escape
	\021  Match octal char ( in this case 21 octal)
	\xf0  Match hex char ( in this case f0 hexidecimal)
=cut

use strict;
use warnings;
use 5.18.0;


