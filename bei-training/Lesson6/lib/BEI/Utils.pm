package BEI::Utils;

use Exporter 'import';
@EXPORT_OK = qw ( 
				 verify_and_convert_date
				 verify_zip 
				 extract_zip 
				 make_temp_directory 
				 normalize_file_names
				 get_temp_file_listing
				 get_file_line_count
				 cleanup_temp_directory
				);

use strict;
use warnings;

use File::Spec;
use File::Copy qw(move);
use Data::Dumper;
use POSIX qw(strftime);
#use Date::Manip;
use DateTime;
use Date::Calc qw/check_date/;


use constant TEMP_DIR => '/tmp/bei-tmp/';

=pod
	=head1 Convert Date

	Accepts an array of strings, or a single string and returns the BEI standardized Date format

	In reference to BEI ASCII File Format Specs
	- All dates should be ASCII Gregorian dates, in the following format: VARCHAR(8) [MM/DD/YY] 

	POSIX str

	=head2 a different way
	my $month;
	my $day;
	my $year;

	my $dt; 

    eval { $dt = DateTime->new( 
        year => $year, 
        month => $month, 
        day => $day);
    }; 

    print "Error: $@" if $@;

=cut
sub verify_and_convert_date {

	my $date = shift || die("[!] Please provide a date to the convert date function for parameter 1 \n" );


	#parse date out
	if( $date =~ /^\d{4}-\d{1,2}-\d{1,2}$/ ){
		return 1;
	}

	if ( $date =~  /^[0-9]{2}-[0-9]{2}-[0-9]{4}$/ ) 	#[MM-DD-YY]
	{
		
		return 1;
	} 
	if ( $date =~  /^[0-9]{2}[0-9]{2}[0-9]{4}$/ ) 	#[MMDDYY]
	{
		
		return 1;
	}

	if ($date =~ /\d{2}\d{2}?-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])/)
	{
		return '1';
	}

	return '';
}

sub verify_zip {
	
	#collect parameters, the absolute path is trusted from unzip
	my $zip_file 		= shift || die("[!] Missing input_file.zip as parameter 1.\n");

	print "[+] Attempting to verify zip file: $zip_file \n";

	#does file exist
	die("[!] File does not exist!\n") if (!-e $zip_file);

	print "    unzip -t $zip_file ";
	my $output = `unzip -t $zip_file`;
	
	#now parse results for errors 
	 if($output =~ m/no errors/i)
	 {
	 	print "..............Valid Zip.\n";
	 	return 1;
	 		
	 }

	return '';
}

#create temp directory if not exists
# not usng -p flag for mkdir
sub make_temp_directory {

	if (-e TEMP_DIR ){
		print "[+] Temp Directory Exists: " . TEMP_DIR ."\n";
	} else {
		mkdir TEMP_DIR || die ("[!] Failed to create temp directory: " . TEMP_DIR . "\n");
	}
}

sub normalize_file_names {

	#open temp directory and rename files to not include spaces.
	my @files = get_temp_file_listing();

	foreach my $file (@files){
		my $orginal = $file;
		if($file =~ s/ /-/g)
		{		
			my $cmd = "mv \"$orginal\" $file";		
			system("$cmd");
		}
	} 									
}

sub get_temp_file_listing {	

	my @extracted_files = ();													#array of extracted files

 		#list files
 		opendir ( DIR, TEMP_DIR ) || die "[!] Error opening directory\n";
 		print "[+] Contents of " . TEMP_DIR . ":\n";
 		
 		while (my $filename = readdir(DIR)){
 			chomp $filename;

 			if($filename ne '..' && $filename ne '.'){							#do not want to show current directory (.) and parent directory (..)
 					
 					print "     $filename\n";
 					push @extracted_files, (TEMP_DIR . "$filename"); 			#add file names to array				
 			}
 		}
 	return @extracted_files;
}

sub get_file_line_count {

	my $file = shift || die("[!] File does not exist can not perform line count!\n");

	# might be missing the commandline util wc so plan for that.

	return `wc -l '$file'`;
}

sub cleanup_temp_directory {

	#empty temp dir
	print "[+] Cleanup time...emptying contents of " . TEMP_DIR . " directory\n\n";

	system("rm -rf " . TEMP_DIR);	#this deletes the entire directory
	# rm TEMP_DIR \ *.*             #might want to consider an option to just remove the files
}


=pod
	=head1 Extract Zip
	The zip files contain names with spaces, fix them
	loop files - rename with out spaces

	returns an array of extracted files

	TODO
		rename to extract
		needed to do a chown on zip file, should this be handled automatically?
		add current file special parameter to debug statements
=cut
sub extract_zip {

	my $zip_file = shift || die("[!] Missing input.zip as parameter.  \n");
	   $zip_file = File::Spec->rel2abs( $zip_file );
	   
	print "[+] Requested Zip File: $zip_file\n";
	   
	make_temp_directory();
	
	#check if valid zip, if it is extract it
	if( verify_zip ($zip_file,TEMP_DIR))
	{
		#command used for extraction
		my $cmd = "unzip -xjoq $zip_file -d " . TEMP_DIR;

		print "[+] Attempting to unzip: $cmd \n";
		
		my $results = `$cmd`;
		
		#could the extraction fail, and what would it look like?
 		die("[!] Extraction Errors!\n") if($results =~ m/error/i);
 		print "[+] Unzip successful - $zip_file \n\n";	
 		

 		normalize_file_names();
 		print "[+] Normalizing file names.\n";

		return get_temp_file_listing();
	} else {
		die("[!] Failed to validate zip: $zip_file \n");
		return '';
	}

	return '1';
}





#test data
my $date = "10-23-99";
chomp($date);

if(verify_and_convert_date($date)){

	print "Date: $date is valid\n";
} else {

	print "Date: $date is not valid\n";
}

1;