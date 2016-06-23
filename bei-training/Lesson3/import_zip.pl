#!/usr/bin/perl -w
#import_zip.pl  # consider

=pod
	=head1 Import Zip
	Use this area to add BEI modules.  There will be a layer of encapsulation that I am not seeing yet.  Be ready!	
=cut

use strict;
use warnings;

use FindBin;
use File::Spec;
use lib "$FindBin::Bin/lib";

use Data::Dumper;
use BEI::DB 'connect';

use BEI::Utils qw(   
					 extract_zip 
					 verify_zip    
					 make_temp_directory 
					 normalize_file_names
					 get_temp_file_listing
					 cleanup_temp_directory
				);

use BEI::ETL;

use constant TEMP_DIR => "/tmp/bei-tmp";

my $num_args = $#ARGV+1;
my @zip_files = ();
my %extracted_files = (); 

#process zip files provided by arguments if there are none lets use our test data
if($num_args > 0) {
	foreach my $arg (@ARGV){	
		print "[+] CommandLine Args: $arg\n";
		push(@zip_files, $arg);
	}
} else {
	#use the default test data
	print "[+] Using default test data.\n";
	push(@zip_files, "files/50600516_DLAvPgzytc_webftp.zip");
}

#clean up clutter in temp directory
&cleanup_temp_directory();			# i might need to prove that this works

#extract data and its content files to an array for processing
foreach my $zip (@zip_files)
{
	my @files = &extract_zip($zip, TEMP_DIR);

	$extracted_files{$zip} = \@files;
	#push @extracted_files, \@files;
}

#connect to database
my $dbh = &connect();

foreach my $zip (keys %extracted_files){

	#process each file that was extracted
	foreach my $file ( @{$extracted_files{$zip}} ) {

		my $obj = BEI::ETL->Factory($dbh, $file);
		if($obj)
		{
			$obj->run();

		}
#		if($file =~ m/serl/i){
#			my $obj = BEI::ETL::Fixserl->new($dbh, $file);
#			$obj->run();
#		} elsif($file =~ m/parla/i){
#			my $obj = BEI::ETL::Fixparla->new($dbh, $file);
#			$obj->run();
#		}
		
	
	}


}


print "[+] Finished Successfully\n";