#!/usr/bin/perl -w

use strict;
use warnings;
use FindBin;


use FindBin;
use File::Spec;
use lib "$FindBin::Bin/lib";

use BEI::UTILS;

print "UTILS class.\n";


BEI::UTILS->extract_zip("files/50600516_DLAvPgzytc_webftp.zip");


