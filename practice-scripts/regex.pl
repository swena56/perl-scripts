#!/usr/bin/perl
# regex.pl by Andrew Swenson

use strict;
use warnings;
use 5.18.0;


#regex.pl


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

*      Match 0 or more times
+      Match 1 or more times
?      Match 1 or 0 times
{n}    Match exactly n times
{n,}   Match at least n times
{n,m}  Match at least n but not more than m times

=cut

print "Regualr Expressions\n";


my $s = "This is a line of text.";

say foreach split(/\s+/, $s);

#match opperator
my $var =~ m/test/;