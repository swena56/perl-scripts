package BEI::InsertTempTables;

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

#models
$dbh->do("
INSERT INTO models (model_number, model_description) 
SELECT fixserl.model_number, fixserl.model_description 
FROM ( 
	SELECT fixserl.model_number, fixserl.model_description 
	FROM fixserl
	   	GROUP BY fixserl.model_number
) AS fixserl
LEFT JOIN models ON fixserl.model_number = models.model_number
WHERE models.model_id IS NULL
") || die ("[!] Failed to insert data into models table.\n");


$dbh->do("INSERT INTO branches (branch_number)
SELECT fixserl.branch_id 
FROM (SELECT fixserl.branch_id FROM fixserl
GROUP BY fixserl.branch_id) AS fixserl
LEFT JOIN branches ON fixserl.branch_id = branches.branch_id 
WHERE branches.branch_id IS NULL AND NOT EXISTS (SELECT * from branches);") || die ("[!] Failed to insert data into branches table.\n");

$dbh->do("INSERT INTO parts ( part_number, part_description )
SELECT src.part_number, src.part_description 
FROM (
  SELECT part_number, part_description 
  FROM fixparla
GROUP BY part_number
) AS src
LEFT JOIN parts ON src.part_number = parts.part_number
WHERE parts.part_id IS NULL;") 					|| die( "[!] Failed to insert data into parts table.\n");

$dbh->do("INSERT INTO technicians ( technician_number )
SELECT technician_id_number 
FROM 
(SELECT technician_id_number FROM fixserv
GROUP BY fixserv.technician_id_number) AS fixserv
LEFT JOIN technicians ON fixserv.technician_id_number = technicians.technician_number
WHERE technicians.technician_id IS NULL") 		|| die("[!] Failed to insert data into table.\n");

$dbh->do("INSERT INTO meter_codes (meter_code, meter_description)
SELECT fixmdesc.meter_code, fixmdesc.meter_code_description 
FROM (
	SELECT 
    fixmdesc.meter_code, fixmdesc.meter_code_description
FROM
    fixmdesc
GROUP BY meter_code) AS fixmdesc
    LEFT JOIN
meter_codes ON fixmdesc.meter_code = meter_codes.meter_code
WHERE
meter_codes.meter_code_id IS NULL;") || die("[!] Failed to insert data into table.\n");

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

$dbh->do("INSERT INTO problem_codes ( problem_code ) 
SELECT src.problem_code
FROM (
  SELECT problem_code
  FROM fixserv
  GROUP BY problem_code 
  ) AS src
LEFT JOIN problem_codes ON src.problem_code = problem_codes.problem_code
WHERE problem_codes.problem_code_id IS NULL;") 		|| die("[!] Failed to insert data into table.\n");

$dbh->do("INSERT INTO correction_codes ( correction_code ) 
(SELECT fixserv.correction_code FROM
(SELECT fixserv.correction_code FROM fixserv
GROUP BY fixserv.correction_code) AS fixserv
LEFT JOIN correction_codes ON fixserv.correction_code = correction_codes.correction_code
WHERE correction_codes.correction_code_id IS NULL 
AND fixserv.correction_code IS NOT NULL 
AND fixserv.correction_code != '');") || die("[!] Failed to insert data into table.\n");

$dbh->do("INSERT INTO location_codes ( location_code ) 
SELECT src.location_code
FROM (
  SELECT location_code
  FROM fixserv
  GROUP BY fixserv.location_code
  ) AS src
LEFT JOIN location_codes AS l ON src.location_code = l.location_code
WHERE l.location_code_id IS NULL;
") || die("[!] Failed to insert data into table.\n");

$dbh->do("
INSERT INTO call_types (call_type) 
SELECT src.call_type
FROM (
  SELECT  call_type
  FROM fixserv
  GROUP BY fixserv.call_type
  ) AS src
LEFT JOIN call_types AS ct ON src.call_type = ct.call_type
WHERE ct.call_type_id IS NULL;
") || die("[!] Failed to insert data into table.\n");

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
$dbh->do("
INSERT INTO service (call_datetime, dispatched_datetime, arrival_datetime, completion_datetime, serial_id, technician_id, problem_code_id, call_id_not_call_type, call_type_id)		
SELECT src.call_datetime, src.dispatched_datetime, src.arrival_datetime, src.completion_datetime, src.serial_id , src.technician_id, src.problem_code_id, src.call_id_not_call_type, src.call_type_id
FROM (
SELECT 
  CONCAT(str_to_date(fsv.call_date, '%m/%d/%y'),' ', SUBSTRING(fsv.call_time, 1, 2),':', SUBSTRING(fsv.call_time, 3, 4), ':00') AS call_datetime,
  CONCAT(str_to_date(date_dispatched, '%m/%d/%y'),' ', SUBSTRING(time_dispatched, 1, 2),':', SUBSTRING(time_dispatched, 3, 4),':00') AS dispatched_datetime,
  CONCAT(str_to_date(completion_date, '%m/%d/%y'), ' ',SUBSTRING(arrival_time, 1, 2),':',    SUBSTRING(arrival_time, 3, 4),':00') as arrival_datetime,
  CONCAT(str_to_date(fsv.completion_date, '%m/%d/%y'), ' ',SUBSTRING(fsv.call_completion_time, 1, 2), ':', SUBSTRING(fsv.completion_date, 3, 4), ':00') AS completion_datetime,
  s.serial_id,
  t.technician_id,
  p.problem_code_id,
  fsv.call_id AS call_id_not_call_type, 
  ct.call_type_id
FROM fixserv AS fsv
  JOIN models AS m ON fsv.model_number = m.model_number 
  JOIN serials AS s ON m.model_id = s.model_id AND fsv.serial_number = s.serial_number
  JOIN technicians AS t ON fsv.technician_id_number = t.technician_number
  JOIN problem_codes AS p ON fsv.problem_code = p.problem_code
  JOIN call_types AS ct ON fsv.call_type = ct.call_type
  GROUP BY s.serial_id, completion_datetime, call_id
) as src 
LEFT JOIN service AS ser ON src.serial_id = ser.serial_id
AND ser.service_id = src.call_id_not_call_type
AND ser.completion_datetime = src.completion_datetime
WHERE service_id IS NULL;
") || die();

$dbh->do("
INSERT INTO service_meters ( service_id, meter_code_id, meter )
SELECT src.service_id, 	src.meter_code_id,  src.meter_reading	
FROM (
SELECT service_id, 
  meter_codes.meter_code_id, 
  meter_reading
FROM service
JOIN serials ON service.serial_id = serials.serial_id
JOIN models ON serials.model_id = models.model_id
JOIN fixmeter ON serials.serial_number = fixmeter.serial_number 
  AND models.model_number = fixmeter.model 
  AND service.call_id_not_call_type = fixmeter.call_id AND DATE(service.completion_datetime) = str_to_date(fixmeter.completion_date, '%m/%d/%y')
JOIN meter_codes ON fixmeter.meter_code = meter_codes.meter_code
) as src
LEFT JOIN service_meters AS sm ON sm.service_id = src.service_id  AND sm.meter_code_id = src.meter_code_id 
WHERE sm.service_id IS NULL AND sm.meter_code_id IS NULL;
");

#billing_meters
$dbh->do("
INSERT INTO billing_meters  ( serial_id, bill_date, meter_code_id, meter_code ) 
SELECT src.serial_id, src.meter_code_id, src.bill_date, src.meter_code
FROM (
	SELECT service.serial_id, 
		fixbilling.billing_dl as bill_date,
	    meter_codes.meter_code_id, 
	    meter_codes.meter_code
	FROM service 
	JOIN serials   ON service.serial_id = serials.serial_id	
	JOIN fixbilling ON serials.serial_number = fixbilling.serial_numl 
	JOIN fixmeter ON serials.serial_number = fixmeter.serial_number
	JOIN meter_codes  ON fixmeter.meter_code  = meter_codes.meter_code
	GROUP BY service.serial_id
) as src
LEFT JOIN billing_meters AS bm ON bm.serial_id = src.serial_id
WHERE bm.serial_id IS NULL;
") || die("[!] Failed to insert data into table.\n");

#service_parts
$dbh->do("
INSERT INTO service_parts ( service_id, part_id, addsub, cost, quantity ) 
SELECT src.service_id, src.part_id, src.addsub, src.cost, qty
FROM (
SELECT service.service_id, 
parts.part_id, 
fixparla.add_sub_indicator AS addsub, 
SUM(fixparla.parts_cost)        AS cost,
SUM(fixparla.quantity_used)      AS qty
FROM service  
JOIN serials  ON service.serial_id          = serials.serial_id
JOIN models   ON serials.model_id           = models.model_id
JOIN fixparla ON serials.serial_number = fixparla.serial_number 
  AND models.model_number = fixparla.model_number
  AND service.call_id_not_call_type = fixparla.call_id 
  AND DATE(service.completion_datetime) = str_to_date(fixparla.installation_date, '%m/%d/%y')
JOIN parts    ON parts.part_number          = fixparla.part_number
GROUP BY service.service_id, parts.part_id, fixparla.add_sub_indicator
) AS src
LEFT JOIN service_parts AS sp ON sp.service_id = src.service_id  
AND sp.part_id = src.part_id 
AND sp.addsub = src.addsub  
WHERE sp.part_id IS NULL AND sp.service_id IS NULL AND sp.addsub IS NULL;
") || die("[!] Failed to insert data into table.\n");

		print "[+] Inserted Temp Tables into Permenant Storage.\n";		
	}
}
 
1;