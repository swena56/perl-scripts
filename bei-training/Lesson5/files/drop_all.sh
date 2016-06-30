#!/usr/bin/bash
#mysql -e 'source files/drop_all.sql'
mysql -Nse 'SET FOREIGN_KEY_CHECKS=0; \
		show tables' bei_training | while read table; do mysql -e "drop table $table" bei_training; done  
