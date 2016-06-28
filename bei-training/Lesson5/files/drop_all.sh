#!/usr/bin/bash

mysql -Nse 'SET foreign_key_checks = 0; show tables' bei_training | while read table; do mysql -e "drop table $table" bei_training; done  
