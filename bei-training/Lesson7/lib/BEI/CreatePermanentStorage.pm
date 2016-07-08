package BEI::CreatePermanentStorage;

use Exporter 'import'; # gives you Exporter's import() method directly
@EXPORT_OK = qw(run);  # symbols to export on request

use Moose;
use DBI;

use strict;
use warnings;
no warnings 'uninitialized';

sub run {

	my $dbh 			= shift || die("[!] Create Schema is missing database handler for parameter 1.\n");
	
	if ( $dbh ) {

$dbh->do("
CREATE TABLE IF NOT EXISTS models (
	model_id INT(10) AUTO_INCREMENT PRIMARY KEY,
	model_number VARCHAR(30),
	model_description VARCHAR(100)
);
") || die ("[!] Failed to create models table.\n");

#branches
$dbh->do("CREATE TABLE IF NOT EXISTS branches (
branch_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
branch_number 				VARCHAR(32) NOT NULL UNIQUE KEY
);")										 			|| die ("[!] Failed to create branches table.\n");

#parts
$dbh->do("CREATE TABLE IF NOT EXISTS parts (
part_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
part_number 				VARCHAR(18),
part_description 			VARCHAR(100));") 		|| die ("[!] Failed to create parts table.\n");

#technicians
$dbh->do("CREATE TABLE IF NOT EXISTS technicians (
technician_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
technician_number 			VARCHAR(32) NOT NULL UNIQUE KEY
);") 													|| die("[!] Failed to create table.\n");

#meter_codes
$dbh->do("CREATE TABLE IF NOT EXISTS meter_codes (
meter_code_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
meter_code 					VARCHAR(32),
meter_description			VARCHAR(32)
);") || die("[!] Failed to create table.\n");

#customers
$dbh->do("CREATE TABLE IF NOT EXISTS customers (
customer_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
customer_number 			VARCHAR(32) NOT NULL UNIQUE KEY
);") || die("[!] Failed to create table.\n");

#programs
$dbh->do("CREATE TABLE IF NOT EXISTS programs (
program_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
program_number 				VARCHAR(32) NOT NULL UNIQUE KEY
);") || die("[!] Failed to create table.\n");

#problem codes
$dbh->do("CREATE TABLE IF NOT EXISTS problem_codes (
problem_code_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
problem_code 				VARCHAR(32),
UNIQUE KEY (problem_code)

);") || die("[!] Failed to create table.\n");

#correction codes
$dbh->do("CREATE TABLE IF NOT EXISTS correction_codes (
correction_code_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
correction_code 			VARCHAR(32),
correction_code_desc 		VARCHAR(32)
);") 													|| die("[!] Failed to create table.\n");

#location codes
$dbh->do("CREATE TABLE IF NOT EXISTS location_codes (
location_code_id		INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
location_code 			VARCHAR(4)
)");

#call types
$dbh->do("
CREATE TABLE IF NOT EXISTS call_types (
call_type_id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
call_type VARCHAR(10),
call_type_description	VARCHAR(32),
UNIQUE KEY (call_type));
") || die("[!] Failed to create table.\n");

#serials table
$dbh->do("CREATE TABLE IF NOT EXISTS serials (
serial_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
serial_number 				VARCHAR(30) NOT NULL,
model_id 					INT(10),
customer_id 				INT(10),
branch_id 					INT(10),
program_id 					INT(10),
FOREIGN KEY ( model_id ) 	REFERENCES models	 ( model_id ),
FOREIGN KEY ( customer_id ) REFERENCES customers ( customer_id ),
FOREIGN KEY ( branch_id ) 	REFERENCES branches	 ( branch_id ),
FOREIGN KEY ( program_id ) 	REFERENCES programs  ( program_id ),
UNIQUE KEY ( serial_number, model_id )
);") || die("[!] Failed to create table.\n");

#service
$dbh->do("
CREATE TABLE IF NOT EXISTS service (
service_id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
call_datetime DATETIME,
dispatched_datetime DATETIME,
arrival_datetime DATETIME,
completion_datetime  DATETIME,
serial_id INT(10),
technician_id INT(10),
problem_code_id INT(10),
location_code_id INT(10),
call_id_not_call_type VARCHAR(10) NOT NULL,
call_type_id INT(10),
FOREIGN KEY (serial_id) REFERENCES serials (serial_id),
FOREIGN KEY (technician_id) REFERENCES technicians (technician_id),
FOREIGN KEY (problem_code_id) REFERENCES problem_codes (problem_code_id),
FOREIGN KEY (location_code_id) REFERENCES location_codes (location_code_id),
FOREIGN KEY (call_type_id) REFERENCES call_types (call_type_id),
UNIQUE KEY (serial_id, completion_datetime, call_id_not_call_type) );
") || die("Could not create service table");
			
#* service-meters ( FK_service.service_id, FK_meter-codes.meter_code_id, meter ) [ Source: FIXMETER; Link FIXMETER TO FIXSERV based on model, serial, call_id, comp_date -- called meter_date in fixmeter ]
#PRIMARY KEY service_meter_id (service_id, meter_code_id ));

#service_meters
$dbh->do("
CREATE TABLE IF NOT EXISTS service_meters (
service_id INT(10) NOT NULL,
meter_code_id INT(10) NOT NULL,
meter INT(10),
FOREIGN KEY ( service_id )  REFERENCES service ( service_id ),
FOREIGN KEY ( meter_code_id ) REFERENCES meter_codes ( meter_code_id ),
PRIMARY KEY  ( service_id , meter_code_id ));
");

#TODO completion data
#AND service.service_id = fixmeter.call_id 
#AND DATE(service.completion_datetime) = fixmeter.completion_date

#billing		
$dbh->do("CREATE TABLE IF NOT EXISTS billing_meters (
serial_id INT(10) NOT NULL,
bill_date VARCHAR(10) NOT NULL,
meter_code_id INT(10) NOT NULL,
meter_code VARCHAR(20),
FOREIGN KEY ( serial_id )  	   REFERENCES serials ( serial_id ),
FOREIGN KEY ( meter_code_id )  REFERENCES meter_codes ( meter_code_id ),
PRIMARY KEY ( serial_id, meter_code_id, bill_date ));
");

#* service-parts ( FK_service.service_id, FK_parts.part_id, qty, cost, addsub ) [ Source: FIXPARLA; Link FIXPARLA TO FIXSERV based on model, serial, call_id, install_date ( to comp_date ) ]
 #                               PrimaryKey ( service_id, part_id, addsub )
#service_parts  #model, serial, call_id, install_date ( to comp_date ) ]
$dbh->do("CREATE TABLE IF NOT EXISTS service_parts (
service_id  INT(10) NOT NULL,
part_id  INT(10) NOT NULL,
addsub CHAR(1) NOT NULL,
cost DECIMAL(12,4),
FOREIGN KEY ( part_id )  REFERENCES parts ( part_id ),
FOREIGN KEY ( service_id )  REFERENCES service ( service_id ),
PRIMARY KEY ( service_id, part_id, addsub ));
");

		print "[+] Created Permenant Storage Tables.\n";
		
		
	}
}
 



1;