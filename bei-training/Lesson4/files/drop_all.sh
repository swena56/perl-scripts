#!/usr/bin/bash

mysql -Nse 'show tables' bei_training | while read table; do mysql -e "drop table $table" bei_training; done
