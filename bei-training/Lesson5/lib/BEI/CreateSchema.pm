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
			    model_number 				VARCHAR(30),
			    model_description			VARCHAR(100)
				);")  													|| die ("[!] Failed to create models table.\n");
		
		$dbh->do("INSERT INTO models (model_number, model_description) 
			SELECT fixserl.model_number, fixserl.model_description 
			FROM ( 
				SELECT fixserl.model_number, fixserl.model_description 
				FROM fixserl
		    	GROUP BY fixserl.model_number
		    ) AS fixserl
		    LEFT JOIN models ON fixserl.model_number = models.model_number
			WHERE models.model_id IS NULL")		|| die ("[!] Failed to insert data into models table.\n");

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
						WHERE parts.part_id IS NULL;") 					|| die( "[!] Failed to insert data into parts table.\n");

		$dbh->do("CREATE TABLE IF NOT EXISTS technicians (
				    technician_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				    technician_number 			VARCHAR(32) NOT NULL UNIQUE KEY
				);") 													|| die("[!] Failed to create table.\n");

		$dbh->do("INSERT INTO technicians ( technician_number )
					SELECT technician_id_number 
					FROM 
    					(SELECT technician_id_number FROM fixserv
    						GROUP BY fixserv.technician_id_number) AS fixserv
					LEFT JOIN technicians ON fixserv.technician_id_number = technicians.technician_number
						WHERE technicians.technician_id IS NULL") 		|| die("[!] Failed to insert data into table.\n");

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
				    meter_codes.meter_code_id IS NULL;") || die("[!] Failed to insert data into table.\n");

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
				    customers.customer_id IS NULL ;") || die("[!] Failed to insert data into table.\n");

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
					    programs.program_id IS NULL;") || die("[!] Failed to insert data into table.\n");
		#problem codes
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
						problem_codes.problem_code_id IS NULL
						AND fixserv.problem_code IS NOT NULL
						AND fixserv.problem_code != '';") 		|| die("[!] Failed to insert data into table.\n");

		#correction codes
		$dbh->do("CREATE TABLE IF NOT EXISTS correction_codes (
				    correction_code_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				    correction_code 			VARCHAR(32),
				    correction_code_desc 		VARCHAR(32)
				);") 													|| die("[!] Failed to create table.\n");

		$dbh->do("INSERT INTO correction_codes ( correction_code ) 
					(SELECT fixserv.correction_code FROM
					    (SELECT fixserv.correction_code FROM fixserv
					    	GROUP BY fixserv.correction_code) AS fixserv
					     LEFT JOIN correction_codes ON fixserv.correction_code = correction_codes.correction_code
					WHERE correction_codes.correction_code_id IS NULL 
					  AND fixserv.correction_code IS NOT NULL 
					  AND fixserv.correction_code != '');") || die("[!] Failed to insert data into table.\n");

		#location codes
		$dbh->do("CREATE TABLE IF NOT EXISTS location_codes (
					location_code_id		INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
					location_code 			VARCHAR(30)
			)");

		#call types
		$dbh->do("CREATE TABLE IF NOT EXISTS call_types (
			    call_type_id	 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
			    call_type 						VARCHAR(32) NOT NULL,
			    call_type_desciption			VARCHAR(32) NOT NULL);") || die("[!] Failed to create table.\n");

		$do->do("INSERT INTO call_types ( call_type ) 
				 	SELECT call_type FROM fixserv 
				 		GROUP BY call_type;
				 	JOIN call_types AS c ON fixserv.call_type = c.call_type;


					");

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

		$dbh->do("INSERT INTO serials (serial_number, model_id, customer_id, branch_id, program_id) 
					(SELECT src.serial_number, src.model_id, src.customer_id, src.branch_id, src.program_id FROM (
					  SELECT serial_id as serial_number, model_id, customer_id, b.branch_id, program_id
					  FROM fixserl AS fs
					  JOIN models AS m ON fs.model_number = m.model_number
					  JOIN customers AS c ON fs.customer_number = c.customer_number
					  JOIN branches AS b ON fs.branch_id = b.branch_number
					  JOIN programs AS pt ON fs.program_type_code = pt.program_number 
					  /*— ensure the result set is only unique serials*/
					  WHERE  fs.serial_id IS NOT NULL AND fs.serial_id != ''
					  GROUP BY fs.serial_id, fs.model_number
					) AS src
					LEFT JOIN serials AS s ON src.serial_number = s.serial_number AND src.model_id = s.model_id
					WHERE s.serial_id IS NULL);") || die("[!] Failed to insert data into table.\n");

		#* service ( call-datetime, dispatch-datetime, arrival-datetime, complete-datetime, FK_serials.serial_id, FK_techs.tech_id, FK_calltypes.calltype_id, FK_problem_codes.problem_code_id, FK_location_codes.location_code_id )
		$dbh->do("CREATE TABLE IF NOT EXISTS service (
				    service_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				    call_datetime 		DATETIME,
				    dispatched_datetime DATETIME,
				    arrival_datetime 	DATETIME,
				    completion_datetime	DATETIME NOT NULL,
				    serial_id	 		INT(10),
				    technician_id   	INT(10),
				    problem_code_id 	INT(10),
				    FOREIGN KEY (serial_id) REFERENCES serials (serial_id),
				    FOREIGN KEY (technician_id) REFERENCES technicians (technician_id),
				    FOREIGN KEY (problem_code_id) REFERENCES problem_codes (problem_code_id),
				    FOREIGN KEY (location_code_id) REFERENCES location_codes (location_code_id),
				    UNIQUE KEY (serial_id, completion_datetime) 				   			
				);") || die("Could not create services");
					
		$dbh->do("INSERT INTO service (call_datetime, dispatched_datetime, arrival_datetime, completion_datetime, serial_id, technician_id, problem_code_id)		
				SELECT src.call_datetime, src.dispatched_datetime, src.arrival_datetime, src.completion_datetime, src.serial_id , src.technician_id, src.problem_code_id 
				FROM (
					SELECT 
						CONCAT(str_to_date(call_date, '%m/%d/%y'),' ', SUBSTRING(call_time, 1, 2),':', SUBSTRING(call_time, 3, 4), ':00') AS call_datetime,
						CONCAT(str_to_date(date_dispatched, '%m/%d/%y'),' ', SUBSTRING(time_dispatched, 1, 2),':', SUBSTRING(time_dispatched, 3, 4),':00') AS dispatched_datetime,
						CONCAT(str_to_date(completion_date, '%m/%d/%y'), ' ',SUBSTRING(arrival_time, 1, 2),':',    SUBSTRING(arrival_time, 3, 4),':00') as arrival_datetime,
						CONCAT(str_to_date(completion_date, '%m/%d/%y'), ' ',SUBSTRING(call_completion_time, 1, 2), ':', SUBSTRING(completion_date, 3, 4), ':00') AS completion_datetime,
						s.serial_id as serial_id,
						t.technician_id,
						p.problem_code_id
					FROM fixserv AS fsv
						JOIN models AS m ON fsv.model_number = m.model_number 
						JOIN serials AS s ON fsv.serial_number = s.serial_number AND m.model_id = s.model_id
					    JOIN technicians AS t ON fsv.technician_id_number = t.technician_number
					    JOIN problem_codes AS p ON fsv.problem_code = p.problem_code
					GROUP BY fsv.serial_number
	            	) as src
				LEFT JOIN service AS s ON src.serial_id = s.serial_id
				WHERE s.service_id IS NULL ;") || die();


			
			# transactions ( MySQL DATETIME FIELD for datetimes )
			#* service ( call-datetime, dispatch-datetime, arrival-datetime, complete-datetime, FK_serials.serial_id, FK_techs.tech_id, FK_calltypes.calltype_id, FK_problem_codes.problem_code_id, FK_location_codes.location_code_id )
            #[ Source: FIXSERV, serials, models, techs, calltypes, problem-codes, location-codes ]
			#PrimaryKey ( service_id )
			#UniqueKey ( serial_id, comp_date, call_id )
			#* service-meters ( FK_service.service_id, FK_meter-codes.meter_code_id, meter ) [ Source: FIXMETER; Link FIXMETER TO FIXSERV based on model, serial, call_id, comp_date -- called meter_date in fixmeter ]
            #PrimaryKey ( service_id, meter_code_id )
			#             * service-parts ( FK_service.service_id, FK_parts.part_id, qty, cost, addsub ) [ Source: FIXPARLA; Link FIXPARLA TO FIXSERV based on model, serial, call_id, install_date ( to comp_date ) ]
            #            PrimaryKey ( service_id, part_id, addsub )
                           
            #           * billing-meters [ FK_serials.serial_id, bill-date, FK_meter-codes.meter_code_id, meter ]
            #          PrimaryKey ( serial_id, meter_code_id, bill_date )


#CONCAT(str_to_date(calldate, '%m/%d/%y') , " ", SUBSTRING(calltime,1,2),":",SUBSTRING(calltime,3,4),":00"),
#CONCAT(str_to_date(datedispatched, '%m/%d/%y') , " ", SUBSTRING(timedispatched,1,2),":",SUBSTRING(timedispatched,3,4),":00"),
#CONCAT(str_to_date(completedate, '%m/%d/%y') , " ", SUBSTRING(arrivaltime,1,2),":",SUBSTRING(arrivaltime,3,4),":00"),
#CONCAT(str_to_date(completedate, '%m/%d/%y') , " ", SUBSTRING(completetime,1,2),":",SUBSTRING(completetime,3,4),":00"),



# services  * service ( call-datetime, dispatch-datetime, arrival-datetime, complete-datetime, FK_serials.serial_id, FK_techs.tech_id, FK_calltypes.calltype_id, FK_problem_codes.problem_code_id, FK_location_codes.location_code_id )
 #                               [ Source: FIXSERV, serials, models, techs, calltypes, problem-codes, location-codes ]
  #                              PrimaryKey ( service_id )
   #                             UniqueKey ( serial_id, comp_date, call_id )  
        		# calltype_id                     INT(10),
           #     FOREIGN KEY ( calltype_id )     REFERENCES calltypes ( calltype_id ),
   #change naming issues with mix between number and id
   #change call_date is a combination of date and time
   #call_date 			DATETIME,
	# date_dispatched 	DATETIME,
	# arrival_time 		DATETIME,
	# completion_date 	DATETIME,
#CONCAT(str_to_date(call_date, '%m/%d/%y') , " ", SUBSTRING(call_time,1,2),":",SUBSTRING(call_time,3,4),":00")
#	CONCAT_WS(' ', DATE_FORMAT(call_date,'%Y-%m-%d'), TIME_FORMAT(CONCAT(call_time,'00'),'%T') ) AS call_date`
		
		print "[+] Schema created and loaded successfully.\n";
		
		
	}
}
 



1;