/* load data */

/*  Fixserl models load data */
SELECT 
    fixserl.model_number, model_description
FROM
    (SELECT 
        fixserl.model_number, model_description
    FROM
        fixserl
    GROUP BY fixserl.model_number) AS fixserl
        LEFT JOIN
    model ON fixserl.model_number = model.model_number
WHERE
    model.id IS NULL;

/*  Fixserl branches load data*/
SELECT 
    fixserl.branch_id
FROM
    (SELECT 
        fixserl.branch_id
    FROM
        fixserl
    GROUP BY fixserl.branch_id) AS fixserl
        LEFT JOIN
    branch ON fixserl.branch_id = branch.branch_id
WHERE
    branch.id IS NULL;

/*  Fixparla parts load data */
SELECT 
    fixparla.part_number, part_description
FROM
    (SELECT 
        fixparla.part_number, part_description
    FROM
        fixparla
    GROUP BY fixparla.part_number) AS fixparla
        LEFT JOIN
    part ON fixparla.part_number = part.part_number
WHERE
    part.id IS NULL;

/* fixserv technicians - load data*/
SELECT 
    technician_id_number
FROM
    (SELECT 
        technician_id_number
    FROM
        fixserv
    GROUP BY fixserv.technician_id_number) AS fixserv
        LEFT JOIN
    technician ON fixserv.technician_id_number = technician.number
WHERE
    technician.id IS NULL;

/* meter_codes - load data from fixmdesc*/
SELECT 
    meter_code, meter_code_description
FROM
    (SELECT 
        meter_code, meter_code_description
    FROM
        fixmdesc
    GROUP BY meter_code) AS fixmdesc
        LEFT JOIN
    meter_code ON fixmdesc.meter_code = meter_code.mcode
WHERE
    meter_code.id IS NULL;


/* customers - load data from fixserl*/
SELECT 
    customer_number
FROM
    (SELECT 
        customer_number
    FROM
        fixserl
    GROUP BY fixserl.customer_number) AS fixserl
        LEFT JOIN
    customer ON fixserl.customer_number = customer.number
WHERE
    customer.id IS NULL;
	
/* program types - load data from fixserl*/
SELECT 
    program_type_code
FROM
    (SELECT 
        program_type_code
    FROM
        fixserl
    GROUP BY fixserl.program_type_code) AS fixserl
        LEFT JOIN
    program ON fixserl.program_type_code = program.program_id
WHERE
    program.id IS NULL;

 /*problem_codes - load data from fixserl*/
SELECT fixserv.problem_code
FROM (
		SELECT fixserv.problem_code
		FROM fixserv
		GROUP BY fixserv.problem_code
) AS fixserv
LEFT JOIN problem ON fixserv.problem_code = problem.problem_code
WHERE problem.id IS NULL;


/* program types - load data from fixserl*/
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
    correction_codes.id IS NULL;

/* load serial data*/
SELECT 
    serial_id
FROM
    (SELECT 
        serial_id
    FROM
        fixserl
    GROUP BY fixserl.serial_id) AS fixserl
        LEFT JOIN
    serial_number ON fixserl.serial_id = serial_number.serial_number
WHERE
    serial_number.id IS NULL;