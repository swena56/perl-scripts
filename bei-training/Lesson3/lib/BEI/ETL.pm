package BEI::ETL;

use strict;
use warnings;
use UNIVERSAL::require;

no warnings 'uninitialized';

sub new {

	my $class = shift;
	my $dbh   = shift 	|| die ("missing dbh");
	my $file   = shift || die ("missing file");

	# easy way to create a hash reference
	my $self = { 
		'dbh' => $dbh,
		'file' => $file,
	};	

	bless $self, $class;		# creates an object out of this hash

	return $self;
}

sub dbh {

	my $self = shift;

	return $self->{'dbh'};
}

sub file {

	my $self = shift;

	return $self->{'file'};
}

sub table_name {

	die ("abstract function child must implement.") ;
}

sub bulk_load_sql {

	die ("abstract function child must implement.") ;
}

sub bulk_load_file {

	my $self = shift;
	my $scrubbed_csv = shift; #
	my $file = $self->file();
	my $dbh = $self->dbh();
	my $table = $self->table_name();

	my $bulk_load_sql = $self->bulk_load_sql(); 

    print "[+] Attempting to process bulk load query: $bulk_load_sql \n";

	$dbh->do($bulk_load_sql, undef, $scrubbed_csv )  || die("[!] Failed to do Bulk load into: $table\n");	
	
	my $sth = $dbh->prepare("SELECT count(*) FROM ".$table);

	$sth->execute();
	my ($cnt) = $sth->fetchrow_array();

	#unlink $scrubbed_csv;
	print "[+] Successfully imported $file -($cnt) items added to " . $table ."\n";	
}

sub run {

	my $self = shift;
	my $dbh = $self->dbh();
	my $file = $self->file();
	my $table = $self->table_name();

	#Drop table
	$self->drop_table();

	#drop table
	$self->create_table();
	
	print "[+] Attempting to scrub csv $file\n";

	#parse and scrub data
	my $scrubbed_csv = $self->scrub_csv();

	print "[+] Scrubbed File being imported: $scrubbed_csv\n";

	#bulk load into database
	$self->bulk_load_file($scrubbed_csv);
}

sub scrub_line {

	die ("abstract function child must implement.") ;
}

sub scrub_csv {
	
	my $self = shift;
	my $dbh = $self->dbh();
	my $file = $self->file;
	my $table = $self->table_name();

	if ($dbh) {	

		open ( my $csv, "<", $file);

		my $output_file = "$file.scrubbed";

		open ( my $fh, ">", $output_file);
		
		#while ( my $value = $parser->fetch ) {	
		 while(<$csv>){

		 	my $line = $self->scrub_line($_);

			my $valid_data = 1;

			#print scrubbed data to file if it is valid
			if($valid_data){
				print $fh "$line";
			}else{
				print "[!] Not valid data \n";
			}
				
		}
		
		close $fh;	#close scrubbed output csv file
		close $csv;
		
		#system("gedit $input_csv.scrubbed");  #open scrubbed file in gedit -> useful for debugging

		print "[+] ($table) Successfully scrubbed $file => $output_file\n";

		return  $output_file;
	}

	print "[!] ($table) Failed to parse and scrub csv file \n";
	return '';
}

sub create_table_sql {

	die ("abstract function child must implement.") ;
}

sub create_table {

	my $self = shift;
	my $dbh = $self->dbh();
	my $table = $self->table_name();

	#create fixserl table
	my $sql = $self->create_table_sql();
	
	$dbh->do($sql) or die("[!] Cannot create $table database\n");	

	print "[+] Successfully created $table, refer to schema if necessary.\n";
	#print "[+] SQL: $sql\n";
}

sub drop_table {

	my $self = shift;
	my $dbh = $self->dbh();
	my $table = $self->table_name();
	
	#drop table
	my $drop_fixserl_sql = "DROP TABLE IF EXISTS $table";
	$dbh->do($drop_fixserl_sql) or die("[!] Cannot drop $table database\n");	

	print "[+] Successfully dropped $table database\n";
}

sub Factory {

	my $class = shift;

	my $dbh = shift;
	my $file = shift;

	my $etl_class;

	if($file =~ m/serl/i)
	{
		$etl_class = "BEI::ETL::Fixserl";

	} else {

		warn "$file class not define \n";
		return;
	}

	$etl_class->require;

	return $etl_class->new($dbh, $file);
}



1;