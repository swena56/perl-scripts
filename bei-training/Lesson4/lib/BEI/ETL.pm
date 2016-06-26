package BEI::ETL;

=pod

includes strict and warnings

set defaults
=cut
use Moose;
use UNIVERSAL::require;

no warnings 'uninitialized';

has 'dbh' => (
	is => 'ro',
	required => 1,
	isa => 'Object'

);

has 'file' => (
	is => 'ro',
	required => 1,
	isa => 'Str'	
);

has 'table_name' => (
	is => 'ro',
	default => sub {

		my $self = shift;	
		die ("abstract function child must implement.") ;
	}
);

after 'run' => sub { 
	
	my $self = shift;
	print "[+] " . $self->table_name . " import done. \n\n";
};



#around - look into this http://search.cpan.org/dist/Moose/lib/Moose/Manual/MethodModifiers.pod

=pod 


=cut

sub bulk_load_sql {
	
	my $self = shift;
	my $table = $self->table_name();
	my $sql =  "LOAD DATA INFILE ? INTO TABLE $table " .  
					"FIELDS TERMINATED BY '|' " .
					"ENCLOSED BY '' " .
					"LINES TERMINATED BY '\\n'";

	return $sql; 
}

sub bulk_load_file {

	my $self = shift;
	my $scrubbed_csv = shift; #
	my $file = $self->file();
	my $dbh = $self->dbh();
	my $table = $self->table_name();

	my $bulk_load_sql = $self->bulk_load_sql(); 

    print "[+] Processing bulk load query: $bulk_load_sql \n";

	$dbh->do($bulk_load_sql, undef, $scrubbed_csv )  || die("[!] Failed to do Bulk load into: $table\n");	
	
	my $sth = $dbh->prepare("SELECT count(*) FROM ".$table);

	$sth->execute();
	my ($cnt) = $sth->fetchrow_array();

	#unlink $scrubbed_csv;
	print "[+] Table $table updated with $cnt records. \n";
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

	#parse and scrub data
	my $scrubbed_csv = $self->scrub_csv();

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

		open ( my $csv, "<", $file)    		|| die ("[!] Could not open unscrubbed file.\n");
		my $output_file = "$file.scrubbed";
		open ( my $fh, ">", $output_file)	|| die ("[!] Could not write scrubbed date to file.\n");

		my $num_lines = 0;

		 while(<$csv>){

		 	my $line = $self->scrub_line($_);
			my $valid_data = 1;


			#check if line is empty
			#if($line =~ / /)

			#print scrubbed data to file if it is valid
			if($valid_data) {

				#print "Line-$num_lines:$line";	#prints each line of the file
				$num_lines++;

				print $fh "$line";

			} else {

				print "[!] Not valid data \n";
			}
				
		}

		print "[+] Scrub CSV: $output_file has $num_lines lines of valid data.\n";
		
		close $fh;	#close scrubbed output csv file
		close $csv;
		

		#system("gedit $input_csv.scrubbed");  #open scrubbed file in gedit -> useful for debugging

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
	my $sql = $self->create_table_sql();
	
	$dbh->do($sql) || die("[!] Cannot create $table database\n");	

	print "[+] Created $table table, refer to schema in the corresponding ETL class for additional details.\n";
	#print "[+] SQL: $sql\n";
}

sub drop_table {

	my $self = shift;
	my $dbh = $self->dbh();
	my $table = $self->table_name();
	my $sql = "DROP TABLE IF EXISTS $table";

	$dbh->do($sql) || die("[!] Cannot drop $table table.\n");	

	print "[+] Dropped all pre-existing $table data.\n";
}

sub Factory {

	my $class = shift;
	my $dbh = shift;
	my $file = shift;
	my $etl_class; 

	if($file =~ m/addr/i) {
		print "[+] Detected addr in file: $file \n";
		$etl_class = "BEI::ETL::Fixaddr";

	} elsif($file =~ m/billing/i) {
		print "[+] Detected billing in file: $file \n";
		$etl_class = "BEI::ETL::Fixbilling";

	} elsif($file =~ m/callt/i) {
		print "[+] Detected parla in file: $file \n";
		$etl_class = "BEI::ETL::Fixcallt";

	} elsif($file =~ m/labor/i) {
		print "[+] Detected labor in file: $file \n";
		$etl_class = "BEI::ETL::Fixlabor";

	} elsif($file =~ m/mdesc/i) {
		print "[+] Detected mdesc in file: $file \n";
		$etl_class = "BEI::ETL::Fixmdesc";

	} elsif($file =~ m/meter/i) {
		print "[+] Detected meter in file: $file \n";
		$etl_class = "BEI::ETL::Fixmeter";

	} elsif($file =~ m/parla/i) {
		print "[+] Detected parla in file: $file \n";
		$etl_class = "BEI::ETL::Fixparla";

	} elsif($file =~ m/ploc/i) {
		print "[+] Detected ploc in file: $file \n";
		$etl_class = "BEI::ETL::Fixploc";

	} elsif($file =~ m/serl/i) {
		print "[+] Detected serl in file: $file \n";
		$etl_class = "BEI::ETL::Fixserl";

	} elsif($file =~ m/serv/i) {
		print "[+] Detected serv in file: $file \n";
		$etl_class = "BEI::ETL::Fixserv";

	} elsif($file =~ m/ship/i) {
		print "[+] Detected ship in file: $file \n";
		$etl_class = "BEI::ETL::Fixship";

	} elsif($file =~ m/tech/i) {
		print "[+] Detected tech in file: $file \n";
		$etl_class = "BEI::ETL::Fixtech";

	} else {

		warn "[!] ETL $file not found!!\n";
		return;
	} 

	$etl_class->require;

	#example of defaults
	return $etl_class->new( 'dbh' => $dbh, 'file' => $file );
}

1;