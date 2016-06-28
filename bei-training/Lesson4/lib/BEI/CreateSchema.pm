package BEI::CreateSchema;

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

		$dbh->do("CREATE TABLE IF NOT EXISTS models (
			    model_id 					INT(10) AUTO_INCREMENT PRIMARY KEY,
			    model_number 				VARCHAR(32),
			    model_description			VARCHAR(100)
				);")  													|| die ("[!] Failed to create models table.\n");
		
		$dbh->do("INSERT INTO models (model_number, model_description) 
			(SELECT fixserl.model_number, fixserl.model_description FROM
		    	(SELECT fixserl.model_number, fixserl.model_description FROM fixserl
		    		GROUP BY fixserl.model_number) AS fixserl
		        		LEFT JOIN models ON fixserl.model_number = models.model_number
							WHERE models.model_id IS NULL AND NOT EXISTS(SELECT * FROM models) );")		|| die ("[!] Failed to insert data into models table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS branches (
	    			branch_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	    			branch_number 				VARCHAR(32) NOT NULL UNIQUE KEY
				 );")										 			|| die ("[!] Failed to create branches table.\n");

		$dbh->do("INSERT INTO branches (branch_number)
					SELECT fixserl.branch_id FROM
					    (SELECT fixserl.branch_id FROM fixserl
					    	GROUP BY fixserl.branch_id) AS fixserl
					        	LEFT JOIN branches ON fixserl.branch_id = branches.branch_id 
					        		WHERE branches.branch_id IS NULL AND NOT EXISTS (SELECT * from branches);") || die ("[!] Failed to insert data into branches table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS parts (
				    part_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				    part_number 				VARCHAR(32),
				    part_description 			VARCHAR(100));") 		|| die ("[!] Failed to create parts table.\n");

		$dbh->do("INSERT INTO parts ( part_number, part_description )
					SELECT fixparla.part_number, fixparla.part_description FROM
					    (SELECT fixparla.part_number, fixparla.part_description FROM fixparla
					    	GROUP BY fixparla.part_number) AS fixparla
					LEFT JOIN parts ON fixparla.part_number = parts.part_number
						WHERE parts.part_id IS NULL AND NOT EXISTS(SELECT * FROM parts);") 					|| die( "[!] Failed to insert data into parts table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS technicians (
				    technician_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				    technician_number 			VARCHAR(32) NOT NULL UNIQUE KEY
				);") 													|| die("[!] Failed to create table.\n");

		$dbh->do("INSERT INTO technicians ( technician_number )
					SELECT technician_id_number FROM 
    					(SELECT technician_id_number FROM fixserv
    						GROUP BY fixserv.technician_id_number) AS fixserv
					LEFT JOIN technicians ON fixserv.technician_id_number = technicians.technician_number
						WHERE technicians.technician_id IS NULL AND NOT EXISTS(SELECT * FROM technicians);") 		|| die("[!] Failed to insert data into table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS meter_codes (
				    meter_code_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				    meter_code 					VARCHAR(32),
				    meter_description			VARCHAR(32)
				);") || die("[!] Failed to create table.\n");

		$dbh->do("INSERT INTO meter_codes (meter_code, meter_description)
				SELECT fixmdesc.meter_code, fixmdesc.meter_code_description FROM
				    (SELECT 
				        fixmdesc.meter_code, fixmdesc.meter_code_description
				    FROM
				        fixmdesc
				    GROUP BY meter_code) AS fixmdesc
				        LEFT JOIN
				    meter_codes ON fixmdesc.meter_code = meter_codes.meter_code
				WHERE
				    meter_codes.meter_code_id IS NULL AND NOT EXISTS(SELECT * FROM meter_codes);") || die("[!] Failed to insert data into table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS customers (
				    customer_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				    customer_number 			VARCHAR(32) NOT NULL UNIQUE KEY
				);") || die("[!] Failed to create table.\n");

		$dbh->do("INSERT INTO customers ( customer_number )
				SELECT 
				    fixserl.customer_number
				FROM
				    (SELECT 
				        fixserl.customer_number
				    FROM
				        fixserl
				    GROUP BY fixserl.customer_number) AS fixserl
				        LEFT JOIN
				    customers ON fixserl.customer_number = customers.customer_number
				WHERE
				    customers.customer_id IS NULL AND NOT EXISTS(SELECT * FROM customers);") || die("[!] Failed to insert data into table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS programs (
				    program_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				    program_number 				VARCHAR(32) NOT NULL UNIQUE KEY
				);") || die("[!] Failed to create table.\n");

		$dbh->do("INSERT INTO programs ( program_number )
					SELECT 
					    program_type_code
					FROM
					    (SELECT 
					        program_type_code
					    FROM
					        fixserl
					    GROUP BY fixserl.program_type_code) AS fixserl
					        LEFT JOIN
					    programs ON fixserl.program_type_code = programs.program_number
					WHERE
					    programs.program_id IS NULL AND NOT EXISTS(SELECT * FROM programs);") || die("[!] Failed to insert data into table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS problem_codes (
				    problem_code_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				    problem_code 				VARCHAR(32),
					location_code				VARCHAR(32),
					reason_code					VARCHAR(32)
				);") || die("[!] Failed to create table.\n");

		$dbh->do("INSERT INTO problem_codes ( problem_code, location_code, reason_code ) 
					SELECT fixserv.problem_code, fixserv.location_code, fixserv.reason_code
						FROM ( SELECT 
								fixserv.problem_code, fixserv.location_code, fixserv.reason_code
							   FROM fixserv
								GROUP BY fixserv.problem_code ) AS fixserv
					LEFT JOIN problem_codes ON fixserv.problem_code = problem_codes.problem_code
					WHERE 
						problem_codes.problem_code_id IS NULL;") 		|| die("[!] Failed to insert data into table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS correction_codes (
				    correction_code_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				    correction_code 			VARCHAR(32) NOT NULL,
				    correction_code_desc 		VARCHAR(32) NOT NULL
				);") 													|| die("[!] Failed to create table.\n");

		$dbh->do("INSERT INTO correction_codes ( correction_code ) 
					(SELECT fixserv.correction_code FROM
					    (SELECT fixserv.correction_code FROM fixserv
					    	GROUP BY fixserv.correction_code) AS fixserv
					     LEFT JOIN correction_codes ON fixserv.correction_code = correction_codes.correction_code
					WHERE correction_codes.correction_code_id IS NULL AND NOT EXISTS(SELECT * FROM correction_codes));") || die("[!] Failed to insert data into table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS calltypes (
			    calltype_id	 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
			    calltype 					VARCHAR(32) NOT NULL,
			    calltype_desciption			VARCHAR(32) NOT NULL);") || die("[!] Failed to create table.\n");
		#$dbh->do("") || die("[!] Failed to insert data into table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS serials (
			    serial_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
			    serial_number 				VARCHAR(32),
				model_id 					INT(10),
				customer_id 				INT(10),
				branch_id 					INT(10),
				program_id 					INT(10),
				FOREIGN KEY ( model_id ) 	REFERENCES models	 ( model_id ),
				FOREIGN KEY ( customer_id ) REFERENCES customers ( customer_id ),
			    FOREIGN KEY ( branch_id ) 	REFERENCES branches	 ( branch_id ),
			    FOREIGN KEY ( program_id ) 	REFERENCES programs  ( program_id )
			);") || die("[!] Failed to create table.\n");

		$dbh->do("INSERT INTO serials (serial_number, model_id, customer_id, branch_id, program_id) 
					(SELECT src.serial_number, src.model_id, src.customer_id, src.branch_id, src.program_id FROM (
					  SELECT serial_id as serial_number, model_id, customer_id, b.branch_id, program_id
					  FROM fixserl AS fs
					  JOIN models AS m ON fs.model_number = m.model_number
					  JOIN customers AS c ON fs.customer_number = c.customer_number
					  JOIN branches AS b ON fs.branch_id = b.branch_number
					  JOIN programs AS pt ON fs.program_type_code = pt.program_number 
					  /*— ensure the result set is only unique serials*/
					  GROUP BY fs.serial_id, fs.model_number
					) AS src
					LEFT JOIN serials AS s ON src.serial_number = s.serial_number AND src.model_id = s.model_id
					WHERE s.serial_id IS NULL AND NOT EXISTS(SELECT * FROM serials));") || die("[!] Failed to insert data into table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS service (
				    service_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				    call_date 			VARCHAR(10),
				    date_dispatched 	VARCHAR(10),
				    arrival_time 		VARCHAR(32),
				    completion_date 	VARCHAR(32),
				    serial_number 		INT(10),
				    technician_number 	INT(10),
				    problem_code_id 	INT(10),
				    FOREIGN KEY (serial_number) REFERENCES serials (serial_id),
				    FOREIGN KEY (technician_number) REFERENCES technicians (technician_id),
				    FOREIGN KEY (problem_code_id) REFERENCES problem_codes (problem_code_id),
				    UNIQUE KEY (serial_number, completion_date) 				   			
				);") || die("Could not create services");

				
	#$dbh->do("INSERT INTO service (call_date, date_dispatched, arrival_time, completion_date, serial_number, technician_number, problem_code_id) VALUES ('','','','','','','');");
					
	$dbh->do("SELECT src.call_date, src.date_dispatched, src.arrival_time, src.completion_date, src.serial_number, src.technician_number, src.problem_code FROM (
			SELECT call_date, date_dispatched, arrival_time, completion_date, s.serial_number, t.technician_number, p.problem_code  FROM 
                fixserv AS fsv
                    JOIN serials AS s ON fsv.serial_number = s.serial_number
                    JOIN technicians AS t ON fsv.technician_id_number = t.technician_number
                    JOIN problem_codes AS p ON fsv.problem_code = p.problem_code                    
            GROUP BY fsv.serial_number) as src 
				  LEFT JOIN service AS s ON src.serial_number = s.serial_number") || die();

# services  * service ( call-datetime, dispatch-datetime, arrival-datetime, complete-datetime, FK_serials.serial_id, FK_techs.tech_id, FK_calltypes.calltype_id, FK_problem_codes.problem_code_id, FK_location_codes.location_code_id )
 #                               [ Source: FIXSERV, serials, models, techs, calltypes, problem-codes, location-codes ]
  #                              PrimaryKey ( service_id )
   #                             UniqueKey ( serial_id, comp_date, call_id )  
        		# calltype_id                     INT(10),
           #     FOREIGN KEY ( calltype_id )     REFERENCES calltypes ( calltype_id ),
   
		

		print "[+] Schema created and loaded successfully.\n";
		
		
	}
}
 



1;