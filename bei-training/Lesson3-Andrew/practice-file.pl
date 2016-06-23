#!/usr/bin/perl -w
# practice-file.pl

use FindBin;
use lib "$FindBin::Bin/lib";

use strict;
use warnings;

use Data::Dumper;

#attempting to figure out using my classes that extend off of ascii base class
#use BEI::ETL::AsciiBaseClass;
#use BEI::ETL::TemplateClass;
#my $obj = BEI::ETL::FixserlClass->new(7); 
#print Dumper($obj);

use BEI::Utils qw(convert_date);

print "Practice file\n";

#converting Dates in perl

BEI::Utils::convert_date("9-22-1999");
&convert_date("10-22-1999");


