#!/usr/bin/perl -w
# Person

use warnings;
use strict;


package Person;
sub new
{
    my $class = shift;
    my $self = {
        _firstName       => shift,
        _lastName  		 => shift,
        _birthDate       => shift,
        _title			 => shift,
    };
    # Print all the values just for clarification.
    print "First Name is $self->{_firstName}\n";
    print "Last Name is $self->{_lastName}\n";
    print "BirthDate is $self->{_birthDate}\n";
    print "Title is $self->{_title}\n";
    bless $self, $class;
    return $self;
}



#instentiate