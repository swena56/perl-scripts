/*
* service ( call-datetime, dispatch-datetime, arrival-datetime, complete-datetime, FK_serials.serial_id, FK_techs.tech_id, FK_calltypes.calltype_id, FK_problem_codes.problem_code_id, FK_location_codes.location_code_id )
[ Source: FIXSERV, serials, models, techs, calltypes, problem-codes, location-codes ]
PrimaryKey ( service_id )
UniqueKey ( serial_id, comp_date, call_id )

* service-meters ( FK_service.service_id, FK_meter-codes.meter_code_id, meter ) [ Source: FIXMETER; Link FIXMETER TO FIXSERV based on model, serial, call_id, comp_date -- called meter_date in fixmeter ]
PrimaryKey ( service_id, meter_code_id )
* service-parts ( FK_service.service_id, FK_parts.part_id, qty, cost, addsub ) [ Source: FIXPARLA; Link FIXPARLA TO FIXSERV based on model, serial, call_id, install_date ( to comp_date ) ]
PrimaryKey ( service_id, part_id, addsub )

* billing-meters [ FK_serials.serial_id, bill-date, FK_meter-codes.meter_code_id, meter ]
PrimaryKey ( serial_id, meter_code_id, bill_date )

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

*/

/* * service-meters ( FK_service.service_id, FK_meter-codes.meter_code_id, meter ) 
[ Source: FIXMETER; Link FIXMETER TO FIXSERV based on model, serial, call_id, comp_date -- called meter_date in fixmeter ]*/

#DESCRIBE service_meters;

INSERT INTO serials (serial_number, model_id, customer_id, branch_id, program_id) 
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
					WHERE s.serial_id IS NULL);
/* * service-meters ( FK_service.service_id, FK_meter-codes.meter_code_id, meter ) 
[ Source: FIXMETER; Link FIXMETER TO FIXSERV based on model, serial, call_id, comp_date -- called meter_date in fixmeter ]*/

CREATE TABLE IF NOT EXISTS service_meters (
	meter_code_id 	 INT(10) NOT NULL,
	service_id  	INT(10) NOT NULL,
	FOREIGN KEY ( service_id )  REFERENCES service ( service_id ),
	FOREIGN KEY ( meter_code_id ) REFERENCES meter_codes ( meter_code_id ),
	PRIMARY KEY service_meter_id (service_id, meter_code_id )
);




#LEFT JOIN service_meters AS sm ON src.service_meter_id = sm.service_meter_id
#WHERE sm.service_meter_id IS NULL;
#JOIN service AS ser ON fm.serial_id =  ser.serial_id;
#INSERT INTO service_meters ( meter_code_id, service_id );
/*
SELECT meter_code_id, service_id 
FROM ( 
	SELECT  *
	
	FROM fixserv AS fsv
	JOIN models AS m ON fsv.model_id = m.model_id
	JOIN service AS ser ON 
	
) AS src;
*/
How am I suppose to get fixmeter linked to fixserv.  Why would I link them in the first place, arnt these suppose to be tempary tables.

SELECT *
FROM fixmeter AS fm
JOIN fixserv AS fs ON fs.model_number = fm.model AND
fs.call_id = fm.call_id AND
fs.serial_number = fm.serial_number AND
fs.completion_date = fm.completion_date
GROUP BY fs.model_number, fs.call_id, fs.serial_number, fs.completion_date;

fm.meter_code

SELECT *
FROM fixmeter AS fm
JOIN models AS m ON fm.model = m.model_number
JOIN serials AS s ON fm.serial_number = s.serial_id
GROUP BY m.model_number;

SELECT fm.meter_code
FROM fixmeter AS fm
JOIN models AS m ON fm.model = m.model_number
JOIN serials AS s ON fm.serial_number = s.serial_id
GROUP BY  fm.meter_code, m.model_number;
# link by call_id why I already have the call_id
#JOIN service AS ser ON s.serial_id = ser.serial_id


GROUP BY fs.model_number, fs.call_id, fs.serial_number, fs.completion_date;


#fixserv and fixmeter FIXMETER TO FIXSERV based on model, serial, call_id, comp_date -- called meter_date in fixmeter ]
INSERT INTO service_meters ( meter_code_id,service_id ) 
SELECT src.meter_code
FROM (
	SELECT *
	FROM fixmeter AS fm
	JOIN fixserv AS fs ON fs.model_number = fm.model AND
	fs.call_id = fm.call_id AND
	fs.serial_number = fm.serial_number AND
	fs.completion_date = fm.completion_date
	GROUP BY fs.model_number, fs.call_id, fs.serial_number, fs.completion_date
	) as src
     LEFT JOIN fixserl ON fixserv.call_type = call_types.call_type
WHERE call_types.call_type IS NULL 
  AND fixserv.call_type IS NOT NULL 
  AND fixserv.call_type != ''

/*
SELECT * 
FROM (
	SELECT meter_code_id FROM fixmeter

) 

DESCRIBE service_parts;
DESCRIBE billing_meters;

SELECT * FROM meter_codes;
SELECT * FROM fixmeter;
SELECT * FROM fixserv;
*/

/* service-parts ( FK_service.service_id, FK_parts.part_id, qty, cost, addsub ) 
[ Source: FIXPARLA; Link FIXPARLA TO FIXSERV based on model, serial, call_id, install_date ( to comp_date ) ]*/
CREATE TABLE IF NOT EXISTS service_parts (
	part_id  INT(10) NOT NULL,
	service_id  INT(10) NOT NULL,
	addsub	INT(10) NOT NULL,	
	cost	INT(10),
	FOREIGN KEY ( part_id )  REFERENCES parts ( part_id ),
	FOREIGN KEY ( service_id )  REFERENCES service ( service_id ),
	PRIMARY KEY service_parts_id ( service_id, part_id, addsub )
);

SELECT 
FROM fixparla 
JOIN services ON 

/* billing-meters [ FK_serials.serial_id, bill-date, FK_meter-codes.meter_code_id, meter ]
PrimaryKey ( serial_id, meter_code_id, bill_date )*/

CREATE TABLE IF NOT EXISTS billing_meters (
	serial_id		INT(10) NOT NULL,
	meter_code_id 	INT(10) NOT NULL,
	bill_date		DATETIME NOT NULL,
	FOREIGN KEY ( serial_id ) REFERENCES serials ( serial_id ),
	FOREIGN KEY ( meter_code_id ) REFERENCES meter_codes ( meter_code_id ),
	PRIMARY KEY billing_meter_id ( serial_id, meter_code_id, bill_date )
);



