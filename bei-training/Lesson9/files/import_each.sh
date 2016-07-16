#!/bin/bash
files/drop_all.sh
perl import_zip.pl files/50600316_ZIjEpwVAAm_webftp.zip  
files/drop_temp_tables.sh
perl import_zip.pl files/50600516_DLAvPgzytc_webftp.zip
files/drop_temp_tables.sh
perl import_zip.pl files/50600416_Zj6SBrvd34_webftp.zip
files/drop_temp_tables.sh