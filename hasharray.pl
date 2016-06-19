#!/usr/bin/perl
# hasharray.pl

use 5.18.0;
use warnings;

my @words = qw(This is a test);

say foreach @words;

my %hash = ( 1 => 'x', 2 => 'y', 3 => 'z');