/*  transaction list - do them one at a time so i can see my errors*/

/*  Fixserl models create table */
CREATE TABLE IF NOT EXISTS models (
    model_id 					INT(10) AUTO_INCREMENT PRIMARY KEY,
    model_number 				VARCHAR(32),
    model_description			VARCHAR(100)
);  

/*  Fixserl branches create table */
CREATE TABLE IF NOT EXISTS branches (
    branch_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    branch_number 				VARCHAR(32) NOT NULL UNIQUE KEY
);

/*  Fixparla parts create table */
CREATE TABLE IF NOT EXISTS parts (
    part_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    part_number 				VARCHAR(32),
    part_description 			VARCHAR(100)
);

/* fixserv technicians - create table*/
CREATE TABLE IF NOT EXISTS technicians (
    technician_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    technician_number 			VARCHAR(32) NOT NULL UNIQUE KEY
);

/*  meter_codes - create table*/
CREATE TABLE IF NOT EXISTS meter_codes (
    meter_code_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    meter_code 					VARCHAR(32),
    meter_description			VARCHAR(32)
);

/*  customers - create table*/
CREATE TABLE IF NOT EXISTS customers (
    customer_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_number 			VARCHAR(32) NOT NULL UNIQUE KEY
);

/* program-types create table */
CREATE TABLE IF NOT EXISTS programs (
    program_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    program_number 				VARCHAR(32) NOT NULL UNIQUE KEY
);

/* problem-codes load data from fixserv */
CREATE TABLE IF NOT EXISTS problem_codes (
    problem_code_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    problem_code 				VARCHAR(32),
	location_code				VARCHAR(32),
	reason_code					VARCHAR(32)
);

/* correction_codes create table * correction-codes ( correction-code, correction-code-desc ) [ Source: FIXSERV ] */ 
DROP TABLE IF EXISTS correction_codes;
CREATE TABLE IF NOT EXISTS correction_codes (
    correction_code_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    correction_code 			VARCHAR(32) NOT NULL,
    correction_code_desc 		VARCHAR(32) NOT NULL
);

/* call types    * calltypes ( calltype, calltype-desc ) [ Source: FIXSERV ] */
DROP TABLE IF EXISTS calltypes;
CREATE TABLE IF NOT EXISTS calltypes (
    calltype_id	 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    calltype 					VARCHAR(32) NOT NULL,
    calltype_desciption			VARCHAR(32) NOT NULL
);

/*  Fixserl serials  * serials ( serial-number, FK_models.model_id, FK_customers.customer_id, FK_branches.branch_id, FK_program-types.program_type_id ) [ Source: FIXSERL ] */
/* have issue with foreign keys not showing up */
DROP TABLE IF EXISTS serials;
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

INSERT IGNORE INTO models (model_number, model_description) SELECT 
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


/*  Fixserl branches load data*/
INSERT IGNORE INTO branches (branch_number)
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

/*  Fixparla parts load data */
INSERT IGNORE INTO parts ( part_number, part_description )
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

/* fixserv technicians - load data*/
INSERT IGNORE INTO technicians ( technician_number )
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

/* meter_codes - load data from fixmdesc*/
INSERT IGNORE INTO meter_codes (meter_code, meter_description)
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

/* customers - load data from fixserl*/
INSERT IGNORE INTO customers ( customer_number )
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


/* program types - load data from fixserl*/
/* note I see one program type that is empty string */
INSERT IGNORE INTO programs ( program_number )
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

 /*problem_codes - load data from fixserl*/
INSERT IGNORE INTO problem_codes ( problem_code, location_code, reason_code ) 
SELECT fixserv.problem_code, fixserv.location_code, fixserv.reason_code
	FROM ( SELECT 
			fixserv.problem_code, fixserv.location_code, fixserv.reason_code
		   FROM fixserv
			GROUP BY fixserv.problem_code ) AS fixserv
LEFT JOIN problem_codes ON fixserv.problem_code = problem_codes.problem_code
WHERE 
	problem_codes.problem_code_id IS NULL;

/* program types - load data from fixserl*/
INSERT IGNORE INTO correction_codes ( correction_code, correction_code_desc ) 
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