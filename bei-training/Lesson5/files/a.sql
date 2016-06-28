SELECT src.serial_number, src.model_id, src.customer_id, src.branch_id, src.program_id FROM (
					  SELECT serial_id as serial_number, model_id, customer_id, b.branch_id, program_id
					  FROM fixserl AS fs
					  JOIN models AS m ON fs.model_number = m.model_number
					  JOIN customers AS c ON fs.customer_number = c.customer_number
					  JOIN branches AS b ON fs.branch_id = b.branch_number
					  JOIN programs AS pt ON fs.program_type_code = pt.program_number 
					  /*— ensure the result set is only unique serials*/
					  GROUP BY fs.serial_id, fs.model_number
					) AS src;