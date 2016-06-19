#!/usr/bin/perl
# regex.pl by Andrew Swenson

use strict;
use warnings;
use 5.18.0;

print "Regualr Expressions\n";
print "-----------------------------------\n";
my $s = "This is a line of text.";
print "search-line: " . $s . "\n";
print "results for (\\s+) (Shows groups non-whitespace characters):         " , join(",", split(/\s+/,$s)) . "\n" ;
print join(",", split(/a/,$s)) . "\n";
print join(",", split(/i/,$s)) . "\n";


#how to parse ip addresses
my $ip = "An ip address 192.168.1.1 that is contained within a series of text.";
print "\nMatching ip addresses with this regex: ???? \n";
print join(",", split(/\./,$ip)) . "\n";
#print join(",", split(/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/,$ip)) . "\n";
#^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$
#^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$
#\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b

my $text_to_search = "example text with [foo] and more";
my $search_string = quotemeta "[foo]";
print "searchText: " . $text_to_search . "\n";
print "searchKeyword: " .  $search_string ."\n"; 
print "Keyword Found!\n" if ($text_to_search =~ /$search_string/);

#date at the beginning of a string
my $date = "2012-07-04T15:00:00 is when the crazyness happened!  But wait there is more.";
$date =~ /^\d\d\d\d/;
print $date;

print "\n\nDone!\n";
#say foreach split(/\s+/, $s);

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

Grouping and capturing

   (...)       Grouping and capturing
   \1, \2      Capture buffers during regex matching
   $1, $2      Capture variables after successful matching

   (?:...)     Group without capturing (don't set \1 nor $1)


Resources
http://perlmaven.com/regex-cheat-sheet

=cut