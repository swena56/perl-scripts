#!/usr/bin/perl
# executeSystemCommands.pl
use strict;
use warnings;
use 5.010;
 
say system "ls -lrt";
say $?;
say $? >> 8;

#not sure what the three trailing 0's are.