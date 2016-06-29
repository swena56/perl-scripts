#SELECT * FROM fixserv limit 5;

#SC64445,V4499407090

SELECT call_id, serial_number, model_number, technician_number 
FROM service AS srv
JOIN serials AS s ON srv.serial_id = s.serial_id
JOIN models AS m ON s.model_id = m.model_id
JOIN technicians AS t ON srv.technician_id = t.technician_id
WHERE serial_number = 'V4499407090' AND call_id = 'SC64445';


#230
#cat5e run.
#add call_id, call_type to service is a linking field to 3 other tables

