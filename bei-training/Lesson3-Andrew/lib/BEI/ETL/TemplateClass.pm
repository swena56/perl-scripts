package BEI::ETL::TemplateClass;
require Exporter;
require AsciiBaseClass;
@ISA = qw (Exporter AsciiBaseClass);
@EXPORT = qw(new ); 

use warnings;
use strict;
use Data::Dumper;
use constant DB_NAME => 'fixserl';

sub new {
	my $type = shift;
	my $this = BEI::ETL::AsciiBaseClass->new();
	print Dumper($this);
}

sub setType{
	my ($class, $name) = @_;
	$class->{'Fixserl'} = $name;
	print "Set type to fixserl\n";
}

#not public
sub create_table {
	
}

sub to_string {

}

1;