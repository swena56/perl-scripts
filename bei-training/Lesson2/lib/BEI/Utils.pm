package BEI::Utils;

use constant TEMP_DIR => '/tmp/bei-tmp/';

use Exporter 'import';
@EXPORT_OK = qw ( 
					 verify_zip 
					 extract_zip 
					 make_temp_directory 
					 normalize_file_names
					 get_temp_file_listing
					 cleanup_temp_directory
				);

use strict;
use warnings;

use File::Spec;
use File::Copy qw(move);

use Data::Dumper;

sub verify_zip {
	
	#collect parameters, the absolute path is trusted from unzip
	my $zip_file 		= shift || die("[!] Missing input_file.zip as parameter 1.\n");

	print "[+] Attempting to verify zip file: $zip_file \n";

	#does file exist
	if (-e $zip_file){
	print "[+] File Exists.\n";
	} else {
		die("[!] File does not exist!   \n");		#check if file exists
	} 

	print "[+] Testing Zip zip_file for errors\n";
	print "[+] unzip -t $zip_file \n";
	my $output = `unzip -t $zip_file`; 
	
	#now parse results for errors 
	 if($output =~ m/no errors/i)
	 {
	 	print "[+] Valid Zip.\n";
	 	return 1;
	 		
	 }

	return '';
}

#create temp directory if not exists
sub make_temp_directory {
	
	if (-e TEMP_DIR ){
		print "[+] Temp Directory Exists: " . TEMP_DIR ."\n";
	} else {
		mkdir TEMP_DIR || die ("[!] Failed to create temp directory for Utils::unzip \n");
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
			print "[!] File Normalized: $cmd \n";
			system("$cmd");
		}
	} 									
}

sub get_temp_file_listing {
	
	#array of extracted files
	my @extracted_files = ();

 		#list files
 		opendir ( DIR, TEMP_DIR ) || die "[!] Error opening directory\n";
 		print "[+] Contents of " . TEMP_DIR . ":\n";
 		
 		while (my $filename = readdir(DIR)){
 			chomp $filename;

 			if($filename ne '..' && $filename ne '.'){

 					#add file names to array
 					print "     $filename \n";	
 					push @extracted_files, (TEMP_DIR . "$filename"); 	
 								
 			}
 		}

 	return @extracted_files;
}

sub cleanup_temp_directory {

	#empty temp dir
	print "[+] Cleanup time...emptying contents of " . TEMP_DIR . " directory\n";

	system("rm -rf " . TEMP_DIR);
	# rm TEMP_DIR \ *.*
}

=pod

	The zip files contain names with spaces, fix them
	loop files - rename with out spaces

	returns an array of extracted files

	TODO
		rename to extract
		mkdir -p 
		needed to do a chown on zip file, should this be handled automatically?
		add current file special parameter to debug statements
=cut
sub extract_zip {

	my $zip_file = shift || die("[!] Missing input.zip as parameter.  \n");
	   $zip_file = File::Spec->rel2abs( $zip_file );
	   

	   print "[+] Requested Zip File: $zip_file \n";


	#check if valid zip
	die("[!] Failed to validate zip: $zip_file \n") if(!verify_zip("$zip_file"));
	   

	make_temp_directory();

	my $temp_dir = shift || "/tmp/bei-tmp/";
	
	#check if valid zip, if it is extract it
	if( verify_zip ($zip_file,$temp_dir))
	{
		#command used for extraction
		my $cmd = "unzip -xjoq $zip_file -d $temp_dir";

		print "[+] Attempting to unzip: $cmd \n";
		
		my $results = `$cmd`;
		
		#could the extraction fail, and what would it look like?
 		die("[!] Extraction Errors!\n") if($results =~ m/error/i);
 		
 		normalize_file_names();

		print "[+] Unzip success. \n";

		return get_temp_file_listing();
	}
	return '';
}



1;

=pod

 =head1 unzip_test 
 	file needs to be absolute

	my $abs_path = File::Spec->rel2abs( $rel_path ) ;
=cut