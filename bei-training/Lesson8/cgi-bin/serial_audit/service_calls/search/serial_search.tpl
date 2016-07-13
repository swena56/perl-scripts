<!DOCKTYPE html>
<html>
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

</style>

<script>  
//initalize starting values
var selected_column = "serial_number";
var last_selected_column = "serial_number";

var starting_row = 1;
var direction = "DESC";
var user_input = "[% user_input %]";
console.log("starting user input: " + user_input);


 function export_page(){
        console.log("exporting page");

         $.post('search/serial_json.cgi', {
            search_input: user_input,
            starting_row: starting_row,
            selected_column: selected_column,
            direction: direction,
            export_csv: 'page',
        }, function(csv_response) {
            console.log(csv);
          

        }, 'csv');
    }

     function export_all(){
        console.log("exporting all");
    }

function update_results(starting_row, order_by) {
        console.log("updating results with page: " + starting_row);
        
        selected_column = order_by;

        if(selected_column == last_selected_column){
            //switch sort direction
            console.log("same column selected, switching direction");
            if(direction == "DESC"){
                direction = "ASC";
            } else if( direction == "ASC") {
                direction = "DESC";
            }
        }

        //check to make sure starting page is defined
        if(order_by){
            console.log("Order by: " + order_by + " in " + direction + " order.");
        }
        //if(starting_page)
          $.post('search/serial_json.cgi', {
            search_input: user_input,
            starting_row: starting_row,
            order_by: order_by,
            selected_column: selected_column,
            direction: direction,
        }, function(json) {
            //pass json data into results table
            last_selected_column = json.selected_column.toString();
            console.log("Debug:"+json.debug.toString());
            $("#serial_table").empty();

            var table = $("<table id='serial_table' text-align='left' class='table table-hover table-responsive '>");
            var column_headers = $("<tr></tr>"); 
            column_headers.append($("<th id='serial_number'><a href=\"javascript:update_results('"+(json.starting_row)+"','serial_number')\">"+json.columns.serial_number+"</a> </th>")); 
            column_headers.append($("<th id='model_number'><a href=\"javascript:update_results('"+(json.starting_row)+"','model_number')\">"+json.columns.model_number+"</a> </th>"));
            column_headers.append($("<th id='arrival_datetime'><a href=\"javascript:update_results('"+(json.starting_row)+"','arrival_datetime')\"> "+json.columns.arrival_datetime+"</a> </th>"));    
            column_headers.append($("<th id='call_datetime'><a href=\"javascript:update_results('"+(json.starting_row)+"','call_datetime')\"> "+json.columns.call_datetime+"</a> </th>"));  
            column_headers.append($("<th id='call_id_not_call_type'><a href=\"javascript:update_results('"+(json.starting_row)+"','call_id_not_call_type')\"> "+json.columns.call_id_not_call_type+"</a></th>"));  
            column_headers.append($("<th id='call_type'><a href=\"javascript:update_results('"+(json.starting_row)+"','call_type')\"> "+json.columns.call_type+"</a> </th>"));  
            column_headers.append($("<th id='completion_datetime'><a href=\"javascript:update_results('"+(json.starting_row)+"','completion_datetime')\"> "+json.columns.completion_datetime+"</a> </th>"));  
            column_headers.append($("<th id='dispatched_datetime'><a href=\"javascript:update_results('"+(json.starting_row)+"','dispatched_datetime')\"> "+json.columns.dispatched_datetime+"</a> </th>"));  
              
            column_headers.append($("<th id='service_id'><a href=\"javascript:update_results('"+(json.starting_row)+"','service_id')\"> "+json.columns.service_id+"</a> </th>"));  
            column_headers.append($("<th id='technician_number'><a href=\"javascript:update_results('"+(json.starting_row)+"','technician_number')\"> "+json.columns.technician_number+"</a> </th>"));  
            column_headers.append($("<th id='total_parts_cost'><a href=\"javascript:update_results('"+(json.starting_row)+"','total_parts_cost')\"> "+json.columns.total_parts_cost+"</a> </th>"));  

            table.append(column_headers); 

            var table_data = $("<tbody></tbody>");
            json.result_data.forEach(function(row){
              
                var row_data = $("<tr></tr>");
                row_data.append($("<td>" + (row.serial_number) + " </td>")); 
                row_data.append($("<td>" + (row.model_number) + " </td>"));  
                row_data.append($("<td>" + (row.arrival_datetime) + " </td>"));            
                row_data.append($("<td>" + (row.call_datetime) + " </td>"));  
                row_data.append($("<td>" + (row.call_id_not_call_type) + " </td>"));  
                row_data.append($("<td>" + (row.call_type) + " </td>"));  
                row_data.append($("<td>" + (row.completion_datetime) + " </td>"));  
                row_data.append($("<td>" + (row.dispatched_datetime) + " </td>"));  
                
                row_data.append($("<td>" + (row.service_id) + " </td>"));  
                row_data.append($("<td>" + (row.technician_number) + " </td>"));  
                row_data.append($("<td>" + (row.total_parts_cost) + " </td>"));  
                table_data.append(row_data);
            });

           table.append(table_data);
           if(json.num_rows > 0){
            if((json.starting_row*100) > json.num_rows){
                var message = $("<p>Current Set: <span style='color: green;'>"+(json.num_rows) + "</span> out of "+json.num_rows.toString()+"</p>"); 
                 $("#serial_table").append(message);
            } else {
                var message = $("<p>Current Set: <span style='color: green;'>"+(json.starting_row*100) + "</span> out of "+json.num_rows.toString()+"</p>"); 
                 $("#serial_table").append(message);
            }
                
           } 
           
           // var page = $("<li><a id='page' href='javascript:DoPost("+i+","+json.order_by.toString()+","+json.direction.toString()+","+user_input+")'>"+i+"</a></li>");
            //append pagination
            $("#results_pagination").empty();
            var previous = $("<li><a id='page_previous' href='javascript:update_results("+(parseInt(json.starting_row) - 1)+")'>&#9668</a></li>");
            $("#results_pagination").append(previous);
            for(i=1; i <= json.total_pages; i++){

               //high light the active one
               if(i == json.starting_row){
                var page = $("<li><a class='active' id='page"+i+"' href='javascript:update_results("+(i)+")'>"+i+"</a></li>");
                $("#results_pagination").append(page);
               } else {
                var page = $("<li><a id='page"+i+"' href='javascript:update_results("+(i)+")'>"+i+"</a></li>");
                $("#results_pagination").append(page);
               }
               
            }
            var next = $("<li><a id='page_next' href='javascript:update_results("+(parseInt(json.starting_row) + 1)+")'>&#9658</a></li>");
            $("#results_pagination").append(next);
            $("#serial_table").append(table);

        }, 'json');
}

$(document).ready(function(){
    
   

    $("#serial_search").keyup(function(event){
        //get user input
        user_input = $(this).val();

        if(event.which == 27 || user_input == ""){
            console.log("escape button detected- changing focus to search: "+  $(this).val());                        
            $('#rst_form').click();  //clear form
            $('#serial_table').empty();
            $("#serial_search").focus();
            return;
        }

       update_results(starting_row, selected_column, direction);
    });  


 
  
});    



</script>

<!-- Enter serial form -->
<form role="form" role="form" method="POST" accept-charset="UTF-8">
    <div class="form-group">
      Serial Search: 
 
      <input  type="text" id="serial_search" class='form-control' autofocus autocomplete='off'>
      <div style="display='none'; display: none;" ><input type="reset" id="rst_form"></div>
    </div>
</form>       
<br>

<br>
<ul id="results_pagination" class="pagination"></ul>

 <div id="serial_table"></div>



</html>