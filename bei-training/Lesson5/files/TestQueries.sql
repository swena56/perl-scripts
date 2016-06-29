/*
select * from branches;			
select * from calltypes ;		#non existant data so far
select * from correction_codes;
select * from customers;
select * from meter_codes;
select * from models;
select * from problem_codes;
select * from parts;
select * from serials;
select * from service;			#date needs formatting
select * from technicians;


select * from fixserl;
select * from fixlabor;
select * from fixbilling;
*/


					SELECT 
					    call_type
					FROM
					    SELECT call_type
					    FROM fixserv
						GROUP BY fixserv.call_type
						LEFT JOIN call_types ON fixserv.call_types = call_types.call_type
					WHERE
					    call_types.call_type_id IS NULL;
#select * from fixserv;

/*
    					SELECT technician_id_number FROM fixserv
    						GROUP BY fixserv.technician_id_number;

INSERT INTO service (call_datetime, dispatched_datetime, arrival_datetime, completion_datetime, serial_id, technician_id, problem_code_id)
					SELECT src.call_datetime, src.dispatched_datetime, src.arrival_datetime, src.completion_datetime, src.serial_id , src.technician_id, src.problem_code_id 
					FROM (
						SELECT CONCAT(str_to_date(call_date, '%m/%d/%y') ,'', SUBSTRING(call_time,1,2),':',SUBSTRING(call_time,3,4),':00') AS call_datetime, 
						CONCAT(str_to_date(date_dispatched, '%m/%d/%y') , '', SUBSTRING(time_dispatched,1,2),':',SUBSTRING(time_dispatched,3,4),':00') AS dispatched_datetime,
						CONCAT(str_to_date(completion_date, '%m/%d/%y') , '', SUBSTRING(arrival_time,1,2),':',SUBSTRING(arrival_time,3,4),':00') as arrival_datetime,
						CONCAT(str_to_date(completion_date, '%m/%d/%y') , '', SUBSTRING(call_completion_time,1,2),':',SUBSTRING(completion_date,3,4),':00') AS completion_datetime,
					    s.serial_id as serial_id , t.technician_id, p.problem_code_id  
					    FROM 
		                	fixserv AS fsv  
		                    JOIN serials AS s ON fsv.serial_number = s.serial_number
		                    JOIN technicians AS t ON fsv.technician_id_number = t.technician_number
		                    JOIN problem_codes AS p ON fsv.problem_code = p.problem_code
	            		GROUP BY fsv.serial_number
	            	) as src

					LEFT JOIN service AS s ON src.serial_id = s.serial_id
					  WHERE s.service_id IS NULL ;

SELECT 
    CONCAT(str_to_date(call_date, '%m/%d/%y'),
            '',
            SUBSTRING(call_time, 1, 2),
            ':',
            SUBSTRING(call_time, 3, 4),
            ':00') AS call_datetime,
    CONCAT(str_to_date(date_dispatched, '%m/%d/%y'),
            '',
            SUBSTRING(time_dispatched, 1, 2),
            ':',
            SUBSTRING(time_dispatched, 3, 4),
            ':00') AS dispatched_datetime,
    CONCAT(str_to_date(completion_date, '%m/%d/%y'),
            '',
            SUBSTRING(arrival_time, 1, 2),
            ':',
            SUBSTRING(arrival_time, 3, 4),
            ':00') as arrival_datetime,
    CONCAT(str_to_date(completion_date, '%m/%d/%y'),
            '',
            SUBSTRING(call_completion_time, 1, 2),
            ':',
            SUBSTRING(completion_date, 3, 4),
            ':00') AS completion_datetime,
    s.serial_id as serial_id,
    t.technician_id,
    p.problem_code_id
FROM fixserv AS fsv
	JOIN 
		models AS m ON fsv.model_number = m.model_number 
		JOIN serials AS s ON fsv.serial_number = s.serial_number AND m.model_id = s.model_id
        JOIN technicians AS t ON fsv.technician_id_number = t.technician_number
        JOIN problem_codes AS p ON fsv.problem_code = p.problem_code
GROUP BY fsv.serial_number;



#problem code larger strings
#correctioncode after location code
/*

#date formating for service
SELECT src.call_date, src.date_dispatched, src.arrival_time, src.completion_date, src.serial_number , src.technician_id, src.problem_code_id FROM (
SELECT call_date, date_dispatched, arrival_time, completion_date, s.serial_id as serial_number , t.technician_id, p.problem_code_id  FROM 
	fixserv AS fsv  
	JOIN serials AS s ON fsv.serial_number = s.serial_number
	JOIN technicians AS t ON fsv.technician_id_number = t.technician_number
	JOIN problem_codes AS p ON fsv.problem_code = p.problem_code
GROUP BY fsv.serial_number) as src;


SELECT call_date, date_dispatched, arrival_time, completion_date, s.serial_id as serial_number , t.technician_id, p.problem_code_id  FROM 
	fixserv AS fsv  
	JOIN serials AS s ON fsv.serial_number = s.serial_number
	JOIN technicians AS t ON fsv.technician_id_number = t.technician_number
	JOIN problem_codes AS p ON fsv.problem_code = p.problem_code
GROUP BY fsv.serial_number;

*/