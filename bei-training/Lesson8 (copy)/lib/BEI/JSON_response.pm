package BEI::JSON_response;

use Exporter 'import';
@EXPORT_OK = qw ( 
					serial_search
					get_serial_data
					get_part_data
				);
use strict;
use warnings;

use BEI::DB 'connect';

use JSON;


sub serial_search {

	my $serial_user_input = shift;

	my $dbh = &connect();
	if($serial_user_input eq ""){
		my $op = JSON -> new -> utf8 -> pretty(1);
		my $json = $op -> encode({
			num_rows => 0,
			columns => 'none',
			result_data => 'null',
			raw_columns => 'null',
			user_input => $serial_user_input,
		});

		return $json;
	}

	if($dbh){

		my $currency_type = "\\\$";

		my $sth = $dbh->prepare("
		SELECT serial_number, model_number, call_type, completion_datetime, technician_number,
			s.call_id_not_call_type, CONCAT('$currency_type', ROUND(SUM(cost),2) ) AS total_parts_cost, s.service_id
		FROM service AS s 
		JOIN serials ON s.serial_id = serials.serial_id
		JOIN models AS m ON serials.model_id = m.model_id
		JOIN technicians AS t ON s.technician_id = t.technician_id
		JOIN call_types AS c ON s.call_type_id = c.call_type_id
		LEFT JOIN service_parts AS sp ON s.service_id = sp.service_id
		#WHERE serial_number LIKE '%?' 
		WHERE serial_number LIKE " . $dbh->quote('%'.$serial_user_input.'%') ."
		GROUP BY s.service_id
		ORDER BY completion_datetime DESC"
		);

		$sth->execute();	
		my $num_rows = $sth->rows;

		my @table_data;

		my @columns = ('Serial Number', 'Model Number', 'Call Type', 'Completion DateTime', 'Tech #',
					'Call ID', 'Total Part Cost', 'Service Call Actions');

		
		my @raw_columns = $sth->{NAME};
		while (my @row = $sth->fetchrow_array) {	
		    push @table_data, \@row;
		}

		#close database connection
		$sth->finish();
		#
		my $op = JSON -> new -> utf8 -> pretty(1);
		my $json = $op -> encode({
			num_rows => $num_rows,
			columns => \@columns,
			result_data => \@table_data,
			raw_columns => \@raw_columns,
			user_input => $serial_user_input,
		});
		
		return $json;
	}

	return "No Data";
}

sub get_serial_data {
	
	my $dbh = &connect();

	if($dbh){
		
		my $currency_type = "\\\$";

		my $sth = $dbh->prepare("

		SELECT serial_number, model_number, call_type, completion_datetime, technician_number,
		s.call_id_not_call_type, CONCAT('$currency_type', ROUND(SUM(cost),2) ) AS total_parts_cost, s.service_id
		FROM service AS s 
		JOIN serials ON s.serial_id = serials.serial_id
		JOIN models AS m ON serials.model_id = m.model_id
		JOIN technicians AS t ON s.technician_id = t.technician_id
		JOIN call_types AS c ON s.call_type_id = c.call_type_id
		LEFT JOIN service_parts AS sp ON s.service_id = sp.service_id
		GROUP BY s.service_id
		ORDER BY completion_datetime DESC"
				);

		$sth->execute();	
		my $num_rows = $sth->rows;

		my @table_data;

		my @columns = ('Serial Number', 'Model Number', 'Call Type', 'Completion DateTime', 'Tech #',
					'Call ID', 'Total Part Cost', 'Service Call Actions');
		
		my @raw_columns = $sth->{NAME};
		while (my @row = $sth->fetchrow_array) {	
		    push @table_data, \@row;
		}

		#close database connection
		$sth->finish();
		#
		my $op = JSON -> new -> utf8 -> pretty(1);
		my $json = $op -> encode({
			num_rows => $num_rows,
			columns => \@columns,
			result_data => \@table_data,
			raw_columns => \@raw_columns,
			
		});
		
		return $json;
	}
}

sub get_part_data {

	my $service_id = shift || die("get part data needs service_id");
	my $dbh = &connect();

	if($dbh){

		my $sth = $dbh->prepare("
		SELECT sp.part_number, service_parts.service_id, s.serial_number, service_parts.cost, mc.meter_code
		FROM service_parts
		JOIN parts AS sp ON service_parts.part_id = sp.part_id
		JOIN service AS ser ON service_parts.service_id = ser.service_id
		JOIN serials AS s ON ser.serial_id = s.serial_id
		JOIN service_meters AS sm ON sm.service_id = ser.service_id
		JOIN meter_codes AS mc ON sm.meter_code_id = mc.meter_code_id
		WHERE service_parts.service_id = ?"
			);

		$sth->execute($service_id);	
		my $num_rows = $sth->rows;

		
		my @table_data = [];
		
		my @columns = ('Part Number, Service ID, Serial Number, Part Cost, Meter Code');
		push @table_data,th($sth->{NAME});
		
		while (my @row = $sth->fetchrow_array) {	
		    push @table_data, @row;
		}

		#close database connection
		$sth->finish();
		my $op = JSON -> new -> utf8 -> pretty(1);
		my $json = $op -> encode({
			num_rows => $num_rows,
			columns => \@columns,
		    result => \@table_data
		});
		print $json;
	}
}

1;