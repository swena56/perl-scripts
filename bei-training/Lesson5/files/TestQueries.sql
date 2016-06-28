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

select * from fixserv;
select * from fixserl;
select * from fixlabor;
select * from fixbilling;


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

