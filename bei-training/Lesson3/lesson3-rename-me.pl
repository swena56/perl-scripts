#!/usr/bin/perl -w

use strict;
use warnings;


=pod
* Review homework assignments
* Perl Training:
                - Classes & Objects
                - Factory Pattern
               
* Homework:
* Refactor code into classes for FIX files [ serl, serv, parla, meter, billing ], use a FactoryPattern to return the proper class to preform the operation
 
Example:
 
for my $file (@files) {
                my $handler = BEI::IO::ELTFactory->findHandler( file => $file, dbh => $dbh );
                eval {
                                $handler->run();
                };
                if ($@) {
                                croak "ETL Handler Exception: $@";
                }
}
 
 
lib/BEI/ELT/
 
* exporting zip file
 
* clean-array
* mk temp table
* load data infile
=cut
