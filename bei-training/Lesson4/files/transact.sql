/*
 * Review homework assignments  - Andrew Swenson

 * Perl Training:
                - Moose
 
				* Discuss The Transact portion of ELT.
 
                * FIXSERL ->  [ serials, models, customers, branches, program-types ]
                * FIXSERV ->  [ calltypes, problem-codes, correction-codes, location-codes, reason-codes, techs, service ]
                * FIXMDESC -> [ meter-codes ]
                * FIXMETER -> [ service-meters ]
                * FIXPARLA -> [ parts, service-parts ]
                * FIXBILLING -> [ billing-meters ]
 
DROP TABLE IF EXISTS model;
DROP TABLE IF EXISTS branch;
DROP TABLE IF EXISTS part;
DROP TABLE IF EXISTS technician;
DROP TABLE IF EXISTS meter_code;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS program;
DROP TABLE IF EXISTS problem;
DROP TABLE IF EXISTS correction_codes ;
DROP TABLE IF EXISTS calltypes ;
DROP TABLE IF EXISTS serial_number;

                * From those, we create entities and can build relationships based on those entities.
*/						
						/*  FIXSERL -> [ serials, models, customers, branches, program-types ]*/

/*  Fixserl models create table */
CREATE TABLE IF NOT EXISTS models (
    model_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    model_number 				VARCHAR(32),
    model_description			VARCHAR(100)
);  

INSERT INTO models SELECT 
    fixserl.model_number, model_description
FROM
    (SELECT 
        fixserl.model_number, model_description
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
INSERT INTO branches
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
    part_number 				VARCHAR(32) NOT NULL UNIQUE KEY,
    part_description 			VARCHAR(100) NOT NULL UNIQUE KEY
);

/*  Fixparla parts load data */
INSERT INTO parts
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
INSERT INTO technicians
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
    meter_code 					VARCHAR(32) NOT NULL UNIQUE KEY,
    meter_description			VARCHAR(32) NOT NULL UNIQUE KEY
);

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

/*  customers - create table*/
CREATE TABLE IF NOT EXISTS customers (
    customer_id 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_number 			VARCHAR(32) NOT NULL UNIQUE KEY
);

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

/* program-types create table */
CREATE TABLE IF NOT EXISTS programs (
    program_id 					INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    program_number 				VARCHAR(32) NOT NULL UNIQUE KEY
);

/* program types - load data from fixserl*/
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

/* problem-codes load data from fixserv */
CREATE TABLE IF NOT EXISTS problem_codes (
    problem_code_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    problem_code 				VARCHAR(32) NOT NULL UNIQUE KEY,
    problem_description 		VARCHAR(32) NOT NULL UNIQUE KEY
);

 /*problem_codes - load data from fixserl*/
INSERT IGNORE INTO problem_codes ( problem_code, problem_description ) 
SELECT fixserv.problem_code
FROM (
		SELECT fixserv.problem_code
		FROM fixserv
		GROUP BY fixserv.problem_code
) AS fixserv
LEFT JOIN problem_codes ON fixserv.problem_code = problem_codes.problem_code
WHERE problem_codes.problem_code_id IS NULL;

/* correction_codes create table * correction-codes ( correction-code, correction-code-desc ) [ Source: FIXSERV ] */ 
CREATE TABLE IF NOT EXISTS correction_codes (
    correction_code_id 			INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    correction_code 			VARCHAR(32) NOT NULL UNIQUE KEY,
    correction_code_desc 		VARCHAR(32) NOT NULL UNIQUE KEY
);

/* program types - load data from fixserl*/
INSERT IGNORE INTO correction_codes ( correction_code, correction_code_desc ) 
SELECT 
    fixserv.correction_code
FROM
    (SELECT 
        fixserv.correction_code
    FROM
        fixserv
    GROUP BY fixserv.correction_code) AS fixserv
        LEFT JOIN
    correction_codes ON fixserv.correction_code = correction_codes.correction_code
WHERE
    correction_codes.correction_code_id IS NULL;


/* call types    * calltypes ( calltype, calltype-desc ) [ Source: FIXSERV ]
CREATE TABLE IF NOT EXISTS calltypes (
    calltype_id	 				INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    calltype 					VARCHAR(32) NOT NULL UNIQUE KEY,
    calltype_desciption			VARCHAR(32) NOT NULL UNIQUE KEY
);

/* load serial data*/
/*
SELECT 
    fixcallt.calltype
FROM
    (SELECT 
        fixcallt.calltype
    FROM
        fixcallt
    GROUP BY  fixcallt.calltype) AS fixcallt
        LEFT JOIN
    calltypes ON fixcallt.call_type = calltypes.calltype
WHERE
    calltypes.calltype_id IS NULL;


/*  Fixserl serials  * serials ( serial-number, FK_models.model_id, FK_customers.customer_id, FK_branches.branch_id, FK_program-types.program_type_id ) [ Source: FIXSERL ] */
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

/* load serial data*/
INSERT IGNORE INTO serials ( serial_number )
SELECT 
    fixserl.serial_id
FROM
    (SELECT 
        fixserl.serial_id
    FROM
        fixserl
    GROUP BY fixserl.serial_id) AS fixserl
        LEFT JOIN
    serials ON fixserl.serial_id = serials.serial_number
WHERE
    serials.serial_id IS NULL;

/* services  * service ( call-datetime, dispatch-datetime, arrival-datetime, complete-datetime, FK_serials.serial_id, FK_techs.tech_id, FK_calltypes.calltype_id, FK_problem_codes.problem_code_id, FK_location_codes.location_code_id )
                                [ Source: FIXSERV, serials, models, techs, calltypes, problem-codes, location-codes ]
                                PrimaryKey ( service_id )
                                UniqueKey ( serial_id, comp_date, call_id )  */
CREATE TABLE IF NOT EXISTS services (
	service_id 						INT(10)	NOT NULL AUTO_INCREMENT PRIMARY KEY,
	call_datetime 					VARCHAR(32) NOT NULL,
	dispatch_datetime 				varchar(32) NOT NULL,
	arrival_datetime 				varchar(32) NOT NULL,
	complete_datetime 				varchar(32) NOT NULL,
	serial_id 					  	INT(10),
	technician_id				  	INT (10),
	calltype_id					  	INT(10),
	problem_code_id				  	INT(10),
	location_id						INT(10),
	FOREIGN KEY ( serial_id ) 	  	REFERENCES serials ( serial_id ),
	FOREIGN KEY ( technician_id ) 	REFERENCES technicians ( technician_id ),
	FOREIGN KEY ( calltype_id )   	REFERENCES calltypes ( calltype_id ),
	FOREIGN KEY ( problem_code_id )	REFERENCES problem_codes ( problem_code_id ),
	/*FOREIGN KEY ( location_code_id ) REFERENCES location_codes ( location_code_id ),*/
	UNIQUE KEY ( serial_id, complete_datetime, calltype_id )
);

/* service-meters ( FK_service.service_id, FK_meter-codes.meter_code_id, meter ) [ Source: FIXMETER; Link FIXMETER TO FIXSERV based on model, serial, call_id, comp_date -- called meter_date in fixmeter ]
                                PrimaryKey ( service_id, meter_code_id ) // See Example Below
*/

CREATE TABLE IF NOT EXISTS service_meters (
	service_id 						INT(10),
	meter_code_id 					INT(10),
	meter_code						VARCHAR(32),
	FOREIGN KEY ( service_id )		REFERENCES services ( service_id ),
	FOREIGN KEY ( meter_code_id ) 	REFERENCES meter_codes ( meter_code_id ),
	FOREIGN KEY ( meter_code ) 		REFERENCES meter_codes ( meter_code ),
	PRIMARY KEY ( service_id, meter_code_id )
);


/* service parts  * service-parts ( FK_service.service_id, FK_parts.part_id, qty, cost, addsub ) [ Source: FIXPARLA; Link FIXPARLA TO FIXSERV based on model, serial, call_id, install_date ( to comp_date ) ]
                                PrimaryKey ( service_id, part_id, addsub )
*/
DROP TABLE IF EXISTS service_parts;
CREATE TABLE IF NOT EXISTS service_parts (
	service_part_id			    VARCHAR(32),
	service_id 					INT(10),
	part_id 					INT(32),
	qty 						INT(11),
	cost 						NUMERIC(15,4),
	add_sub_indicator			CHAR(1),
	FOREIGN KEY ( service_id )	REFERENCES services ( service_id ),
	FOREIGN KEY ( part_id ) 	REFERENCES parts ( part_id ),
	PRIMARY KEY service_part_id ( service_id, part_id, add_sub_indicator)
);


/* load service parts data*/
/*
INSERT IGNORE INTO service_parts ( serial_number )
SELECT 
    fixserl.serial_id
FROM
    (SELECT 
        fixserl.serial_id
    FROM
        fixserl
    GROUP BY fixserl.serial_id) AS fixserl
        LEFT JOIN
    serials ON fixserl.serial_id = serials.serial_number
WHERE
    serials.serial_id IS NULL;

/* billing    * billing-meters [ FK_serials.serial_id, bill-date, FK_meter-codes.meter_code_id, meter ]
                                PrimaryKey ( serial_id, meter_code_id, bill_date )*/
CREATE TABLE IF NOT EXISTS billing_meters (
	billing_id 						VARCHAR(32),
	serial_id 						INT(10),
	bill_date 						VARCHAR(10),
	meter_code_id 					INT(10),
	FOREIGN KEY ( serial_id )		REFERENCES serials ( serial_id ),
	FOREIGN KEY ( meter_code_id ) 	REFERENCES meter_codes ( meter_code_id ),
	PRIMARY KEY billing_id ( serial_id, bill_date, meter_code_id )
);

                                /* is it possible that my fixserv   database will have multiple customers in it.

 I only ask because technicians that work for a specific customer could have the same technician_id as one from another customer.  

I might be over thinking that one.


 DATE_FORMAT(date_added, '%e %b, %Y') AS date_added_formatted 

/*  * service ( call-datetime, dispatch-datetime, arrival-datetime, complete-datetime, FK_serials.serial_id, FK_techs.tech_id, FK_calltypes.calltype_id, FK_problem_codes.problem_code_id, FK_location_codes.location_code_id )
                                [ Source: FIXSERV, serials, models, techs, calltypes, problem-codes, location-codes ]
                                PrimaryKey ( service_id )
                                UniqueKey ( serial_id, comp_date, call_id )

								/* branches ( branch ) [ Source: FIXSERL ] 
								parts ( part-number, part-description ) [ Source: FIXPARLA ]
                                * techs ( tech-number ) [ Source: FIXSERV ]
                                * meter-codes ( meter-code, meter-code-description ) [ Source: FIXMETER ]
                                * customers ( customer-number ) [ Source: FIXSERV ]
                                * program-types ( program-type ) [ Source: FIXSERV ]
                                * problem-codes ( problem-code, problem-code-desc ) [ Source: FIXSERV ]
                                * correction-codes ( correction-code, correction-code-desc ) [ Source: FIXSERV ]
                                * location-codes ( location-code, location-code-desc ) [ Source: FIXSERV ]
                                * reason-codes ( reason-code, reason-code-desc ) [ Source: FIXSERV ]
                                * calltypes ( calltype, calltype-desc ) [ Source: FIXSERV ]
                               
                                * serials ( serial-number, FK_models.model_id, FK_customers.customer_id, FK_branches.branch_id, FK_program-types.program_type_id ) [ Source: FIXSERL ]
                                                               
                                // transactions ( MySQL DATETIME FIELD for datetimes )
                                * service ( call-datetime, dispatch-datetime, arrival-datetime, complete-datetime, FK_serials.serial_id, FK_techs.tech_id, FK_calltypes.calltype_id, FK_problem_codes.problem_code_id, FK_location_codes.location_code_id )
                                [ Source: FIXSERV, serials, models, techs, calltypes, problem-codes, location-codes ]
                                PrimaryKey ( service_id )
                                UniqueKey ( serial_id, comp_date, call_id )
                               
                                * service-meters ( FK_service.service_id, FK_meter-codes.meter_code_id, meter ) [ Source: FIXMETER; Link FIXMETER TO FIXSERV based on model, serial, call_id, comp_date -- called meter_date in fixmeter ]
                                PrimaryKey ( service_id, meter_code_id ) // See Example Below
                               
                                * service-parts ( FK_service.service_id, FK_parts.part_id, qty, cost, addsub ) [ Source: FIXPARLA; Link FIXPARLA TO FIXSERV based on model, serial, call_id, install_date ( to comp_date ) ]
                                PrimaryKey ( service_id, part_id, addsub )
                               
                                * billing-meters [ FK_serials.serial_id, bill-date, FK_meter-codes.meter_code_id, meter ]
                                PrimaryKey ( serial_id, meter_code_id, bill_date )
                               
                                 // MySQL, how do we handle duplicates
                                // Also consider, clearing out transactions upon reloading of data...
                                // Consider reloading data
                               
                                 Example ( Populate Models Base Table -- Not Tested! ): 
                                -- create table syntax

								DROP TABLE models;
								CREATE TABLE models (
									model_id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
									model_number VARCHAR(32) NOT NULL UNIQUE KEY,
									model_description VARCHAR(100) NOT NULL UNIQUE KEY
								);

                                CREATE TABLE models (
                                                model_id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                                model_number VARCHAR(32) NOT NULL UNIQUE KEY
                                );
                               
                                -- populate only *new* records
                                INSERT INTO models ( model_number, model_description )
                               
                                SELECT model_number, model_description
                                FROM (
                                                SELECT model_number, model_description
                                                FROM fixserl
                                                GROUP BY model_number
                                ) AS src
                                LEFT JOIN models ON src.model_number = models.model_number
                                WHERE models.model_id IS NULL;
                               
                               
                                 Example ( Populate Service-Meters ): 
                                Assuming that you have created the above base tables ( branches, models, parts, etc. ), and you have created the above transactional tables ( service, service-meter, etc. ), populate base tables first ( order matters ), then
                                  populate transactional tables ( order matters again ).
                                 
                                In order to bring in the appropriate foreign keys into the transactions, you will need perform joins...
                               
                                // How are we going populate the service-meters table? //
                               
                                -- INSERT INTO service_meters ( service_id, serial_id, meter_code_id, meter_date, meter )
                               
                                SELECT service.service_id, serials.serial_id, meter_codes.meter_code_id, fixmeter.completion_date, fixmeter.meter
                                FROM service
                                JOIN serials ON service.serial_id = serials.serial_id
                                JOIN models ON serials.model_id = models.model_id
                                JOIN fixmeter ON serials.serial_number = fixmeter.serial_number AND models.model_number = fixmeter.model_number AND service.call_id = fixmeter.call_id AND DATE(service.complete_date) = fixmeter.completion_date
                                JOIN meter_codes ON fixmeter.meter_code = meter_codes.meter_code
                                WHERE fixmeter.serial = 'SN1235';
                               
                              DeNormalized Data / RAW INPUT DATA 
                               
                                Fixmeter-Sample:
                                CALLID  | MODEL | SERIAL | COMP-DATE  | METER-CODE | METER
                                ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                0000001 | AF200 | SN1235 | 2015-01-31 | BW         | 11000
                                0000001 | AF200 | SN1235 | 2015-01-31 | COL        | 30000
                               
                                Fixserv-Sample:
                               
                                CALLID  | MODEL | SERIAL | COMP-DATE  | TECH    | CALLTYPE | COMP-TIME
                                ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                0000001 | AF200 | SN1235 | 2015-01-31 | TECH123 | EM       | 13:55
                               
                                Fixserl-Sample:
                                MODEL | SERIAL
                                ++++++++++++++++
                                AF200 | SN1235
                               
                                 3NF Normalized Data in Base and Transactional Tables 
                               
                                Base-Models:
                                MODEL-ID | MODEL
                                ++++++++++++++++
                                10001    | AF200
                               
                                Base-Serials:
                                SERIAL-ID | SERIAL | FK-MODEL-ID
                                ++++++++++++++++++++++++++++++++
                                20002     | SN1235 | 10001
                               
                                Base-Meter-Codes:
                                METER-CODE-ID | METER-CODE
                                ++++++++++++++++++++++++++
                                30003                      | BW
                                30005                      | COL
                               
                                Transactional-Service
                                SERVICE-ID | SERIAL-ID | COMPLETION-DATE  | CALLID  | TECH-ID | CALLTYPE-ID
                                +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                500005     | 20002     | 2015-01-31 13:55 | 0000001 | 5001    | 5
                               
                               
                                Expected Query Result:
                                SERVICE-ID | SERIAL-ID | METER-CODE-ID | METER-DATE | METER
                                +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                500005     | 20002     | 30003         | 2015-01-31 | 11000
                                500005     | 20002     | 30005         | 2015-01-31 | 30000
                               
                               
                               
* Homework:
* Refactor existing classes into moose classes for FIX files [ serl, serv, parla, meter, billing ], use a FactoryPattern to return the proper class to preform the operation
* Create perm. storage schema for [ techs, calltypes, models, customers, program-types, meters, serials ]
* Create Moose Classes to handle base and transactional queries into perm. storage.  Make sure to handle duplicates accordingly.
*/

