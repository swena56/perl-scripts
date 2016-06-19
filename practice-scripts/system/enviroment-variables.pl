#!/usr/bin/perl
# enviroment-variables.pl Andrew Swenson

use strict;
use warnings;
use 5.18.0;

say "Operating system: $^O";

foreach my $k ( keys %ENV ) {
    print "$k \n";
}

