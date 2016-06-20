#!/usr/bin/perl
#perlMavenPractice.pl

use warnings;
use 5.18.0;
use Scalar::Util qw(looks_like_number);
use Data::Dumper qw(Dumper);

print "Random Practice from perl maven\n";

#random data - how do i seed
my $random = rand();
say "random number: $random";

print "100 random numbers: ";
print rand() foreach (1..100);

#numeric data
say "Numeric Data";
my $num1 = "3";
my $num2 = "3.14";
my $num3 = "3.15e27";
my $num4 = "10xy";
my @arr = ($num1, $num2, $num3, $num4);
say "@arr";
say $num1 + $num2;
say $num3 + $num4;   #these numbers can not be added
my $x = '23y';
my $y = '17x';
say $x + $y;   # 40
say looks_like_number("10x");
say looks_like_number("10");
say "comparing numbers to strings";
my $x = '23';
my $y = '17x';
say $x >= $y;  # 1
say $x + $y;   # 40

my $filename = "practice-scripts/regex-dictionary/dictionary.txt";
open FH, $filename;
my @lines = <FH>;
close FH;
say "random line from dictionary: $lines[int(rand(scalar @lines))]";
#random line from file
#use File::Random qw/random_line/;
#my $line = random_line($filename);

#function parameters
print myfunction('parameter1', 'parameter2');
sub myfunction()
{
	say "@_";
	my @parameters = @_;
	say "Number of parameters: ", (scalar @parameters);
	say foreach @parameters;
	return "--";
}
#does the function key word exist?


my @matrix;
$matrix[0][0] = 'data at 0,0';
$matrix[0][1] = 'data at 0,1';
my @innerArr = qw(10 15 23 100 34);
$matrix[1][3] = "@innerArr";	#not sure how to save it as an array
say "\n@matrix";
say "$matrix[0][0]";
say "$matrix[0][2] <- matrix[0][2] is undef";
say "@innerArr";
say $innerArr[0];
say Dumper \@matrix;

say "What about hashes";
my %hash = { 'key' => 'value'};
my %hash1 = { 'key' , 'value'};
say Dumper \%hash;
say Dumper \%hash1;
say "%hash1 -hmm thats not right.";
my %grades;
$grades{"test"}{mathematics} = 98;
$grades{"test2"}{Art} = 60;
say Dumper \%grades;

my %namesHash;
$namesHash{1}{"first-name"} = "Andrew";
$namesHash{1}{"last-name"} = "Swenson";
$namesHash{1}{"age"} = 29;
$namesHash{2}{"first-name"} = "Yoda";
$namesHash{2}{"last-name"} = "Insert Starwars lastname here";
$namesHash{2}{"age"} = 700;
say Dumper "printout of nameshash", \%namesHash;
say "$namesHash{1} this does not show the value";
say %{$namesHash{1}}," but this does";  # can not interoplate a hash array, not sure

#writing a cpan package
# I did this in the folder customCPAN mine is Math-Calc

say "\nDemo of comparison operators";
my $num1 = 45;
my $num2 = 2;
my $num3 = 45;
my $str1 = "alpha";
my $str2 = "beta";
my $str3 = "alpha";
say "when comparing numbers I will use traditional php style comparison operators";
say "num1 and num2 are the same" if($num1 == $num3);
say "num1 is greater than num2" if($num1 > $num2);
say "when comparing strings I will use traditional bash style string comparison operators";
say "str1 does not equal str2" if($str1 ne $str2);
say "str1 is less than str2" if($str1 le $str2);
say "str1 equals str3" if($str1 eq $str3);

say "12.0 = 12" if("12.0" == 12);
say "12.0 ne 12 when comparing them like strings" if("12.0" ne 12);

say "comparing strings as if they are numbers will give misleading results" if("foo" == "bar");




#sort by first name











