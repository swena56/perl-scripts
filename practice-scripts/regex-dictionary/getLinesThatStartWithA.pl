#!/usr/bin/perl
# getLinesThatStartWithA.pl

use 5.18.0;
use warnings;

my $dictionaryLocation = "dictionary.txt";

open FH, $dictionaryLocation;
my @lines = <FH>;
close FH;

my @validLines = ();

foreach my $line (@lines)
{
      if($line =~ /^i/)
      {
        chomp $line;
        push @validLines, $line;    
      }    
}

say foreach @validLines;
my $count = scalar @validLines;
print "num: $count \n";