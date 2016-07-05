 /* FIXSERL -> [ serials, models, customers, branches, program-types ] */

/*  Fixserl serials */
DROP TABLE IF EXISTS models;
CREATE TABLE IF NOT EXISTS models (
	id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,	
	number VARCHAR(32) NOT NULL UNIQUE KEY,
	FOREIGN KEY (serial)
);
