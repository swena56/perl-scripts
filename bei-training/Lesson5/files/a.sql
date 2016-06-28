SELECT src.call_date, src.date_dispatched, src.arrival_time, src.completion_date, src.serial_number, src.technician_number, src.problem_code FROM (
			SELECT call_date, date_dispatched, arrival_time, completion_date, s.serial_number, t.technician_number, p.problem_code  FROM 
                fixserv AS fsv
                    JOIN serials AS s ON fsv.serial_number = s.serial_number
                    JOIN technicians AS t ON fsv.technician_id_number = t.technician_number
                    JOIN problem_codes AS p ON fsv.problem_code = p.problem_code                 
            GROUP BY fsv.serial_number) as src 
				  LEFT JOIN service AS s ON src.serial_number = s.serial_number;