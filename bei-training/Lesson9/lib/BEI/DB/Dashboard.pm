package BEI::DB::Dashboard;

use Exporter 'import';
@EXPORT_OK = qw(
	get_dashboard_data
	top_ten_calltypes
	top_ten_models
	top_ten_techs
	parts_by_partscost
	techs_by_partscost
	models_by_partscost
	calltypes_by_partscost
	serialize_string_list
	available_months
); 

use strict;
use warnings;
use POSIX;

sub get_dashboard_data {
	
	#+------------+
	#| dashboard  |
	#+------------+
	
	my $month_index = shift || $current_month;
	my %dashboard_data = ( );
	my $dbh = &connect();
	
	#append the months that are available in the data set.
	my $sth = $dbh->prepare("SELECT month(completion_datetime) FROM service GROUP BY month(completion_datetime) ORDER BY month(completion_datetime);");
	$sth->execute();
	while(my @row = $sth->fetchrow_array){
		$dashboard_data{'available_months'} .= @row;
	}
	$sth->finish();

	#see if month data exists, and determine the string value of the index requested 
	my $sth = $dbh->prepare("
	SELECT MONTH(completion_datetime) as month_index, MONTHNAME(completion_datetime) as month 
	FROM service 
	WHERE MONTH(completion_datetime) = ?
	GROUP BY month_index
	ORDER BY completion_datetime;
	");

	$sth->execute($month_index); 	#expecting 1 row
	if($sth->rows == 1){   
		my $row = $sth->fetchrow_hashref;	
		#push @dashboard_data, $row;	
		$dashboard_data{'month'} .= $row->{'month'};
		$dashboard_data{'month_index'} .= $row->{'month_index'};
	}

	$dashboard_data{'selected_month'} = $month_index;

	#Total Calls for month index
	my $sth = $dbh->prepare("
	SELECT count(*) AS total_calls FROM service 
	WHERE MONTH(completion_datetime) = ? 
	");
	$sth->execute($month_index); 	#expecting 1 row
	if($sth->rows == 1){   
		my $row = $sth->fetchrow_hashref;	
		#push @dashboard_data, $row;	
		$dashboard_data{'total_calls'} .= $row->{'total_calls'};
	}

	# Total Parts 
	my $sth = $dbh->prepare("
		SELECT count(sp.part_id) AS total_parts FROM service_parts AS sp
		JOIN service AS ser ON sp.service_id = ser.service_id
		JOIN parts AS p ON p.part_id = sp.part_id
		WHERE MONTH(ser.completion_datetime) = ? 		
	");

	$sth->execute($month_index);	#expecting 1 row
	if($sth->rows == 1){   
		my $row = $sth->fetchrow_hashref;	
		$dashboard_data{'total_parts'} .= $row->{'total_parts'};
	}

	#|Total Serials w/ Calls |
	my $sth = $dbh->prepare("
	SELECT count(ser.service_id) AS total_serials_w_calls 
	FROM service AS ser
	JOIN serials AS s ON s.serial_id = ser.serial_id
	WHERE MONTH(ser.completion_datetime) = ?
	;");
	$sth->execute($month_index);	
	my $row = $sth->fetchrow_hashref;	
	$dashboard_data{'total_serials_w_calls'} .= $row->{'total_serials_w_calls'};

	# Total Techs w/ Calls
	my $sth = $dbh->prepare("
	SELECT count(*) AS total_techs_w_calls FROM technicians
	JOIN service AS ser ON ser.technician_id = technicians.technician_id 
	WHERE MONTH(ser.completion_datetime) = ?;
	");
	$sth->execute($month_index);
	my $row = $sth->fetchrow_hashref;	
	$dashboard_data{'total_techs_w_calls'} .= $row->{'total_techs_w_calls'};

	#|Total Models w/ Calls|
	my $sth = $dbh->prepare("
	SELECT count(s.model_id) AS total_models_w_calls FROM models
	JOIN serials AS s ON s.model_id = models.model_id
	JOIN service AS ser ON ser.serial_id = s.serial_id 
	WHERE MONTH(ser.completion_datetime) = ?;
	");
	$sth->execute($month_index);
	my $row = $sth->fetchrow_hashref;	
	$dashboard_data{'total_models_w_calls'} .= $row->{'total_models_w_calls'};

	$sth->finish();	

	return \%dashboard_data;
}

sub top_ten_calltypes {

	# need a group by method
	my $month_index = shift || 0;
	my $dbh = &connect();

	#|Top Ten Models by total calls for the month         |
	my $sth = $dbh->prepare("
	SELECT src.call_type, src.total_calls, src.month
	FROM (
	SELECT c.call_type,COUNT(c.call_type) AS total_calls, MONTH(completion_datetime) AS month
	FROM service AS s 
	JOIN serials ON s.serial_id = serials.serial_id
	JOIN call_types AS c ON s.call_type_id = c.call_type_id
	WHERE MONTH(completion_datetime) = ?
	GROUP BY c.call_type
	) AS src
	ORDER BY src.total_calls DESC LIMIT 10;
	");
	my @table_data;
	$sth->execute($month_index);
	if($sth->rows > 0){   

		while(my $row = $sth->fetchrow_hashref){
			push @table_data, $row;		
		}	
	}

	$sth->finish();	
	
	my $vars = {
			title => "Top Ten Models",
		  	table_data => \@table_data,
		  	month => $month_index,
	};

	return $vars;
}

sub top_ten_models {

	# need a group by method
	my $month_index = shift || 0;
	my $dbh = &connect();

	#|Top Ten Models by total calls for the month         |
	my $sth = $dbh->prepare("
	SELECT src.model_number, src.model_count, src.completion_datetime 
	FROM (
	SELECT m.model_number AS model_number,COUNT(m.model_number) AS model_count, MONTH(completion_datetime) AS month, completion_datetime
	FROM service AS s 
	JOIN serials ON s.serial_id = serials.serial_id
	JOIN models AS m ON serials.model_id = m.model_id
	JOIN technicians AS t ON s.technician_id = t.technician_id
	JOIN call_types AS c ON s.call_type_id = c.call_type_id
	GROUP BY m.model_number
	) AS src
	WHERE src.month = ?
	ORDER BY src.model_count DESC LIMIT 10;
	");
	$sth->execute($month_index);

	my @columns = ('Model Number', 'Amount', 'Date');
	my @table_data;

	if($sth->rows > 0){   

		while(my $row = $sth->fetchrow_hashref){
			push @table_data, $row;		
		}	
	}
	$sth->finish();	
	my $debug_dump = Dumper(@table_data);

	my $vars = {
			title => "Top Ten Models",
		  	table_data => \@table_data,
		  	table_columns => \@columns,
		  	month => $month_index,
		  	debug => $debug_dump,
		};

		return $vars;
}

sub top_ten_techs {

	# need a group by method
	my $month_index = shift || 0;
	my $dbh = &connect();

	#|Top Ten Models by total calls for the month         |
	my $sth = $dbh->prepare("
	SELECT t.technician_id, t.technician_number, COUNT(ct.call_type) as total_calls from technicians as t
	JOIN service AS s ON s.technician_id = t.technician_id
	JOIN call_types AS ct ON ct.call_type_id = s.call_type_id
	where MONTH(s.completion_datetime) = ?
	GROUP by t.technician_id
	ORDER BY total_calls DESC LIMIT 10 ;
		");
	$sth->execute($month_index);
	my $message;
	my @table_data = ["No data for this month"];
	my $num_rows = $sth->rows;
	if($num_rows > 0){   
		@table_data = [];
		while(my $row = $sth->fetchrow_hashref){
			push @table_data, $row;		
		}	
	}

	$sth->finish();	
	my $debug = Dumper(@table_data);
	my $vars = {
	  	table_data => \@table_data,
	  	num_rows => $num_rows,
	  	debug => $debug,	  
	};

	return $vars;
}

sub parts_by_partscost {
	
	# need a group by method
	my $month_index = shift || 0;
	my $dbh = &connect();

	#|Top Ten Models by total calls for the month         |
	my $sth = $dbh->prepare("
	SELECT src.part_number, src.month,  src.parts_cost_total
	FROM (
	SELECT p.part_number AS part_number, MONTH(completion_datetime) AS month, ROUND(SUM(sp.cost),2) AS parts_cost_total
	FROM service AS s 
	JOIN service_parts AS sp ON sp.service_id = s.service_id
	JOIN parts AS p ON p.part_id = sp.part_id
	GROUP BY p.part_number
	) AS src
	WHERE src.month = ?
	ORDER BY src.parts_cost_total DESC LIMIT 10;
		");
	$sth->execute($month_index);

	my @table_data;
	my $num_rows = $sth->rows;

	if($num_rows > 0){   
		while(my $row = $sth->fetchrow_hashref){
			push @table_data, $row;		
		}	
	}

	$sth->finish();	
	my $debug = Dumper(@table_data);
	my $vars = {
	  	table_data => \@table_data,
	  	num_rows => $num_rows,
	  	month => $month_index,
	  	debug => $debug,	  
	};

	return $vars;
}

sub techs_by_partscost {

	# need a group by method
	my $month_index = shift || 0;
	my $dbh = &connect();

	my $sth = $dbh->prepare("
	SELECT src.technician_id, src.technician_number, src.month, src.parts_cost_total
	FROM (
	SELECT t.technician_id, t.technician_number AS technician_number, MONTH(completion_datetime) AS month, ROUND(SUM(sp.cost),2) as parts_cost_total
	FROM service AS s 
	JOIN technicians AS t ON s.technician_id = t.technician_id
	JOIN service_parts AS sp ON sp.service_id = s.service_id
	WHERE MONTH(completion_datetime) = ?
	GROUP BY t.technician_number
	) AS src
	ORDER BY src.parts_cost_total  DESC LIMIT 10;
		");
	$sth->execute($month_index);

	my @table_data;
	my $num_rows = $sth->rows;
	if($num_rows > 0){   
		while(my $row = $sth->fetchrow_hashref){
			push @table_data, $row;		
		}	
	}

	$sth->finish();	
	my $debug = Dumper(@table_data);
	my $vars = {
	  	table_data => \@table_data,
	  	num_rows => $num_rows,
	  	month => $month_index,
	  	debug => $debug,	  
	};

	return $vars;
}

sub models_by_partscost {

	my $month_index = shift || 0;
	my $dbh = &connect();
	
	my $sth = $dbh->prepare("
	SELECT m.model_id, m.model_number AS model_number, MONTH(completion_datetime) AS month, ROUND(SUM(sp.cost),2) AS parts_cost_total
	FROM service AS s 
	JOIN serials ON s.serial_id = serials.serial_id
	JOIN service_parts AS sp ON sp.service_id = s.service_id
	JOIN models AS m ON serials.model_id = m.model_id
	JOIN technicians AS t ON s.technician_id = t.technician_id
	JOIN call_types AS c ON s.call_type_id = c.call_type_id
	WHERE MONTH(s.completion_datetime) = ?
	GROUP BY m.model_number 
	ORDER BY SUM(sp.cost) DESC LIMIT 10;
		");
	$sth->execute($month_index);
	my @table_data;
	my $num_rows = $sth->rows;

	if($num_rows > 0){   
		while(my $row = $sth->fetchrow_hashref){
			push @table_data, $row;		
		}	
	}

	$sth->finish();	
	my $debug = Dumper(@table_data);
	my $vars = {
	  	table_data => \@table_data,
	  	num_rows => $num_rows,
	  	month => $month_index,
	  	debug => $debug,	  
	};

	return $vars;
}

sub calltypes_by_partscost {

	# need a group by method
	my $month_index = shift || 0;
	my $dbh = &connect();

	#|Top Ten Models by total calls for the month         |
	my $sth = $dbh->prepare("
	SELECT src.call_type, src.month, src.part_cost_total
	FROM (
	SELECT c.call_type, MONTH(completion_datetime) AS month, ROUND(SUM(sp.cost),2) as part_cost_total
	FROM service AS s 
	JOIN serials ON s.serial_id = serials.serial_id
	JOIN service_parts AS sp ON sp.service_id = s.service_id
	JOIN call_types AS c ON s.call_type_id = c.call_type_id
	WHERE MONTH(s.completion_datetime) = ?
	GROUP BY c.call_type) 
	AS src
	ORDER BY src.part_cost_total DESC LIMIT 10;
	");
	$sth->execute($month_index);
	my @table_data;
	my $num_rows = $sth->rows;
	
	if($num_rows > 0){   
		while(my $row = $sth->fetchrow_hashref){
			push @table_data, $row;		
		}	
	}

	$sth->finish();	
	my $debug = Dumper(@table_data);
	my $vars = {
	  	table_data => \@table_data,
	  	num_rows => $num_rows,
	  	month => $month_index,
	  	debug => $debug,	  
	};

	return $vars;
}

sub serialize_string_list {

   return join(',',
      map {
         (defined($_)
            ? do { local $_=$_; s/\^/^1/g; s/\|/^2/g; $_ }
            : '^0'
         )
      } @_
   );
}

sub available_months {

	my @available_months;
	my $dbh = &connect();
	my $sth = $dbh->prepare("SELECT month(completion_datetime) FROM service GROUP BY month(completion_datetime) ORDER BY month(completion_datetime);");
	$sth->execute();

	while(my @row = $sth->fetchrow_array){
		push @available_months, @row;
	}

	$sth->finish();

	return @available_months;
}
1;