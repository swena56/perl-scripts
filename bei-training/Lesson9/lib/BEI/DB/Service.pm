package BEI::DB::Service;

use Exporter 'import';
@EXPORT_OK = qw(
	get_call_dates_list 
	get_service_data 
	build_service_data_cols
	buildPagerFromData
); 

use strict;
use warnings;
use POSIX;
#perform search

#dashboard data - possibly another layer, not in here.

=pod
	Returns a list of dates that calls where received on
=cut
sub get_call_dates_list {
	my $dbh = shift || die("[!] Need a dbh for get_call_dates_list.");
	my $sql = "SELECT DATE(completion_datetime) FROM service
GROUP BY DATE(completion_datetime)
	";

	my $sth = $dbh->prepare($sql);
	$sth->execute();

	my @call_list;

	while(my @row = $sth->fetchrow_array){
		push @call_list, @row;
	}

	return @call_list;
}

sub get_service_data {

	#default values 
	my $dbh = shift;
	my $args = shift;  #
	my ($sql,$binds) = build_service_data_sql( $args->{search_input});
	my $selected_column = "call_datetime";
	my $direction = "DESC";
	my $max_per_page;  #argument instead of args
	my $start_row;
	my $pager = {};
	my $total_pages;
	my $start_date;
	my $end_date;
	my ($total_records);

	#check start date filter  make sure it not an empty string
	if( $args->{start_date} ) {
		$start_date = $args->{ start_date };
	}

	#check end date filter make sure it not an empty string
	if( $args->{end_date} ) {
		$end_date = $args->{ end_date };
	}

	#append date filter
	if( $start_date || $end_date ){
		if( $start_date && $end_date ){
			$sql .= " AND call_datetime between '$start_date' AND '$end_date' ";
		} elsif ( $start_date && !$end_date ) {
			$sql .= " AND call_datetime >= '$start_date' ";
		} elsif( $end_date && !$start_date ) {
			$sql .= " AND call_datetime <= '$end_date' ";
		}
	}

	$sql .= " GROUP BY s.service_id ";

	if( $args->{selected_column} ){

		#check column data
		my $cols = build_service_data_cols();
		if( exists $cols->{ $args->{selected_column} } ){

			# set my order_by
			$selected_column = $args->{selected_column};
			
			#check direction, it must match ASC or DESC
			if($args->{direction} && $args->{direction} =~ m/\A(?:ASC|DESC)\Z/i ){

				$direction = $args->{direction};
			}

			$sql .= " ORDER BY $selected_column $direction ";
		}
	}

	if( $args->{max_per_page} ){
		$max_per_page = $args->{max_per_page};
		($total_records) = $dbh->selectrow_array("SELECT COUNT(*) FROM ( $sql ) AS sql_src",undef,@{$binds});
	
		$max_per_page = $args->{max_per_page};
		$total_pages = int(ceil($total_records/$max_per_page));
		$start_row = (defined $args->{start_row}) ? $args->{start_row} : 0 ;

		if($args->{export_csv} eq "all"){
			$sql .= "LIMIT " . ($start_row * 100) . ","  . $max_per_page * $total_pages;
		} else{
			$sql .= "LIMIT " . ($start_row * 100) . ","  . $max_per_page;
		}
	}

	#returning json ?  vs raw 
	my $data = $dbh->selectall_arrayref( $sql, { Slice => {} }, @{$binds});
	
	if( $max_per_page ){

		$pager = { 	
			num_rows => $total_records,
			total_num_rows_on_page => scalar @{$data},
			starting_page => $start_row,
			total_pages => $total_pages,
			starting_row => $start_row,
			current_page => $start_row,
			current_row => $start_row,
		};	
	}
	#$pager = buildPagerFromData($total_records, $start_row);

	my $result = { 
		data => $data, 
		pager => $pager,
		sql => $sql,
	};

	return $result;
}

#not in use
sub buildPagerFromData {
    my ($total_records, $offset) = @_;
    
    return {} if ( !$total_records || !$offset );
    
    my $per_page = $offset->{limit};
    my $current_page = $offset->{offset};
    my $total_pages = int(ceil($total_records/$per_page))-1;

    my $info = {
        total_records => $total_records,
        total_pages => $total_pages,
        per_page => $per_page,
        current_page => $current_page,
        first_page => 0,
        last_page => $total_pages,
        previous_page => 0,
        next_page => 0
    };
    $info->{previous_page} = ($current_page - 1) if ($current_page > 0);
    $info->{next_page} = ($current_page + 1) if($current_page < $total_pages);
    
    return $info;
}

sub build_service_data_sql {

	my $search_input = shift;
	my $start_date = shift;
	my $end_date = shift;

	my @binds = ( '%'. $search_input . '%' );

	# . $dbh->quote('%'.$search_input.'%') ." 
	#query the selected pages
	my $sql = "
	SELECT serial_number, model_number, call_type, call_datetime, dispatched_datetime, arrival_datetime, completion_datetime, technician_number,
	s.call_id_not_call_type, ROUND(SUM(cost),2) AS total_parts_cost, s.service_id
	FROM service AS s 
	JOIN serials ON s.serial_id = serials.serial_id
	JOIN models AS m ON serials.model_id = m.model_id
	JOIN technicians AS t ON s.technician_id = t.technician_id
	JOIN call_types AS c ON s.call_type_id = c.call_type_id
	LEFT JOIN service_parts AS sp ON s.service_id = sp.service_id
	WHERE serial_number LIKE ? ";

	return ( $sql, \@binds);
}

sub build_service_data_cols {

	my %column_hash = (
		'serial_number' => 'Serial Number',
		'model_number' => 'Model Number',
		'call_type' => 'Call Type',
		'call_datetime' => 'Call Date/Time',
		'dispatched_datetime' => 'Dispatched Date/Time',
		'arrival_datetime' => 'Arrival Date/Time', 
		'completion_datetime' => 'Completion Date/Time', 
		'technician_number' => 'Tech #',
		'call_id_not_call_type' => 'Call ID', 
		'total_parts_cost' => 'Total Parts Cost', 
		'service_id' => 'Service Id',
	);

	return \%column_hash;
}

1;