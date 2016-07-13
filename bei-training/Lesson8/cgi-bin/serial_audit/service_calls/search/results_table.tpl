

<p> Hello world results table Debug Data: [% json %] </p>

<table id="serial_table" text-align='left' class='table table-hover table-responsive tablesorter'>
<thead> 
 <tr> 
     <th id='serial_number' value="desc"> Serial Number [% get_direction_symbol('serial_number') %]</th>
     <th id='model_number'> Model Number [% get_direction_symbol('model_number') %]</th>
     <th id='call_type'> Call Type</th>
     <th id='call_datetime'> Call Date/Time</th>
     <th id='dispatched_datetime'> Dispatched Date/Time</th>
     <th id='arrival_datetime'> Arrival Date/Time</th>
     <th id='completion_datetime'> Completion Date/Time</th>
     <th id='technician_number'> Tech # </th>
     <th id='total_parts_cost'> Total Parts Cost</th>
 </tr>
 </thead> 
 <tbody>

[% FOREACH row = table_data %]
<tr>
    <td> [% row.serial_number %]</td>
    <td> [% row.model_number %]</td>
    <td> [% row.call_type %]</td>
    <td> [% row.call_datetime %]</td>
    <td> [% row.dispatched_datetime %]</td>
    <td> [% row.arrival_datetime %]</td>
    <td> [% row.completion_datetime %]</td>
    <td> [% row.technician_number %]</td>
    <td> [% row.total_parts_cost %]</td>
</tr> 
[% END %] 
        
</tbody>
</div>  
</table>


<script>
 $(document).ready(function(){
        console.log("My json Data in results table: [% json %]");
    var number_responses = "[% num_results %]";
    console.log("Number of results for [% search %]: " + number_responses + "{ order_by: [% order_by%] }");

    var selected_column = 'model_number';
    //column selection
   $("#serial_number").on('click', function(){
        var current_text = $("#serial_number").text();
        selected_column = 'serial_number';
        console.log("serial_number click- current text: " + current_text);

       // $("#serial_number").text(current_text+ "[% get_direction_symbol('serial_number') %]");
        update_results();
    });

   $("#model_number").on('click', function(){
        var current_text = $("#model_number").text();
        selected_column = 'model_number';
        console.log("model_number click- current text: " + current_text);

        update_results();
    });

  
 });

</script>

      
   
