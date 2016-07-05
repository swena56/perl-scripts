<!--    Usage example
        [ INCLUDE section/table.tpl 
            title = 'Service Calls',
            message = 'generate table from json',
            table_columns = [ 'c1','c2','c3' ],
            table_data = [ ['d1','d2','d3'],['d1','d2','d3'],['d1','d2','d3']],
            json = 'serial_json.cgi',
            fetch_input = 'w8'
        %] 
      -->

<div id='result'></div>
<h3> [% table_name %] </h3>
<p> [% message %] </p>

<script type='text/javascript'>
    



var user_input = "[% fetch_input %]";
var json_data_src = "[% json %]" ;

console.log("UserInput: "+user_input);
console.log("UserInput: "+json_data_src);

//post request for serial data
$.post(json_data_src, {serial: user_input}, function(json) {

    console.log("Receieved Data from "+ json_data_src);
    console.log(json);

    if(user_input != ""){   
        json.columns.forEach(function(index){
            $("#table_header").append($("<th>"+index+"</th>"));
        });
       
        json.result_data.forEach(function(row){
            var new_row = $("<tr> </tr>");
            row.forEach(function(index){
                new_row.append($("<td>"+index+"</td>"));    
            });
            $("#table_body").append(new_row);
        });        
    }                       
}, 'json');                        
        
</script>

<p> Drawing table from [% json %] </p>
<br><h3> [% title %] </h3>

<!-- Columns -->
<table class='table table-hover table-responsive'>
    <tr id="table_header">
        [% FOREACH i = table_columns %]
            <th> [% i %] </th>
        [% END %]      
    </tr>
</table>

<div class='bodycontainer scrollable'>
    <table id="table_body" class='table table-hover table-responsive'>
      
       [% FOREACH row = table_data %]
        <tr>
            
            [% FOREACH i = row %]
               <td>    [% i %]   </td>
            [% END %]
           
       </tr> 
        [% END %] 
         
    </table>
</div>