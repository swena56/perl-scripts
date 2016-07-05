DROP TABLE IF EXISTS fixaddr;
CREATE TABLE IF NOT EXISTS fixaddr(
    customer_number     VARCHAR(32),
    address             VARCHAR(200),
    city                VARCHAR(200),
    state_or_province   VARCHAR(200),
    postal_code         VARCHAR(10)
);

DROP TABLE IF EXISTS fixbilling;
CREATE TABLE IF NOT EXISTS fixbilling (
	 model 				varchar(30),
	 serial_numl 		varchar(30),
	 billing_dl 		varchar(10),
	 meter_code 		varchar(20),
	 meter_readling 	INT(10)
);

DROP TABLE IF EXISTS fixcallt;
CREATE TABLE IF NOT EXISTS fixcallt (
	call_type 		VARCHAR(10),
	description 	VARCHAR(100)
);

DROP TABLE IF EXISTS fixlabor;
CREATE TABLE IF NOT EXISTS fixlabor (
	call_id				VARCHAR(15),
	model 				VARCHAR(30),
	labor_serial		VARCHAR(30),
	activity_code	 	VARCHAR(15),
	assist 				TINYINT(1), 
	labor_date 			VARCHAR(10),
	tech_number 		VARCHAR(10),
	dispatch_time 		VARCHAR(4),
	arrival_time		VARCHAR(4),
	departure_time 		VARCHAR(4),
	interrupt_hours 	VARCHAR(4),
	mileage				INT(10)
);

DROP TABLE IF EXISTS fixmdesc;
CREATE TABLE IF NOT EXISTS fixmdesc (
	meter_code 				varchar(20),
	meter_code_description 	varchar(100)
);

DROP TABLE IF EXISTS fixparla;
CREATE TABLE IF NOT EXISTS fixparla (
	call_id 			VARCHAR(15),
	model				VARCHAR(30),
	serial_number	 	VARCHAR(30),
	completion_date		VARCHAR(10),
	meter_code 			VARCHAR(20),
	meter_reading 		INT(10)
 );

DROP TABLE IF EXISTS fixploc;
CREATE TABLE IF NOT EXISTS fixploc (
	product_code 			VARCHAR(30),
	vendor_part_number 		VARCHAR(18),
	description 			VARCHAR(30),
	identifier 				CHAR(1),
	item_cost				VARCHAR(12),
	record_creation_date 	VARCHAR(10),
	total_qty 				INT(10),
	warehouse_qty			INT(10),
	warehouse_location_number VARCHAR(10),
	qty_on_hand 			INT(10)
);

DROP TABLE IF EXISTS fixserl;
CREATE TABLE IF NOT EXISTS fixserl (
	    serial_id						VARCHAR(30),
		machine_description 			VARCHAR(32),
		initial_meter_reading 			INT(10),
		date_sold_or_rented 			VARCHAR(10),
		model_number 					VARCHAR(30),
		source_code 					VARCHAR(1),
		meter_reading_on_last_service_call INT(10),
		null_placeholder 				VARCHAR(25),
		date_of_last_service_call 		VARCHAR(10),
		customer_number 				VARCHAR(32),
		program_type_code 				VARCHAR(10),
		product_category_code 			VARCHAR(6),
		sales_rep_id 					VARCHAR(6),
		connectivity_code 				VARCHAR(2),
		postal_code 					VARCHAR(10),
		sic_number 						VARCHAR(6),
		equipment_id 					VARCHAR(10),
		primary_technician_id 			VARCHAR(10),
		facility_management_equip 		VARCHAR(15),
		is_under_contract 				TINYINT(1),
		branch_id 						VARCHAR(10),
		customer_bill_to_number 		VARCHAR(32),
		customer_type 					VARCHAR(15),
		territory_field 				VARCHAR(15)
);

DROP TABLE IF EXISTS fixserv;
CREATE TABLE IF NOT EXISTS fixserv (
	null_field1					VARCHAR(10),
	call_id						VARCHAR(15),
	model_number				VARCHAR(30),
	serial_number				VARCHAR(30),
	call_date					VARCHAR(10),
	call_time 					VARCHAR(4),
	customer_time 				VARCHAR(4),
	arrival_time				VARCHAR(4),
	call_completion_time		VARCHAR(10),
	call_type 					VARCHAR(10),
	problem_code				VARCHAR(4),
	location_code				VARCHAR(4),
	reason_code 				VARCHAR(4),
	correction_code 			VARCHAR(4),
	date_dispatched 			VARCHAR(10),
	time_dispatched 			VARCHAR(4),
	completion_date 			VARCHAR(10),
	meter_reading_total 		INT(10),
	meter_reading_prior_call	INT(10),
	date_of_prior_call			VARCHAR(10),
	pc_type 					VARCHAR(4),
	lc_type 					VARCHAR(4),
	null_field2 				VARCHAR(10),
	machine_status 				VARCHAR(1),
	technician_id_number 		VARCHAR(10),
	customer_number 			VARCHAR(32),
	miles_driven				INT(10),
	response_time 				VARCHAR(4)
);

DROP TABLE IF EXISTS fixship;
CREATE TABLE IF NOT EXISTS fixship (
	labor_date 					VARCHAR(10),
	item_number				VARCHAR(18),
	item_category			CHAR(1),
	description				VARCHAR(30),
	quantity 				INT(10),
	price 					VARCHAR(12),
	customer_ship_to_number VARCHAR(32),
	customer_number 		VARCHAR(32),
	customer_bill_to_number VARCHAR()32
);

DROP TABLE IF EXISTS fixtech;
CREATE TABLE IF NOT EXISTS fixtech (
  technician_id_number		VARCHAR(10),
  branch_number				VARCHAR(4),
  model_number				VARCHAR(30)
);