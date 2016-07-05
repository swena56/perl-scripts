#!/usr/bin/bash
# basic review of tables


mysql -e "show tables;" > output.txt

mysql -e "DESCRIBE billing_meters" >> output.txt
echo "billing_meters Table Data\n" >> output.txt
mysql -e "SELECT * FROM billing_meters limit 5 \G;" >> output.txt

mysql -e "DESCRIBE branches" >> output.txt
echo " branches Table Data\n" >> output.txt
mysql -e "SELECT * FROM branches limit 5 \G;" >> output.txt

mysql -e "DESCRIBE call_types" >> output.txt
echo "call_types Table Data\n" >> output.txt
mysql -e "SELECT * FROM call_types limit 5 \G;" >> output.txt

mysql -e "DESCRIBE correction_codes" >> output.txt
echo "corection_codes Table Data\n" >> output.txt
mysql -e "SELECT * FROM correction_codes limit 5 \G;" >> output.txt

mysql -e "DESCRIBE customers" >> output.txt
echo "customers Table Data\n" >> output.txt
mysql -e "SELECT * FROM customers limit 5 \G;" >> output.txt

mysql -e "DESCRIBE fixlabor" >> output.txt
echo "fixlabor fixbilling Table Data\n" >> output.txt
mysql -e "SELECT * FROM fixlabor limit 5 \G;" >> output.txt

mysql -e "DESCRIBE fixmdesc" >> output.txt
echo "fixmdesc Table Data\n" >> output.txt
mysql -e "SELECT * FROM fixmdesc limit 5 \G;" >> output.txt

mysql -e "DESCRIBE fixmeter" >> output.txt
echo "fixmeter Table Data\n" >> output.txt
mysql -e "SELECT * FROM fixmeter limit 5 \G;" >> output.txt

mysql -e "DESCRIBE fixparla" >> output.txt
echo "fixparla Table Data\n" >> output.txt
mysql -e "SELECT * FROM  fixparla limit 5 \G;" >> output.txt

mysql -e "DESCRIBE fixploc" >> output.txt
echo "fixploc Table Data\n" >> output.txt
mysql -e "SELECT * FROM fixploc limit 5 \G;" >> output.txt

mysql -e "DESCRIBE fixserl" >> output.txt
echo "fixserl Table Data\n" >> output.txt
mysql -e "SELECT * FROM fixserl limit 5 \G;" >> output.txt

mysql -e "DESCRIBE fixserv" >> output.txt
echo "fixserv Table Data\n" >> output.txt
mysql -e "SELECT * FROM fixserv limit 5 \G;" >> output.txt

mysql -e "DESCRIBE location_codes" >> output.txt
echo "location_codes Table Data\n" >> output.txt
mysql -e "SELECT * FROM location_codes  limit 5 \G;" >> output.txt

mysql -e "DESCRIBE meter_codes" >> output.txt
echo "meter_codes Table Data\n" >> output.txt
mysql -e "SELECT * FROM  meter_codes limit 5 \G;" >> output.txt

mysql -e "DESCRIBE models" >> output.txt
echo " Table Data\n" >> output.txt
mysql -e "SELECT * FROM models  limit 5 \G;" >> output.txt

mysql -e "DESCRIBE parts" >> output.txt
echo " Table Data\n" >> output.txt
mysql -e "SELECT * FROM  parts limit 5 \G;" >> output.txt

mysql -e "DESCRIBE problem_codes" >> output.txt
echo " Table Data\n" >> output.txt
mysql -e "SELECT * FROM  problem_codes  limit 5 \G;" >> output.txt

mysql -e "DESCRIBE programs" >> output.txt
echo " Table Data\n" >> output.txt
mysql -e "SELECT * FROM  programs limit 5 \G;" >> output.txt

mysql -e "DESCRIBE serials" >> output.txt
echo " Table Data\n" >> output.txt
mysql -e "SELECT * FROM  serials limit 5 \G;" >> output.txt

mysql -e "DESCRIBE service" >> output.txt
echo " Table Data\n" >> output.txt
mysql -e "SELECT * FROM  service limit 5 \G;" >> output.txt

mysql -e "DESCRIBE service_meters" >> output.txt
echo " Table Data\n" >> output.txt
mysql -e "SELECT * FROM service_meters  limit 5 \G;" >> output.txt

mysql -e "DESCRIBE service_parts" >> output.txt
echo " Table Data\n" >> output.txt
mysql -e "SELECT * FROM  service_parts limit 5 \G;" >> output.txt

mysql -e "DESCRIBE technicians" >> output.txt
echo " Table Data\n" >> output.txt
mysql -e "SELECT * FROM technicians  limit 5 \G;" >> output.txt

cat output.txt | less
sublime-text output