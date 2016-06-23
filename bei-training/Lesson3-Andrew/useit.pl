#!/usr/bin/perl
# useit.pl using the Number module

use FindBin;
use File::Spec;
use lib "$FindBin::Bin/lib";

use strict;
use warnings;

use BEI::Number;


my $obj = BEI::Number->new(7);    # call the constructor w/a value
# $obj now contains our object from before. remember
# that new() returned it ( in the guise of $self )

print "the number is ",$obj->dump(),"\n";

$obj->add(3);        # call the add() method on our object
print "now the number is ",$obj->dump(),"\n";

my $num = $obj->subtract(5);
print "now the number is $num\n";
# remember that subtract() returns the current value of our number
# so that $num has that value assigned to it.

$obj->change(999999);
print "number changed to ",$obj->dump(),"\n";

# NOTE:    if you include the object method inside the double
#    quoted string in print() then it wouldnt work, it'll return the
#    memory address of the object and "->dump()" appended
#    to it...

exit();