DROP VIEW IF EXISTS branches_v;
CREATE VIEW branches_v AS
SELECT model_number
FROM fixserl;


DROP VIEW IF EXISTS models_v;
CREATE VIEW models_v AS
SELECT model_number
FROM fixserl;

DROP VIEW IF EXISTS parts_v;
CREATE VIEW parts_v AS
SELECT part_number, part_description
FROM fixparla;

DROP VIEW IF EXISTS techs_v;
CREATE VIEW techs_v AS
SELECT tech_number
FROM fixparla;