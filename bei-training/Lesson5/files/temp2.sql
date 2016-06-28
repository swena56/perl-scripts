CREATE TABLE IF NOT EXISTS models (
    model_id 					INT(10) AUTO_INCREMENT PRIMARY KEY,
    model_number 				VARCHAR(32),
    model_description			VARCHAR(100)
);  

INSERT INTO models (model_number, model_description) SELECT 
    fixserl.model_number, fixserl.model_description
FROM
    (SELECT 
        fixserl.model_number, fixserl.model_description
    FROM
        fixserl
    GROUP BY fixserl.model_number) AS fixserl
        LEFT JOIN
    models ON fixserl.model_number = models.model_number
WHERE
    models.model_id IS NULL;