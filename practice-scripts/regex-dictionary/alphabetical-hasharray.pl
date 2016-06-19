#!/usr/bin/perl
#alphabetical-hasharray.pl

use 5.18.0;
use warnings;

print "Alphabetical Hash Array\n";

my $file = "dictionary.txt";

open FH,$file;
  my @lines = <FH>;
close FH;



my @alpha = qw(a b c d e f g h i j k l m n o p q r s t u v w x y z);
print "Alphabet: " . (join ",", @alpha) . "\n";

my %alphaHashes = ();
foreach my $letter (@alpha)
{
    foreach (1..5)
    {
        push %alphaHashes, ($letter => rand);
    }
}
print $lines[100];
