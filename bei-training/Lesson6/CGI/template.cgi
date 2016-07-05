#!/usr/bin/perl
use strict;
use CGI;
use CGI::Pretty;
use CGI::Carp qw(fatalsToBrowser);

use lib qw(/home/ubuntu/perl-scripts/bei-training/Lesson5/lib);

use BEI::DB 'connect';
my $dbh = &connect();
die("no db") if(!$dbh);

my $q = CGI->new();
my $user = $q->param('name'); 
my $serial = $q->param('serial');
my @results =  $q->param('results');
print $q->header();  #is required for the browser to know what content

print <<HTML;
<html>
	<head>
		<!-- Jquery 2.1 <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>-->
		<script src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>

		<script src="https://cdn.datatables.net/1.10.12/css/jquery.dataTables.min.css"></script>
		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

		<!-- Optional theme -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

		<!-- Latest compiled and minified JavaScript -->
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
		
		
		<meta charset="UTF-8">
		<script type='text/javascript'>
			function click(){
				
   
			 alert("Row index is: " + x.rowIndex);

			}

			function createSerialsTable(results){

				if (undefined != results)
				{
					console.log(results);
					var body = document.getElementById("results");
					var message = document.createElement("p");
					var search_criteria_message = document.createTextNode("Serial search criteria: $serial");
					message.appendChild(search_criteria_message);
					body.appendChild(message);	
				}
			}			
		</script>

		<style>
		table, th, td {
		    border: 1px solid black;
		    border-collapse: collapse;
		}
		th, td {
		    padding: 5px;
		    text-align: left;    
		}
		tr { cursor: default; }
		.highlight { background: yellow; }
		</style>
		<title>Serial Audit</title>
	</head>

	<body>
	<h1> Serial Audit </h1>
	<p> Welcome to Serial Audit Guest User </p>

	<form action="hello.cgi" method="post" accept-charset="UTF-8">
	  Serial: <input type="text" name="serial">
	 
	  <input type="submit" value="Submit">
	</form>

 	<h2> Results</h2>
    <div id="results"/>
	<script type='text/javascript'>createSerialsTable('@results');</script>	

<!--


SELECT serial_number, model_number
FROM serials AS srv

JOIN models AS m ON srv.model_id = m.model_id
WHERE serial_number = 'V4499407090' ;

-->

HTML

my $sth;
if($dbh)
	{
		my $tablecontent=[$q->th(['serial_id', 'serial_number','model_id', 'customer_id', 'branch_id', 'program_id'])];	
			
  		

  		
  	
	  	#check to see if we have results that need to be displayed
		if((length @results) > 0)
		{
		   
		  #print (length @results) . " results showing.";
		} 

			
		$sth = $dbh->prepare("

SELECT serial_number, model_number, call_type, completion_datetime, technician_number,
	s.call_id_not_call_type, SUM(cost) AS total_parts_cost
FROM service AS s 
JOIN serials ON s.serial_id = serials.serial_id
JOIN models AS m ON serials.model_id = m.model_id
JOIN technicians AS t ON s.technician_id = t.technician_id
JOIN call_types AS c ON s.call_type_id = c.call_type_id
LEFT JOIN service_parts AS sp ON s.service_id = sp.service_id
WHERE serial_number = ?
GROUP BY s.service_id;"
);



#SELECT *
#FROM serials AS srv
#JOIN models AS m ON srv.model_id = m.model_id
#WHERE serial_number = ?"

		
		if($serial){
			$sth->execute($serial);	
		} else {
			$sth->execute;
		}
		#X425L300013
		print "<table cellspacing='0' width='100%'>

	
					<tr onclick='clickMe(this)' >
					<th>$sth->{NAME}->[0]</th>
			   		<th>$sth->{NAME}->[1]</th>
			   		<th>$sth->{NAME}->[2]</th>
			   		<th>$sth->{NAME}->[3]</th>
			   		<th>$sth->{NAME}->[4]</th>
			   		<th>$sth->{NAME}->[5]</th>
			   		<th>$sth->{NAME}->[6]</th>
			   </tr>";
		while (my @row = $sth->fetchrow_array) {
		    print "<tr onclick='clickMe(this)'  >
		    			<td>$row[0]</td>
		    			<td>$row[1]</td>
		    			<td>$row[2]</td>
		    			<td>$row[3]</td>
		    			<td>$row[4]</td>
		    			<td>$row[5]</td>
		    			<td>$row[6]</td>
		    		</tr>";
		}
		print "<script type='text/javascript'>function clickMe(x){lert('Row index is: ' + x.rowIndex);}</script>";
		#print row count 
		print "</table>";
		print "</body></html>";
		$sth->finish();
}
print <<HTML;
	<h2> Requirements </h2>
	<p> - Model popup </p>
	<p> + Santized Data </p>
	</body>
	</html>
HTML
exit;