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
    models ON fixserl.model_number = models.model_number
WHERE
    models.model_id IS NULL;

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
    branches ON fixserl.branch_id = branches.branch_id
WHERE
    branches.branch_id IS NULL;

/*  Fixparla parts load data */
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
SELECT fixserv.problem_code
FROM (
		SELECT fixserv.problem_code
		FROM fixserv
		GROUP BY fixserv.problem_code
) AS fixserv
LEFT JOIN problem_codes ON fixserv.problem_code = problem_codes.problem_code
WHERE problem_codes.problem_code_id IS NULL;


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
    correction_codes.correction_code_id IS NULL;

/* load serial data*/
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