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

use BEI::ETL::Fixserl ();
use BEI::ETL::Fixparla ();
use BEI::ETL::Fixserv ();
use BEI::ETL::Fixmeter ();
use constant TEMP_DIR => "/tmp/bei-tmp";

my $num_args = $#ARGV+1;
my @zip_files = ();
my @extracted_files = ();

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
&cleanup_temp_directory();

#extract data and its content files to an array for processing
foreach my $zip (@zip_files)
{
	push @extracted_files, &extract_zip($zip, TEMP_DIR);
}

#connect to database
my $dbh = &connect();

#process each file that was extracted
foreach my $file (@extracted_files) {
	(BEI::ETL::Fixserl::import_csv($dbh, $file)  && print "\n[+] Detected Fixserl: $file\n") 	if($file =~ m/fixserl/i);	
	(BEI::ETL::Fixparla::import_csv($dbh, $file) && print "\n[+] Detected Fixparla: $file\n") 	if($file =~ m/fixparla/i);	
	(BEI::ETL::Fixserv::import_csv($dbh, $file)  && print "\n[+] Detected Fixserv: $file\n") 	if($file =~ m/fixserv/i);	
	(BEI::ETL::Fixmeter::import_csv($dbh, $file) && print "\n[+] Detected Fixmeter: $file\n")	if($file =~ m/meter/i);	
}

print "[+] Finished Successfully\n";