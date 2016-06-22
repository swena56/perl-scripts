package BEI::ETL::AsciiBaseClass;

use Exporter 'import';
@ISA = qw(Exporter);

@EXPORT = qw( new setColumns); 

#optional dev imports
use strict;
use warnings;
no warnings 'uninitialized';

#imports
use Parse::CSV;
use Data::Dumper;
=pod
	=head1 Baseclass for Ascii Import Files
	
	Will contatin all of the common functionality between all of the different styles of imports
=cut
sub new {
	my $database = shift || die("Ascii base class missing database handler\n");
	my $type = shift;
	my $this = {};

	$this->{'AsciiBaseClass'} = 'ascii';
	bless $this, $database;
	return $this;
}

sub setColumns {
	my ($class, $name) = @_;
}

sub scrub_csv {

	my $input_csv = shift || die("[!]  Missing input_file.csv as parameter 1.\n");

	my $parser    = Parse::CSV->new(
								file       => "$input_csv",
								sep_char   => '|',						
							);
		


}

sub create_table {

	
}

sub drop_table {

	my $dbh 			= shift or die("[!] Database handler as parameter\n");
	my $database_name 	= shift ;

	#drop table
	my $drop_fixserl_sql = "DROP TABLE $database_name";
	$dbh->do($drop_fixserl_sql) or die("[!] Cannot drop $database_name database\n");	

	print "[+] Successfully dropped $database_name database\n";
}

1;