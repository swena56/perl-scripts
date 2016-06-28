
CREATE TABLE IF NOT EXISTS models (
    model_id 					INT(10) AUTO_INCREMENT PRIMARY KEY,
    model_number 				VARCHAR(32),
    model_description			VARCHAR(100)
);  

INSERT INTO models (model_number, model_description) SELECT 
    fixserl.model_number, fixserl.model_description
FROM
    (SELECT 
        fixserl.model_number, fixserl.model_description
    FROM
        fixserl
    GROUP BY fixserl.model_number) AS fixserl
        LEFT JOIN
    models ON fixserl.model_number = models.model_number
WHERE
    models.model_id IS NULL;

/*  Fixserl branches create table */
CREATE TABLE IF NOT EXISTS branches (
    branch_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    branch_number 				VARCHAR(32) NOT NULL UNIQUE KEY
);

/*  Fixserl branches load data*/
INSERT INTO branches (branch_number)
SELECT 
    fixserl.branch_id
FROM
    (SELECT 
        fixserl.branch_id
    FROM
        fixserl
    GROUP BY fixserl.branch_id) AS fixserl
        LEFT JOIN
    branches ON fixserl.branch_id = branches.branch_id
WHERE
    branches.branch_id IS NULL;

/*  Fixparla parts create table */
CREATE TABLE IF NOT EXISTS parts (
    part_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    part_number 				VARCHAR(32),
    part_description 			VARCHAR(100)
);

/*  Fixparla parts load data */
INSERT INTO parts ( part_number, part_description )
SELECT 
    fixparla.part_number, fixparla.part_description
FROM
    (SELECT 
        fixparla.part_number, fixparla.part_description
    FROM
        fixparla
    GROUP BY fixparla.part_number) AS fixparla
        LEFT JOIN
    parts ON fixparla.part_number = parts.part_number
WHERE
    parts.part_id IS NULL;


/* fixserv technicians - create table*/
CREATE TABLE IF NOT EXISTS technicians (
    technician_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    technician_number 			VARCHAR(32) NOT NULL UNIQUE KEY
);

/* fixserv technicians - load data*/
INSERT INTO technicians ( technician_number )
SELECT 
    technician_id_number
FROM
    (SELECT 
        technician_id_number
    FROM
        fixserv
    GROUP BY fixserv.technician_id_number) AS fixserv
        LEFT JOIN
    technicians ON fixserv.technician_id_number = technicians.technician_number
WHERE
    technicians.technician_id IS NULL;

/*  meter_codes - create table*/
CREATE TABLE IF NOT EXISTS meter_codes (
    meter_code_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    meter_code 					VARCHAR(32),
    meter_description			VARCHAR(32)
);

/* meter_codes - load data from fixmdesc*/
INSERT INTO meter_codes (meter_code, meter_description)
SELECT 
    fixmdesc.meter_code, fixmdesc.meter_code_description
FROM
    (SELECT 
        fixmdesc.meter_code, fixmdesc.meter_code_description
    FROM
        fixmdesc
    GROUP BY meter_code) AS fixmdesc
        LEFT JOIN
    meter_codes ON fixmdesc.meter_code = meter_codes.meter_code
WHERE
    meter_codes.meter_code_id IS NULL;


/*  customers - create table*/
CREATE TABLE IF NOT EXISTS customers (
    customer_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_number 			VARCHAR(32) NOT NULL UNIQUE KEY
);

/* customers - load data from fixserl*/
INSERT INTO customers ( customer_number )
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
    customers.customer_id IS NULL;

/* program-types create table */
CREATE TABLE IF NOT EXISTS programs (
    program_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    program_number 				VARCHAR(32) NOT NULL UNIQUE KEY
);

/* program types - load data from fixserl*/
/* note I see one program type that is empty string */
INSERT INTO programs ( program_number )
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
    programs.program_id IS NULL;

/* problem-codes load data from fixserv */
CREATE TABLE IF NOT EXISTS problem_codes (
    problem_code_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    problem_code 				VARCHAR(32),
	location_code				VARCHAR(32),
	reason_code					VARCHAR(32)
);

 /*problem_codes - load data from fixserl*/
INSERT INTO problem_codes ( problem_code, location_code, reason_code ) 
SELECT fixserv.problem_code, fixserv.location_code, fixserv.reason_code
	FROM ( SELECT 
			fixserv.problem_code, fixserv.location_code, fixserv.reason_code
		   FROM fixserv
			GROUP BY fixserv.problem_code ) AS fixserv
LEFT JOIN problem_codes ON fixserv.problem_code = problem_codes.problem_code
WHERE 
	problem_codes.problem_code_id IS NULL;

/* correction_codes create table * correction-codes ( correction-code, correction-code-desc ) [ Source: FIXSERV ] */ 
CREATE TABLE IF NOT EXISTS correction_codes (
    correction_code_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    correction_code 			VARCHAR(32) NOT NULL,
    correction_code_desc 		VARCHAR(32) NOT NULL
);

/* program types - load data from fixserl*/
INSERT INTO correction_codes ( correction_code, correction_code_desc ) 
SELECT 
    fixserv.correction_code, (SELECT "")
FROM
    (SELECT 
        fixserv.correction_code, (SELECT "")
    FROM
        fixserv
    GROUP BY fixserv.correction_code) AS fixserv
        LEFT JOIN
    correction_codes ON fixserv.correction_code = correction_codes.correction_code
WHERE
    correction_codes.correction_code_id IS NULL;


/* call types    * calltypes ( calltype, calltype-desc ) [ Source: FIXSERV ] */
CREATE TABLE IF NOT EXISTS calltypes (
    calltype_id	 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    calltype 					VARCHAR(32) NOT NULL,
    calltype_desciption			VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS serials (
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
);

INSERT INTO serials (serial_number, model_id, customer_id, branch_id, program_id) SELECT src.serial_number, src.model_id, src.customer_id, src.branch_id, src.program_id
FROM (
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
WHERE s.serial_id IS NULL;


CREATE TABLE IF NOT EXISTS services (
	service_id 						INT(10)	NOT NULL AUTO_INCREMENT PRIMARY KEY,
	call_datetime 					VARCHAR(32),
	dispatch_datetime 				VARCHAR(32),
	arrival_datetime 				VARCHAR(32),
	complete_datetime 				VARCHAR(32),
	serial_id 					  	INT(10),
	technician_id				  	INT(10),
	problem_code_id				  	INT(10),
	location_id						INT(10),
	calltype_id					  	INT(10),
	FOREIGN KEY ( calltype_id )   	REFERENCES calltypes ( calltype_id ),
	FOREIGN KEY ( serial_id ) 	  	REFERENCES serials ( serial_id ),
	FOREIGN KEY ( technician_id ) 	REFERENCES technicians ( technician_id ),	
	FOREIGN KEY ( problem_code_id )	REFERENCES problem_codes ( problem_code_id ),
	FOREIGN KEY ( location_code_id ) REFERENCES location_codes ( location_code_id ),
	UNIQUE KEY ( serial_id, complete_datetime, calltype_id )
);


#
#change fixserl table serial_id to serial_number

$dbh->do("CREATE TABLE IF NOT EXISTS services (
                service_id                      INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                call_datetime                   VARCHAR(32),
                dispatch_datetime               VARCHAR(32),
                arrival_datetime                VARCHAR(32),
                complete_datetime               VARCHAR(32),
                serial_id                       INT(10),
                technician_id                   INT(10),
                problem_code_id                 INT(10),
                location_id                     INT(10),
                calltype_id                     INT(10),
                FOREIGN KEY ( calltype_id )     REFERENCES calltypes ( calltype_id ),
                FOREIGN KEY ( serial_id )       REFERENCES serials ( serial_id ),
                FOREIGN KEY ( technician_id )   REFERENCES technicians ( technician_id ),   
                FOREIGN KEY ( problem_code_id ) REFERENCES problem_codes ( problem_code_id ),
                FOREIGN KEY ( location_code_id ) REFERENCES location_codes ( location_code_id ),
                UNIQUE KEY ( serial_id, complete_datetime, calltype_id )
            );") || or die("");