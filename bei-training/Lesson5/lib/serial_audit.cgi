#!/usr/bin/perl
use strict;
use CGI;
use CGI::Pretty;

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
		<!-- Jquery 2.1 -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

		<!-- Optional theme -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

		<!-- Latest compiled and minified JavaScript -->
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
		
		
		<meta charset="UTF-8">
		<script type='text/javascript'>
			function get_matching_serials(){
				document.getElementById("results").innerHTML = "Hello JavaScript!";
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


		$sth = $dbh->prepare("SELECT * FROM serials where serial_number=?");
		
		if($serial){
			$sth->execute($serial);	
		} else {
			$sth->execute;
		}
		

		
		print '<table border="1" width="100%">';

		# table headings are SQL column names
		print "<tr>
					<th>$sth->{NAME}->[0]</th>
			   		<th>$sth->{NAME}->[1]</th>
			   		<th>$sth->{NAME}->[2]</th>
			   		<th>$sth->{NAME}->[3]</th>
			   		<th>$sth->{NAME}->[4]</th>
			   		<th>$sth->{NAME}->[5]</th>
			   </tr>";
		while (my @row = $sth->fetchrow_array) {
		    print "<tr class='clickable-row' >
		    			<td>$row[0]</td>
		    			<td>$row[1]</td>
		    			<td>$row[2]</td>
		    			<td>$row[3]</td>
		    			<td>$row[4]</td>
		    			<td>$row[5]</td>
		    		</tr>";
		}

		#print row count 
		print "</table>\n";
		print "</body></html>\n";
		$sth->finish();
}
print <<HTML;

		

	<h2> Requirements of this project </h2>
	<p> Create a modal-popup for meters and parts associated with that call.</p>
	<p> Make sure to santize data </p>
	</body>
	</html>
HTML




exit;