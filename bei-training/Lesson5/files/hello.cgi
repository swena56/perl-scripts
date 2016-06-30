#!/usr/bin/perl
#http http://localhost/cgi-bin/hello.cgi
use strict;
use CGI;

my $q = CGI->new();

print $q->header();

print $q->h1("Hello, World!");

print "Hello, Andrew…";

exit;