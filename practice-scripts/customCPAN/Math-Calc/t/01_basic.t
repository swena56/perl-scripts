use strict;
use warnings;
 
use Test::More tests => 2;
 
use_ok 'Math::Calc';
 
is Math::Calc::add(19, 23), 42, 'good answer';
