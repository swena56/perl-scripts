#!/usr/bin/perl
use strict;
use warnings;
 
print qq(Content-type: text/plain\n\n);
 
print "hello world cgi perl script.\n";
print scalar localtime;

