#!/bin/bash
TEMP_DIR='/tmp/bei-tmp/'
unzip files/50600316_ZIjEpwVAAm_webftp.zip -d $TEMP_DIR
unzip files/50600416_Zj6SBrvd34_webftp.zip -d $TEMP_DIR
unzip files/50600516_DLAvPgzytc_webftp.zip -d $TEMP_DIR

ls $TEMP_DIR

#----------------------------
cd $TEMP_DIR
myFileNames="$( ls -d -1 $PWD/{*,.*}   )";

for file in $myFileNames; do
NUMOFLINES=$(wc -l $file);
echo "Line count: $NUMOFLINES";
echo "First line: $(head -n 1 $file)";
echo;
done


rm "$TEMP_DIR* ";
#findings
#FIXSERV  scrubbed missing last value
#FIXPARLA customer_number is missing a $ sign
#FIXPARLA blank last column is missing
#Fixserv is missing one 0 at the end
#updmeter is missing 2 values at the end
#udploc missing last 2
#fixlabor missing last value of 0
#fixserl is missing last value of 0 
#how do I handle blank pipes

FIXSERV_COUNT='0';
#COUNT=$(awk -F "|" '{print $1}' $file);
#echo $COUNT;
