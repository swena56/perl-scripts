#!/usr/bin/perl
# fileFound.pl Andrew Swenson

#use strict;
use warnings;
use 5.18.0;
use Data::Dumper;

open(FH, "regex-dictionary/dictionary.txt");
my @lines = <FH>;
close(FH);

my $dic_size = scalar @lines;
say "The Dictionary has $dic_size number of lines.\n";

#example hash code
my %hash = ( one => 'uno', two => 'dos', three => 'tres', four => 'quatro', five => 'cinco' );

while( my ($k, $v) = each %hash ) {
    say "$k -> $v";
}

#now lets try some regex
my %matches = ();



foreach my $line (@lines)
{
	my @traits = {};
	if( $line =~ /^i/)
	{
		$matches{'i'} = [$matches{'i'}, $line];
		#say "Starts with i: $line";
	}

	if( $line =~ /a{2}/)
	{
		#push ${matches}, { name => '$line'};
		#say "Has two a's in a row: $line";
	}
$matches{'a'} = [ $line];
	#$matches{$line} = [ 'a'];
}





Dumper(%matches);
print %matches;
print "\n";

#say  scalar @matches;



