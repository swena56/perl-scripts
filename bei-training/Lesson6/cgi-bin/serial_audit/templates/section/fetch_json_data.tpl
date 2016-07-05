<!--   Example useage

-->

<script>
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