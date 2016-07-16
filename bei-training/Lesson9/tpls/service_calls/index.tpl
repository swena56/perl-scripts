<!DOCKTYPE html>
<html>
<head>
    
<style>
ul.pagination {
    display: inline-block;
    padding: 0;
    margin: 0;
}

ul.pagination li {display: inline;}

ul.pagination li a {
    color: black;
    float: left;
    padding: 8px 16px;
    text-decoration: none;
    transition: background-color .3s;
    border: 1px solid #ddd;
}

ul.pagination li a.active {
    background-color: #4CAF50;
    color: white;
    border: 1px solid #4CAF50;
}

ul.pagination li a:hover:not(.active) {background-color: #ddd;}

#clear_end_date, #clear_start_date{
  background-color: transparent;
  box-shadow: none;
  border: 3px solid #ba3643; /*Adjust 3px  to your preferred border width*/
}

</style>

<script>  
    //initalize starting values
    var last_selected_column = "serial_number";
    var current_page = 0;
    var starting_page = 0;
    var start_date;
    var end_date;
    var direction = "ASC";
    var user_input = "[% user_input %]";
    console.log("starting user input: " + user_input);
    
    $(document).ready(function(){

        $("#serial_search").focus();
        //list of active service dates
        var active_service_dates = [];
        [% FOREACH date IN service_date_range %]
            active_service_dates.push("[% date %]");
        [% END %]
        //console.log(active_service_dates);

        //create minDate and add one day to min Date
        var minDate = active_service_dates[0];
        minDate = new Date(minDate);
        minDate.setDate(minDate.getDate() + 1);

        //maxDate
        var maxDate = active_service_dates[active_service_dates.length - 1];
        maxDate = new Date(maxDate);
        console.log("service date range: " + minDate + " - " + maxDate );

        //display the amount of days worth of data that is detected by service_date_range to the div container data_detected
        $("#data_detected").empty();
       var numberOfMonths = (maxDate.getFullYear() - minDate.getFullYear()) * 12 + (maxDate.getMonth() - minDate.getMonth() ) + 1;
       $("#data_detected").append($("<span><b> Filter By Date </b> (<span style='color:green;'> "+numberOfMonths+"</span> months of data detected. )</span>"));

       //initalize datapicker start
        $("#datepicker_start" ).datepicker({ 
            minDate: new Date(minDate), 
            maxDate: new Date(maxDate),
            defaultDate: new Date(minDate),
            onSelect: function(dateText, inst) {
                start_date = $("#datepicker_start").datepicker( "getDate");
                start_date = $.datepicker.formatDate("yy-mm-dd", new Date(start_date));  // 00:00:00

                //set datepicker_end default date to the new datepicker_start date
                $("#datepicker_end").datepicker( "option", "defaultDate", new Date(start_date) );

                console.log("start clicked: "+ start_date);
                 if(user_input != ''){
                    update_results( starting_page, last_selected_column );    
                }

                //update filter message
                $("#start_date_filter_results_message").empty();
                $("#start_date_filter_results_message").append("<span class='glyphicon glyphicon-warning-sign' style='color: darkorange;'> Only showing records after: <b> " + start_date +"</b></span>");
            },
        });
        
        //initalize datapicker end
        $("#datepicker_end" ).datepicker({ 
            minDate: new Date(minDate), 
            maxDate: new Date(maxDate),
            defaultDate: new Date(maxDate),
            onSelect: function(dateText, inst) {
                end_date = $("#datepicker_end").datepicker( "getDate");
                end_date = $.datepicker.formatDate("yy-mm-dd", new Date(end_date));
                console.log("end clicked: "+ end_date);
                
                //if the input field is not empty update the results
                if(user_input != ''){
                    update_results( starting_page, last_selected_column );    
                }

                //update user message about what is being filtered
                //update filter message
                $("#end_date_filter_results_message").empty();
                 $("#end_date_filter_results_message").append("<span class='glyphicon glyphicon-warning-sign' style='color: darkorange;'> Only showing records before: <b> " + end_date +"</b></span>");
                
            },
        });

        $("#clear_end_date").on('click', function(){
            $("#end_date_filter_results_message").empty();
        });

        $("#clear_start_date").on('click', function(){
            $("#start_date_filter_results_message").empty();
        });

        $("#datepicker_end").datepicker('setDate', null);
        $("#datepicker_start").datepicker('setDate', null);

        //clear buttons
        $("#clear_start_date").on('click', function(){
            $("#datepicker_start").datepicker('setDate', null);
        });
        $("#clear_end_date").on('click', function(){
            $("#datepicker_end").datepicker('setDate', null);
        });

        $("#serial_search").keyup(function(event){
            //get user input
            user_input = $(this).val();

            if(event.which == 27 || user_input == ""){
                console.log("escape button detected- changing focus to search: "+  $(this).val());                        
                $('#rst_form').click();  //clear form
                $('#serial_table').empty();
                $("#datepicker_end").datepicker('setDate', null);
                $("#datepicker_start").datepicker('setDate', null);
                $('#results_pagination').empty();
                $("#serial_search").focus();
                return;
            }

           update_results(starting_page);
        });  
    }); 

    function toggle_sort_order(starting_page, selected_column){
        console.log("toggling sort order: " + direction );

        if( selected_column == last_selected_column ){
          if(direction == "DESC"){
                direction = "ASC";
            } else if (direction == "ASC"){
                direction = "DESC";
            }
        }
        
        last_selected_column = selected_column;
        update_results(starting_page, selected_column);
    }

    function export_page(){
       
        var export_status = "page";
     //   update_results(starting_page,last_selected_column, export_status);
         $.post('service_calls/serial_json.cgi', {
            search_input: user_input,
            starting_page: current_page,
            selected_column: last_selected_column,
            direction: direction,
            start_date: start_date,
            end_date: end_date,
            export_csv: export_status,
        }, function(csv_response) {
             console.log("exporting page");
           console.log(csv_response);
           $("#serial_table").append(csv_response);

        }, 'html');
    }

    function export_all(){
        
         var export_status = "all";
         //update_results(starting_page,last_selected_column, export_status);
       
         $.post('service_calls/serial_json.cgi', {
            search_input: user_input,
            starting_page: 0,
            selected_column: last_selected_column,
            start_date: start_date,
            end_date: end_date,
            direction: direction,
            export_csv: export_status,
        }, function(csv_response) {
            console.log("exporting all");
            console.log(csv_response);
            $("#serial_table").append(csv_response);

        }, 'html');
    }

    function update_results(starting_page, selected_column) {
        console.log("updating results with page: " + starting_page);
        console.log("start_date: " + start_date );
        console.log("end_date: " + end_date );

        //check to make sure starting page is defined
        if(selected_column){
            console.log("Order by: " + selected_column + " in " + direction + " order.");
        }
        //if(starting_page)
      $.post('service_calls/serial_json.cgi', {
        search_input: user_input,
        starting_page: starting_page,
        selected_column: last_selected_column,
        start_date: start_date,
        end_date: end_date,
        direction: direction}, function(json) {

            //pass json data into results table
            console.log(
                "Search Input:" + json.search.toString() + "\n" + 
                "Number of rows:" + json.num_rows.toString() + "\n" +
                "total_num_rows_on_page:" + json.total_num_rows_on_page.toString() + "\n" + 
                "starting_page:" + json.starting_page.toString() + "\n" + 
                "columns:" + json.columns.toString() + "\n" + 
                //"result_data:" + json.result_data.toString() + "\n" + 
                "total_pages:" + json.total_pages.toString() + "\n" + 
                "starting_row:" + starting_page.toString() + "\n" + 
                "current_page:" + json.current_page.toString() + "\n" + 
                "current_row:" + json.current_row.toString() + "\n" 
            );

            current_page = json.current_page;
            //console.log(json.selected_column.toString() + "");
            console.log("Debug:"+json.debug.toString());
            $("#serial_table").empty();

            var table = $("<table id='serial_table' text-align='left' class='table table-hover table-responsive '>");
            var column_headers = $("<tr></tr>"); 

            //find the column that is selected and give it a ordering symbol
            for (var key in json.columns) {
                if(key == last_selected_column){
                    if(direction == "DESC"){
                        json.columns[key] = json.columns[key] + "&#9660";
                    } else if( direction == "ASC") {
                        json.columns[key] = json.columns[key] + "&#9650";
                    }
                }
            }

            column_headers.append($("<th id='serial_number'><a href=\"javascript:toggle_sort_order('"+(json.starting_page)+"','serial_number')\">"+json.columns.serial_number+"</a> </th>")); 
            column_headers.append($("<th id='model_number'><a href=\"javascript:toggle_sort_order('"+(starting_page)+"','model_number')\">"+json.columns.model_number+"</a> </th>"));
            column_headers.append($("<th id='arrival_datetime'><a href=\"javascript:toggle_sort_order('"+(starting_page)+"','arrival_datetime')\"> "+json.columns.arrival_datetime+"</a> </th>"));    
            column_headers.append($("<th id='call_datetime'><a href=\"javascript:toggle_sort_order('"+(starting_page)+"','call_datetime')\"> "+json.columns.call_datetime+"</a> </th>"));  
            column_headers.append($("<th id='call_id_not_call_type'><a href=\"javascript:toggle_sort_order('"+(starting_page)+"','call_id_not_call_type')\"> "+json.columns.call_id_not_call_type+"</a></th>"));  
            column_headers.append($("<th id='call_type'><a href=\"javascript:toggle_sort_order('"+(starting_page)+"','call_type')\"> "+json.columns.call_type+"</a> </th>"));  
            column_headers.append($("<th id='completion_datetime'><a href=\"javascript:toggle_sort_order('"+(starting_page)+"','completion_datetime')\"> "+json.columns.completion_datetime+"</a> </th>"));  
            column_headers.append($("<th id='dispatched_datetime'><a href=\"javascript:toggle_sort_order('"+(starting_page)+"','dispatched_datetime')\"> "+json.columns.dispatched_datetime+"</a> </th>"));  
            column_headers.append($("<th id='service_id'><a href=\"javascript:toggle_sort_order('"+(starting_page)+"','service_id')\"> "+json.columns.service_id+"</a> </th>"));  
            column_headers.append($("<th id='technician_number'><a href=\"javascript:toggle_sort_order('"+(starting_page)+"','technician_number')\"> "+json.columns.technician_number+"</a> </th>"));  
            column_headers.append($("<th id='total_parts_cost'><a href=\"javascript:toggle_sort_order('"+(starting_page)+"','total_parts_cost')\"> "+json.columns.total_parts_cost+"</a> </th>"));  

            column_headers.append($("<th id='view_parts'><a>Actions</a></th>"));  

            table.append(column_headers); 

            var table_data = $("<tbody></tbody>");
            json.result_data.forEach(function(row) {
                var row_data = $("<tr></tr>");
                row_data.append($("<td>" + (row.serial_number) + " </td>")); 
                row_data.append($("<td><a href='https://www.google.com/search?tbm=isch&q="+row.model_number+"'>" + (row.model_number) + "</a></td>"));  
                row_data.append($("<td>" + (row.arrival_datetime) + " </td>"));            
                row_data.append($("<td>" + (row.call_datetime) + " </td>"));  
                row_data.append($("<td>" + (row.call_id_not_call_type) + " </td>"));  
                row_data.append($("<td>" + (row.call_type) + " </td>"));  
                row_data.append($("<td>" + (row.completion_datetime) + " </td>"));  
                row_data.append($("<td>" + (row.dispatched_datetime) + " </td>"));  
                row_data.append($("<td>" + (row.service_id) + " </td>"));  
                row_data.append($("<td>" + (row.technician_number) + " </td>")); 

                //in the event of null values for total parts cost set the default to blank string 
                var total_parts_cost = row.total_parts_cost ? ("$" + row.total_parts_cost) : "";
                var parts_cost_link = $("<td id='parts_"+row.service_id+"'><a>"+row.service_id+"</a></td>");
                parts_cost_link.on('click', function(){
                        $("#draw_popup_here").append($("<h3> Parts for "+row.service_id+"</h3>"));
                         $("#draw_popup_here").dialog({
                               model:true,
                               title:"Parts for " + row.service_id,
                                closeOnEscape: true
                         });
                });
                row_data.append(parts_cost_link);  
                
                table_data.append(row_data);
            });

           table.append(table_data);

            //message to user
            //do not display any message if there are no rows
            if( json.num_rows > 0 ) 
            {
                    var left_range = ( parseInt( starting_page ) * 100 );
                    var right_range = ( (parseInt(starting_page) * parseInt( json.total_num_rows_on_page )) + parseInt( json.total_num_rows_on_page ) );

                    if( (parseInt(json.current_page) + 1) >= parseInt(json.total_pages)) {
                        right_range = (parseInt(json.num_rows)).toString();
                    } 

                    var message = $("<p>Page " + (parseInt(json.starting_page) + 1)  + ": records <span style='color: green;'>" + (left_range).toString() + "-" + (right_range).toString()+"</span> out of "+ (parseInt(json.num_rows)).toString() + " </p>"); 
                    $("#serial_table").append(message);
            }   

            //create pagination ui
            $("#results_pagination").empty();
            var previous = $("<li><a id='page_previous' href='javascript:update_results( " + ( json.current_page  - 1 ) + ")'>&#9668</a> </li>");
            if( ( json.current_page - 1 ) < 0 ){
                previous = $("<li><a id='page_previous'>&#9668</a></li>");
            }
            $("#results_pagination").append(previous);

            for(i=0; i < json.total_pages; i++){

                //high light the active one
                if( i ==  starting_page ) {

                    var page = $("<li><a class='active' id='page" + i + "' href='javascript:update_results( " + i  + ")'>" + (i+1) + "</a></li>");
                    $("#results_pagination").append(page);

                } else {
                    var page = $("<li><a id='page" + i + "' href='javascript:update_results( " +  i + " )'>" + (i+1) + "</a></li>");
                $("#results_pagination").append(page);
               }
            }

            var next = $("<li><a id='page_next' href='javascript:update_results( " + (parseInt(json.starting_page) + 1) + " )'>&#9658</a></li>");
            if( ( parseInt( json.starting_page ) + 1 ) >= parseInt(json.total_pages)){
                next = $("<li><a id='page_next'>&#9658</a></li>");
            }
            $("#results_pagination").append(next);    
            $("#serial_table").append(table);
        }, 'json');
}
</script>
</head>
<body>

<!-- Enter serial form -->
<form role="form" role="form" method="POST" accept-charset="UTF-8">
    <div class="form-group">
      <span class="glyphicon glyphicon-search"></span>
      Serial Search: 
      <input  type="text" id="serial_search" class='form-control' autofocus autocomplete='off'>
      <div style="display='none'; display: none;" ><input type="reset" id="rst_form"></div>
    </div>
</form>       
<br>
 
 <div align="left">
<!-- Filter Date form -->
<div id="data_detected"></div>

<br>

<span>
    <label for="from">From</label>
    <input type="text" id="datepicker_start" placeholder="Enter Start Date" data-date-format='yy-mm-dd' name="from">
         <input align="right" id="clear_start_date" type="reset" value="X"/>
    </input>
</span>

<span>
    <label for="to">to</label>
    <input  type="text" data-clear-btn="true" placeholder="Enter End Date" id="datepicker_end" data-date-format='yy-mm-dd' name="to">
        <input id="clear_end_date" type="reset" value="X"/>
    </input>
</span>

<div id="start_date_filter_results_message"></div>
<div id="end_date_filter_results_message"></div>
<br>

<div id="draw_popup_here"></div>
<br>
<ul align="center" id="results_pagination" class="pagination"></ul>
<br><br>
<div id="serial_table"></div>
</div>
</body>
</html>
