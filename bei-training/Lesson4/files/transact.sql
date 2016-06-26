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
 
                * From those, we create entities and can build relationships based on those entities.
*/						
						/*  FIXSERL -> [ serials, models, customers, branches, program-types ]*/

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



/*  Fixserl models create table */
CREATE TABLE IF NOT EXISTS model (
    id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    model_number VARCHAR(32) NOT NULL UNIQUE KEY,
    model_desc VARCHAR(100) NOT NULL UNIQUE KEY
);

/*  Fixserl branches create table */
CREATE TABLE IF NOT EXISTS branch (
    id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    branch_id VARCHAR(32) NOT NULL UNIQUE KEY
);
		
/*  Fixparla parts create table */
CREATE TABLE IF NOT EXISTS part (
    id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    part_number VARCHAR(32) NOT NULL UNIQUE KEY,
    description VARCHAR(100) NOT NULL UNIQUE KEY
);

/* fixserv technicians - create table*/
CREATE TABLE IF NOT EXISTS technician (
    id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    number VARCHAR(32) NOT NULL UNIQUE KEY
);
									
/*  meter_codes - create table*/
CREATE TABLE IF NOT EXISTS meter_code (
    id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    mcode VARCHAR(32) NOT NULL UNIQUE KEY,
    meter_desc VARCHAR(32) NOT NULL UNIQUE KEY
);

/*  customers - create table*/
CREATE TABLE IF NOT EXISTS customer (
    id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    number VARCHAR(32) NOT NULL UNIQUE KEY
);

/* program-types create table */
CREATE TABLE IF NOT EXISTS program (
    id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    program_id VARCHAR(32) NOT NULL UNIQUE KEY
);

/* problem-codes load data from fixserv */
CREATE TABLE IF NOT EXISTS problem (
    id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    problem_code VARCHAR(32) NOT NULL UNIQUE KEY,
    problem_description VARCHAR(32) NOT NULL UNIQUE KEY
);

/* correction_codes create table * correction-codes ( correction-code, correction-code-desc ) [ Source: FIXSERV ] */ 
CREATE TABLE IF NOT EXISTS correction_codes (
    id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    correction_code VARCHAR(32) NOT NULL UNIQUE KEY,
    correction_code_desc VARCHAR(32) NOT NULL UNIQUE KEY
);

/* call types    * calltypes ( calltype, calltype-desc ) [ Source: FIXSERV ]*/
CREATE TABLE IF NOT EXISTS correction_codes (
    id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    calltype VARCHAR(32) NOT NULL UNIQUE KEY,
    calltype_desc VARCHAR(32) NOT NULL UNIQUE KEY
);

/*  Fixserl serials */
CREATE TABLE IF NOT EXISTS serials (
    id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    serial_number VARCHAR(32) NOT NULL UNIQUE KEY,
	model_id INT ,
	customer_id INT,
	branch_id INT,
	program_id INT,
	FOREIGN KEY (model_id) REFERENCES model(id),
	FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (branch_id) REFERENCES branch(id),
    FOREIGN KEY (program_id) REFERENCES program(id)
);




/*  * service ( call-datetime, dispatch-datetime, arrival-datetime, complete-datetime, FK_serials.serial_id, FK_techs.tech_id, FK_calltypes.calltype_id, FK_problem_codes.problem_code_id, FK_location_codes.location_code_id )
                                [ Source: FIXSERV, serials, models, techs, calltypes, problem-codes, location-codes ]
                                PrimaryKey ( service_id )
                                UniqueKey ( serial_id, comp_date, call_id )

CREATE TABLE IF NOT EXISTS service(
	service_id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	call_datetime varchar(32) NOT NULL UNIQUE KEY,
	dispatch_datetime varchar(32) NOT NULL UNIQUE KEY,
	arrival_datetime varchar(32) NOT NULL UNIQUE KEY,
	complete_datetime varchar(32) NOT NULL UNIQUE KEY,
	serials 
);

*/





                                /* is it possible that my fixserv   database will have multiple customers in it.

 I only ask because technicians that work for a specific customer could have the same technician_id as one from another customer.  

I might be over thinking that one.

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

