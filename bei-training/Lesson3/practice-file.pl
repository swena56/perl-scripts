#!/usr/bin/perl -w
# practice-file.pl

use FindBin;
use lib "$FindBin::Bin/lib";

use strict;
use warnings;
use Data::Dumper;

use BEI::ETL::AsciiBaseClass;
use BEI::ETL::FixserlClass;

my $obj = BEI::ETL::FixserlClass->new(7); 



print "practice file\n";
print Dumper($obj);