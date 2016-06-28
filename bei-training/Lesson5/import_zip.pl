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
use BEI::CreateSchema qw(run);

use constant TEMP_DIR => "/tmp/bei-tmp";

my $num_args        = $#ARGV + 1;
my @zip_files       = ();
my %extracted_files = ();

# for debugging only
#print "[+] Emptying entire database -  for debugging purposes only.\n";
#print `sh files/drop_all.sh`;
#print `sh files/drop_all.sh`;
#print `sh files/drop_all.sh`;
#print `sh files/drop_all.sh`;

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
    push( @zip_files, "files/50600516_DLAvPgzytc_webftp.zip" );
}

#clean up clutter in temp directory
&cleanup_temp_directory();    # i might need to prove that this works

#extract data and its content files to an array for processing
foreach my $zip (@zip_files) {
    my @files = &extract_zip( $zip, TEMP_DIR );

    $extracted_files{$zip} = \@files;

    #push @extracted_files, \@files;
}

#connect to database
my $dbh = &connect();

#print Dumper(%extracted_files);   #debug code

foreach my $zip ( keys %extracted_files ) {

    my $num_files = ( scalar @{ $extracted_files{$zip} } );

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
    }
}

#prepare database schema.
BEI::CreateSchema::run($dbh);

#how to handle duplicate data

#close database connection
$dbh->disconnect();
print "[+] Done...disconnected from database.\n";
