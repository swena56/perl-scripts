#!/bin/bash
#drop_temp_tables.sh
mysql -e "DROP TABLE IF EXISTS  
			  fixbilling      
			, fixlabor        
			, fixmdesc        
			, fixmeter        
			, fixparla        
			, fixploc         
			, fixserl         
			, fixserv;"