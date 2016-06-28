/*

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
					  /*— ensure the result set is only unique serials
					  GROUP BY fs.serial_id, fs.model_number
					) AS src
					LEFT JOIN serials AS s ON src.serial_number = s.serial_number AND src.model_id = s.model_id
					WHERE s.serial_id IS NULL AND NOT EXISTS(SELECT * FROM serials));") || die("[!] Failed to insert data into table.\n");
*/


CREATE TABLE IF NOT EXISTS service (
    service_id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    call_date VARCHAR(10),
    date_dispatched VARCHAR(10),
    arrival_time VARCHAR(32),
    completion_date VARCHAR(32),
    serial_number INT(10),
    technician_number INT(10),
    problem_code_id INT(10),
   FOREIGN KEY (serial_number)
        REFERENCES serials (serial_number),
    FOREIGN KEY (technician_number)
        REFERENCES technicians (technician_id),
    FOREIGN KEY (problem_code_id)
        REFERENCES problem_codes (problem_code_id),
	UNIQUE KEY (serial_number, completion_date)
);

/*


 FOREIGN KEY (serial_number)
        REFERENCES serials (serial_number),
    FOREIGN KEY (technician_number)
        REFERENCES technicians (technician_id),
    FOREIGN KEY (problem_code_id)
        REFERENCES problem_codes (problem_code_id),
UNIQUE KEY (serial_number, completion_date)

*/

#/*JOIN calltypes 	AS c ON fsv.call_type = c.calltype
#JOIN location_codes as l ON fsv.location_code = l.location_code*/

INSERT INTO service (call_date, date_dispatched, arrival_time, completion_date, serial_number, technician_number, problem_code) VALUES ('','','','','','','');

SELECT src.call_date, src.date_dispatched, src.arrival_time, src.completion_date, src.serial_number, src.technician_number, src.problem_code FROM  
		(
			SELECT call_date, date_dispatched, arrival_time, completion_date, s.serial_number, t.technician_number, p.problem_code  FROM fixserv AS fsv
					JOIN serials AS s ON fsv.serial_number = s.serial_number
					JOIN technicians AS t ON fsv.technician_id_number = t.technician_number
					JOIN problem_codes AS p ON fsv.problem_code = p.problem_code                    
					GROUP BY fsv.serial_number
		) as src ;

/*
INSERT INTO service (call_date, date_dispatched, arrival_time, completion_date, serial_number, technician_number, problem_code) 
( 
	SELECT src.call_date, src.date_dispatched, src.arrival_time, src.completion_date, src.serial_number, src.technician_number, src.problem_code FROM  
		(
			SELECT call_date, date_dispatched, arrival_time, completion_date, s.serial_number, t.technician_number, p.problem_code  FROM fixserv AS fsv
					JOIN serials AS s ON fsv.serial_number = s.serial_number
					JOIN technicians AS t ON fsv.technician_id_number = t.technician_number
					JOIN problem_codes AS p ON fsv.problem_code = p.problem_code                    
					GROUP BY fsv.serial_number
		) as src 
);

*/
/*
					LEFT JOIN service AS ser ON src.serial_number = ser.serial_number
						WHERE ser.service_id IS NULL
*/


/*
SELECT src.serial_number, src.model_id, src.customer_id, src.branch_id, src.program_id FROM (
					  SELECT serial_id as serial_number, model_id, customer_id, b.branch_id, program_id
					  FROM fixserl AS fs
					  JOIN models AS m ON fs.model_number = m.model_number
					  JOIN customers AS c ON fs.customer_number = c.customer_number
					  JOIN branches AS b ON fs.branch_id = b.branch_number
					  JOIN programs AS pt ON fs.program_type_code = pt.program_number 
					  — ensure the result set is only unique serials
					  GROUP BY fs.serial_id, fs.model_number
					) AS src;


*/
