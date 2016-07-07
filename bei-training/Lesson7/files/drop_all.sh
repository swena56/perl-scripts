#!/bin/bash
#mysql -e 'source files/drop_all.sql'

#mysql -Nse 'SET FOREIGN_KEY_CHECKS=0; \
#		show tables' bei_training | while #read table; do mysql -e "drop table $table" #bei_training; done  

mysql -e "DROP TABLE IF EXISTS  
			  fixbilling      
			, fixlabor        
			, fixmdesc        
			, fixmeter        
			, fixparla        
			, fixploc         
			, fixserl         
			, fixserv;"
mysql -e "DROP TABLE IF EXISTS 
			  service_parts   
			, service_meters
			, service    
			, billing_meters
			, technicians 
			, problem_codes 
			, correction_codes
			, serials         
			, models  
			, parts           
			, location_codes  
			, call_types         
			, branches      
			, customers       
			, meter_codes     
			, programs        
			;"

mysql -e "show tables;"
echo "[+] bei_training database is now empty.";


<<COMMENT1
mysql -e "TRUNCATE fixbilling";      
			mysql -e "TRUNCATE  fixlabor ";       
			 mysql -e "TRUNCATE fixmdesc   ";     
			 mysql -e "TRUNCATE fixmeter     ";   
mysql -e "TRUNCATE 			 fixparla       "; 
mysql -e "TRUNCATE 			 fixploc         ";
			 mysql -e "TRUNCATE fixserl         ";
			 mysql -e "TRUNCATE fixserv;"
mysql -e "TRUNCATE  service_parts   ";
			 mysql -e "TRUNCATE service_meters";
			 mysql -e "TRUNCATE service    ";
			 mysql -e "TRUNCATE billing_meters";
			 mysql -e "TRUNCATE technicians ";
			 mysql -e "TRUNCATE problem_codes ";
			 mysql -e "TRUNCATE correction_codes";
			 mysql -e "TRUNCATE serials         ";
			 mysql -e "TRUNCATE models  ";
			 mysql -e "TRUNCATE parts     ";      
			 mysql -e "TRUNCATE location_codes "; 
			 mysql -e "TRUNCATE call_types       ";  
			 mysql -e "TRUNCATE branches      ";
			 mysql -e "TRUNCATE customers       ";
			 mysql -e "TRUNCATE meter_codes     ";
			 mysql -e "TRUNCATE programs        ";
			mysql -e "TRUNCATE ;"
COMMENT1