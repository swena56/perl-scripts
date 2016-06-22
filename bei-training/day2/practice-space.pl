#!/usr/bin/perl -w
#practice-space.pl  # consider
=pod
	=head1 Practice Space
	Use this area to add BEI modules.  There will be a layer of encapsulation that I am not seeing yet.  Be ready!	
=cut

use strict;
use warnings;

use FindBin;
use File::Spec;
use lib "$FindBin::Bin/lib";

use Data::Dumper;
use BEI::DB 'connect';
use BEI::Utils qw(   extract_zip 
					 verify_zip    
					 make_temp_directory 
					 normalize_file_names
					 get_temp_file_listing
					 cleanup_temp_directory
				);

use BEI::ETL::Fixserl qw(import_fixserl create_fixserl_table drop_fixserl_table);  
#use BEI::ETL::Fixserve; 
#...
#... lot more to write to create a complete data processing domain
#...
#use BEI::ETL::Fixparla; 


my $temp_dir = "/tmp/bei-tmp";
my @arr_files = extract_zip("files/50600516_DLAvPgzytc_webftp.zip", $temp_dir);

my $dbh = &connect();

drop_fixserl_table($dbh);

if(create_fixserl_table($dbh)){

	print "[+] Processing extracted files that where successfully scrubbed.\n";
	foreach my $file (@arr_files)
	{
		if($file =~ m/fixserl/i)
		{

			print "[+] Detected Fixserl: $file\n";
			my $results = import_fixserl($dbh, $file);	

		}
	}
	}else {
		die("[!] Could not create fixserl table\n");
	}








