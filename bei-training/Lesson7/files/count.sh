#!/bin/bash
TEMP_DIR='/tmp/bei-tmp'
#----------------------------
cd $TEMP_DIR
myFileNames=$( ls -d -1 $PWD/{*,.*}   );

for file in $myFileNames; do
NUMOFLINES=$(wc -l $file);
echo "Line count: $NUMOFLINES";
echo "First line: $(head -n 1 $file)";
echo;
done

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