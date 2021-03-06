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
    get_file_line_count
    cleanup_temp_directory
);

use BEI::ETL;
use BEI::CreatePermanentStorage qw(run);

use BEI::InsertTempTables qw(run);

use constant TEMP_DIR => "/tmp/bei-tmp";

my $num_args        = $#ARGV + 1;
my @zip_files       = ();


# for debugging only
print "[+] Emptying entire database -  for debugging purposes only.\n";
print `files/drop_all.sh`;

#connect to database
my $dbh = &connect();


BEI::CreatePermanentStorage::run($dbh);

#process zip files provided by arguments if there are none lets use our test data
if ( $num_args > 0 ) {
    foreach my $arg (@ARGV) {
        print "[+] CommandLine Args: $arg\n";
        push( @zip_files, $arg );
    }
}
else {
    #use the default test data
    print "[+] Using default test data.\n";
    push( @zip_files, "files/50600316_ZIjEpwVAAm_webftp.zip" );
    push( @zip_files, "files/50600416_Zj6SBrvd34_webftp.zip" );
    push( @zip_files, "files/50600516_DLAvPgzytc_webftp.zip" );
}

#extract data and its content files to an array for processing
foreach my $zip (@zip_files) {

     &cleanup_temp_directory();
   
    my @files = &extract_zip( $zip, TEMP_DIR );
    my %extracted_files = ();
    $extracted_files{$zip} = \@files;

    my $num_files = ( scalar @{ $extracted_files{$zip} } );

    #loop through the extracted files and process them
    for ( my $index = 0; $index < $num_files; $index++ ) {

        my $current_file = @{ $extracted_files{$zip} }[$index];
        print "[+] ("
            . ( $index + 1 )
            . "/$num_files) files to be processed.\n";

        BEI::Utils::get_file_line_count($current_file);

        my $obj = BEI::ETL->Factory( $dbh, $current_file );
        if ($obj) {
            $obj->run();
        }

         #clean up clutter in temp directory
        unlink $current_file;
        print "[+] Clear temp directory for $zip\n";
       
    }

     #insert the temp tables in permenant storage
    BEI::InsertTempTables::run($dbh);
    print "[+] Successfully Inserted data from $zip\n";
    print "-----------------------------------------------------------------------\n";
 
}


   
    #close database connection
    $dbh->disconnect();
print "[+] Done...\n";
