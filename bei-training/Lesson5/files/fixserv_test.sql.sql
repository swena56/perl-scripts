show tables;
/*
+------------------------+
| Tables_in_bei_training |
+------------------------+
| billing_meters         |
| branches               |
| call_types             |
| correction_codes       |
| customers              |
| fixbilling             |
| fixlabor               |
| fixmdesc               |
| fixmeter               |
| fixparla               |
| fixploc                |
| fixserl                |
| fixserv                |
| location_codes         |
| meter_codes            |
| models                 |
| parts                  |
| problem_codes          |
| programs               |
| serials                |
| service                |
| service_meters         |
| service_parts          |
| technicians            |
+------------------------+
*/

select * from fixserv limit 1 \G;
/* fixserv
          null_field1:   
            call_id: SC64445
            model_number: LD117SPF
           serial_number: V4499407090
               call_date: 05/06/16
               call_time: 0847
           customer_time: 19
            arrival_time: 0945
    call_completion_time: 1004
               call_type: EM
            problem_code: ADJU
           location_code: 
             reason_code: ADJUSTMENTS
         correction_code: 
         date_dispatched: 05/06/16
         time_dispatched: 0926
         completion_date: 05/06/16
     meter_reading_total: 193794
meter_reading_prior_call: 193405
      date_of_prior_call: 05/02/16
                 pc_type: 
                 lc_type:    
             null_field2:    
          machine_status: 
    technician_id_number: 1037
         customer_number: DM
            miles_driven: 0
           response_time:   Z
*/

select * from fixmeter limit 1 \G;
/*
*************************** 1. row ***************************
        call_id: SC63667
          model: MPC4503-LC
  serial_number: E175MC62629
completion_date: 05/11/16
     meter_code: BW
  meter_reading: 0
1 row in set (0.00 sec)
*/


select count(*) from serials;
/*
+----------+
| count(*) |
+----------+
|    13117 |
+----------+
*/

SELECT serial_number, model_number, technician_number 
FROM service AS srv
JOIN serials AS s ON srv.serial_id = s.serial_id
JOIN models AS m ON s.model_id = m.model_id
JOIN technicians AS t ON srv.technician_id = t.technician_id
WHERE serial_number = 'V4499407090' 
#AND call_id = 'SC64445'
AND technician_number = '1037'
AND model_number = 'LD117SPF';
/*
+---------------+--------------+-------------------+
| serial_number | model_number | technician_number |
+---------------+--------------+-------------------+
| V4499407090   | LD117SPF     | 1037              |
+---------------+--------------+-------------------+
*/

SELECT service_meters.call_id
FROM service AS srv
JOIN serials AS s ON srv.serial_id = s.serial_id
JOIN models AS m ON s.model_id = m.model_id
JOIN technicians AS t ON srv.technician_id = t.technician_id
JOIN service_meters ON srv.service_id = service_meters.service_id
WHERE 
    call_id = 'SC63667';
/*
  Call data seems to belong in a table called service_call.  
*/

SELECT * FROM serials limit 5 \G;
/*
*************************** 1. row ***************************
    serial_id: 1
serial_number: ---
     model_id: 467
  customer_id: 4257
    branch_id: 1
   program_id: 5
*************************** 2. row ***************************
    serial_id: 2
serial_number: ---
     model_id: 515
  customer_id: 780
    branch_id: 1
   program_id: 1
*************************** 3. row ***************************
    serial_id: 3
serial_number: 00000-000
     model_id: 1249
  customer_id: 4569
    branch_id: 2
   program_id: 30
*************************** 4. row ***************************
    serial_id: 4
serial_number: 000274
     model_id: 404
  customer_id: 1986
    branch_id: 1
   program_id: 4
*************************** 5. row ***************************
    serial_id: 5
serial_number: 000276
     model_id: 404
  customer_id: 1986
    branch_id: 1
   program_id: 4
*/
select * from models where model_id = 404;
/*
+----------+--------------+-------------------+
| model_id | model_number | model_description |
+----------+--------------+-------------------+
|      404 | FI5750       | FUJITSU SCANNER   |
+----------+--------------+-------------------+
*/


SELECT * FROM service limit 5 \G;
/*
*************************** 1. row ***************************
         service_id: 1
      call_datetime: 2016-05-13 09:07:00
dispatched_datetime: 2016-05-17 08:14:00
   arrival_datetime: 2016-05-17 09:00:00
completion_datetime: 2016-05-17 11:17:00
          serial_id: 1002
      technician_id: 12
    problem_code_id: 10
   location_code_id: NULL
*************************** 2. row ***************************
         service_id: 2
      call_datetime: 2016-05-03 09:47:00
dispatched_datetime: 2016-05-06 09:43:00
   arrival_datetime: 2016-05-06 09:50:00
completion_datetime: 2016-05-06 11:06:00
          serial_id: 1150
      technician_id: 12
    problem_code_id: 10
   location_code_id: NULL
*************************** 3. row ***************************
         service_id: 3
      call_datetime: 2016-05-11 11:59:00
dispatched_datetime: 2016-05-12 07:59:00
   arrival_datetime: 2016-05-12 08:53:00
completion_datetime: 2016-05-12 09:12:00
          serial_id: 1198
      technician_id: 2
    problem_code_id: 11
   location_code_id: NULL
*************************** 4. row ***************************
         service_id: 4
      call_datetime: 2016-05-12 15:14:00
dispatched_datetime: 2016-05-13 09:26:00
   arrival_datetime: 2016-05-13 10:34:00
completion_datetime: 2016-05-13 13:13:00
          serial_id: 1302
      technician_id: 4
    problem_code_id: 11
   location_code_id: NULL
*************************** 5. row ***************************
         service_id: 5
      call_datetime: 2016-05-19 16:28:00
dispatched_datetime: 2016-05-19 16:29:00
   arrival_datetime: 2016-05-19 16:29:00
completion_datetime: 2016-05-19 16:19:00
          serial_id: 1691
      technician_id: 12
    problem_code_id: 12
   location_code_id: NULL
*/

SELECT * FROM models limit 5 \G;
/**************************** 1. row ***************************
         model_id: 1
     model_number: 1018D
model_description: Ricoh 5618
*************************** 2. row ***************************
         model_id: 2
     model_number: 1022
model_description: RICOH 5622
*************************** 3. row ***************************
         model_id: 3
     model_number: 1027
model_description: RICHO 5627
*************************** 4. row ***************************
         model_id: 4
     model_number: 1035
model_description: RICOH 5635
*************************** 5. row ***************************
         model_id: 5
     model_number: 1050S2
model_description: REXELL SHREDDER
*/

SELECT * FROM technicians limit 5 \G;
/*
*************************** 1. row ***************************
    technician_id: 1
technician_number: 1031
*************************** 2. row ***************************
    technician_id: 2
technician_number: 1033
*************************** 3. row ***************************
    technician_id: 3
technician_number: 1037
*************************** 4. row ***************************
    technician_id: 4
technician_number: 1039
*************************** 5. row ***************************
    technician_id: 5
technician_number: 1047
*/




select * from customers limit 5 \G;
/*
*************************** 1. row ***************************
    customer_id: 1
customer_number: 100226
*************************** 2. row ***************************
    customer_id: 2
customer_number: 100228
*************************** 3. row ***************************
    customer_id: 3
customer_number: 10080
*************************** 4. row ***************************
    customer_id: 4
customer_number: 10157
*************************** 5. row ***************************
    customer_id: 5
customer_number: 10168

Customers table looks like it might need more information
What information should I be able to get by using a customer_id?
*/

select * from billing_meters limit 5 \G;
/*
*************************** 1. row ***************************
    serial_id: 1198
    bill_date: 1
meter_code_id: 5
   meter_code: BW
*************************** 2. row ***************************
    serial_id: 3864
    bill_date: 1
meter_code_id: 5
   meter_code: BW
*************************** 3. row ***************************
    serial_id: 4737
    bill_date: 1
meter_code_id: 5
   meter_code: BW
*************************** 4. row ***************************
    serial_id: 5631
    bill_date: 1
meter_code_id: 5
   meter_code: BW
*************************** 5. row ***************************
    serial_id: 5687
    bill_date: 1
meter_code_id: 5
   meter_code: BW
*/
select * from fixserl limit 1 \G;
/*
*************************** 1. row ***************************
                         serial_id: 210210263
                 model_description: REXELL SHREDDER
             initial_meter_reading: 0
               date_sold_or_rented: 06/08/05
                      model_number: 4550S3
                       source_code: 
meter_reading_on_last_service_call: 0
                  null_placeholder:     
         date_of_last_service_call: 
                   customer_number: 34401
                 program_type_code: CH-110TC30
             product_category_code: 1220
                      sales_rep_id: 
                 connectivity_code: 
                       postal_code: 50265
                        sic_number:     
                      equipment_id: SN-2102102
             primary_technician_id: UA
         facility_management_equip: 
                 is_under_contract: 0
                         branch_id: 0
           customer_bill_to_number:   Z
                     customer_type: 
                   territory_field: 
*/

select * from fixlabor limit 1 \G;
/*
*************************** 1. row ***************************
        call_id:   
          model: SC63667
   labor_serial: MPC4503-LC
  activity_code: E175MC62629
         assist: 0
     labor_date: False
    tech_number: 05/11/16
  dispatch_time: 2042
   arrival_time: 1356
 departure_time: 1412
interrupt_hours: 1448

#should the call id have a value?  - maybe not in this situation
head /tmp/bei-tmp/KochBrothers-06062016-1125-TT-FIXLABOR
  |SC63667|MPC4503-LC|E175MC62629|SL|False|05/11/16|2042|1356|1412|1448|0000|0|  Z
  |SC63705|LDO16|78800197|SL|False|05/06/16|1037|1004|1025|1038|0000|0|  Z
  |SC63713|MP301SPF|W916P202758|SL|False|05/03/16|2042|0904|0935|1122|0000|0|  Z
  |SC63834|MPS3537mc|AK44051421|SL|False|05/05/16|1037|1305|1305|1622|0000|0|  Z
  |SC63847|HPLJP4015|CNDY101416|SL|False|05/03/16|2093|1158|1243|1335|0000|0|  Z
  |SC63850|MPS3537mc|AK49014971|SL|False|04/29/16|1039|1221|1221|1315|0000|0|  Z
  |SC63850|MPS3537mc|AK49014971|SL|False|05/11/16|1039|1224|1231|1353|0000|0|  Z
  |SC63859|MPS3537mc|AK47033281|SL|False|05/11/16|1039|1454|1511|1704|0000|0|  Z
  |SC63894|MP2501SP|E334MB10247|SL|False|05/03/16|2057|1243|1303|1325|0000|0|  Z
  |SC63951|MP5002SP|W533L101466|SL|False|05/02/16|2093|0754|0913|1054|0000|0|  Z

head /tmp/bei-tmp/KochBrothers-06062016-1125-TT-FIXBILLING
  |LD117SPF|V4498606089|05/09/16|B\W|149852|  Z
  |LD117SPF|V4408806408|05/09/16|B\W|251856|  Z
  |LD117SPF|V4408505596|05/09/16|B\W|75935|  Z
  |LD117SPF|V4409211747|05/13/16|B\W|138361|  Z
  |LD117SPF|V4499305722|05/09/16|B\W|122647|  Z
  |LD320D|L7077140517|05/25/16|B\W|182531|  Z
  |LD320D|L7086541076|05/13/16|B\W|137927|  Z
  |LD320D|L7087240316|05/13/16|B\W|237799|  Z
  |LD320SPF|76140885|05/24/16|B\W|308294|  Z
  |CX2033|AE99073161|05/13/16|B\W|33148|  Z

  select * from fixbilling limit 5 \G;
*************************** 1. row ***************************
         model:   
   serial_numl: LD117SPF
    billing_dl: 05/09/16
    meter_code: V4498606089
meter_readling: 0

Why is mine now showing the serial_number

sub scrub_line {

  my $self = shift;
  my $line = shift;
  chomp $line;

  my @array = split /\|/, $line;
  my $model             = "$array[0]";
  my $serial_number         = "$array[1]";
  my $billing_date        = "$array[2]";
  my $meter_code          = "$array[3]";
  my $meter_reading         = "$array[4]";
  
  $line = "$model|$serial_number|$meter_code|$billing_date|$meter_reading\n";

  return $line;
}

sub create_table_sql {

  my $self = shift;
  my $table = $self->table_name();

  #create fixserl table
  my $sql =  "CREATE TABLE IF NOT EXISTS $table (
           model          varchar(30),
           serial_numl    varchar(30),
           billing_dl     varchar(10),
           meter_code     varchar(20),
           meter_readling   INT(10)
        );";
  
  return $sql;
}

*/





select * from fixmdesc limit 1 \G;
/*
*************************** 1. row ***************************
            meter_code: BW
meter_code_description: This is to be used with black and white meters


RAW
head /tmp/bei-tmp/KochBrothers-06062016-1125-TT-updmdesc
B\W|This is to be used with black and white meters| Z
Color|This is to be used with color meters| Z
Total Count|This is to be used with Total Count meters| Z
Virtual|This is to be used with Virtual meters| Z
FEET|Linear Feet| Z
GB|One GB online storage| Z
Spot CLR1|Spot Color 1| Z
Spot CLR2|Spot Color 2| Z
*/

select * from location_codes limit 5 \G;
/*
Empty set (0.00 sec)

Is this expected?
*/

select * from programs limit 5 \G;
/*
*************************** 1. row ***************************
    program_id: 1
program_number: 
*************************** 2. row ***************************
    program_id: 2
program_number: CH-105_WF
*************************** 3. row ***************************
    program_id: 3
program_number: CH-110TC10
*************************** 4. row ***************************
    program_id: 4
program_number: CH-110TC30
*************************** 5. row ***************************
    program_id: 5
program_number: CH-110TC40
5 rows in set (0.00 sec)

No program number.  for first value need to implement a null check.

*/

select * from service_meters limit 5 \G;
/*
*************************** 1. row ***************************
   service_id: 1
    serial_id: 1002
meter_code_id: 1
   meter_code: BW
*************************** 2. row ***************************
   service_id: 2
    serial_id: 1150
meter_code_id: 1
   meter_code: BW
*************************** 3. row ***************************
   service_id: 3
    serial_id: 1198
meter_code_id: 1
   meter_code: BW
*************************** 4. row ***************************
   service_id: 4
    serial_id: 1302
meter_code_id: 1
   meter_code: BW
*************************** 5. row ***************************
   service_id: 5
    serial_id: 1691
meter_code_id: 1
   meter_code: BW
5 rows in set (0.00 sec)
*/



describe service_meters;
/*
+---------------+-------------+------+-----+---------+-------+
| Field         | Type        | Null | Key | Default | Extra |
+---------------+-------------+------+-----+---------+-------+
| service_id    | int(10)     | NO   | PRI | NULL    |       |
| serial_id     | int(10)     | NO   | MUL | NULL    |       |
| meter_code_id | int(10)     | NO   | PRI | NULL    |       |
| meter_code    | varchar(20) | YES  |     | NULL    |       |
+---------------+-------------+------+-----+---------+-------+
4 rows in set (0.00 sec)
*/

SELECT count(*)
FROM service;

SELECT call_type
FROM call_types WHERE call_type = 'RemoteTech';
#230
#cat5e run.
#add call_id, call_type to service is a linking field to 3 other tables


select * from fixbilling limit 5;  
#select * from fixaddr limit 5;   
#select * from fixcallt limit 5;
#select * from fixlabor limit 5;  
select * from fixmdesc limit 5;   
select * from fixmeter limit 5; 
select * from fixparla limit 5;
# select * from fixploc limit 5;
select * from fixserl limit 5;
select * from fixserv limit 5;
#select * from fixship limit 5;
#select * from fixtech limit 5;


