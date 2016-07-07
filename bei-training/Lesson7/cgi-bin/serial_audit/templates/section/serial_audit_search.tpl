 <style>
        .bodycontainer { max-height: 350px; width: 100%; margin: 0; overflow-y: auto; }
        .table-scrollable { margin: 0; padding: 0; }
</style>

  <script type='text/javascript'>

        function draw_table_with_json(json) {

            
        var table_header = $("<table text-align='left' class='table table-hover table-responsive'></table>");
        var header_row = $("<tr></tr>");
        json.columns.forEach(function(index){
            header_row.append($("<th>"+index+"</th>"));
        });
        table_header.append(header_row);

       
        var table_body = $("<table text-align='left' class='table table-hover table-responsive'></table>");

        var valid_parts = true;         //validation should be server side, this is primary an implmentation reminder 
        var valid_meter_codes = true;   //validation should be server side, this is primary an implmentation reminder 
        console.log(json);
        //expecting json serial data from post request
        json.result_data.forEach(function ( query_results ) {
            var row = $("<tr></tr>");
           
            row.append($("<td>"+query_results.service_id+"</td>")); 
            row.append($("<td>"+query_results.serial_number+"</td>"));   
            row.append($("<td>"+query_results.model_number+"</td>"));   
            row.append($("<td>"+query_results.call_type+"</td>"));   
            row.append($("<td>"+query_results.completion_datetime+"</td>"));   
            row.append($("<td>"+query_results.technician_number+"</td>"));   
            row.append($("<td>"+query_results.call_id_not_call_type+"</td>"));   
            row.append($("<td>"+query_results.total_parts_cost+"</td>")); 
           
            var service_action = $("<td></td>");

            var parts_button = $("<button id='show_parts_"+query_results.service_id+"' value='"+query_results.service_id+"' name='myBtn'>Parts</button>").on('click', function() {
 
                var modal = document.getElementById('parts_model');
                modal.style.display = "block";

                var span = document.getElementsByClassName("close")[0];

                //model use fucntion
                span.onclick = function() {
                    modal.style.display = "none";
                }
                
                //detect escape to close popup
                $(document).keyup(function(event) {
                    /* Act on the event */
                    if(event.which == 27){
                        console.log("escape button detected");    
                        modal.style.display = "none";
                    }
                });

                render_parts_template(['show_parts_'+query_results.service_id],['draw_parts_popup_here'], 'POST'); 
                
            }); 
                      
            service_action.append($("<span>               </span>"));
             if(query_results.total_parts_cost){
            service_action.append(parts_button);    
            }
            row.append( service_action );
            table_body.append(row);     //append table row  
        });                   


        var div = $("<div class='bodycontainer scrollable'></div>");
         div.append(table_body);
        //message
        var message_text_color = (json.num_rows <= 0) ? 'red' : 'green' ;                      
        var message = "<p> <span style='color:" + message_text_color + ";'>" + json.num_rows+ " Matches for  </span><b>" + json.user_input +"</b></p>" ;
        
        //put everything on screen.
        var title = $(document.createElement("h3"));
        title.text = "Serial Data";
        $('#serial_table').empty();
        $('#serial_table').append( message );
        $('#serial_table').append( $('<h3> Service Calls </h3><br>') );
        $('#serial_table').append(table_header);
        $('#serial_table').append(div);
        }

        $(document).ready(function(){


            $("#serial_search").keyup(function(event){
                
                //get user input
                var user_input = $(this).val();
                console.log(user_input);

                if(event.which == 27 || user_input == ""){
                    console.log("escape button detected- changing focus to search: "+  $(this).val());                        
                    $('#rst_form').click();  //clear form
                    $('#serial_table').empty();
                    $("#serial_search").focus();
                    return;
                }

                //post request for serial data
                $.post('resources/JSON/serial_json.cgi', {serial: user_input}, function(json) {

                    console.log(json);

                    if(user_input != ""){
                        draw_table_with_json(json);
                    }                       
                }, 'json');

            });    
        });    
            

            
        </script>

        <!-- popup modal -->
        <div id="parts_model" class="modal">

          <!-- model container -->
          <div class="modal-content">
            <span class="close">x</span>
             <div id="draw_parts_popup_here"></div>
          </div>
        </div>

           <!-- Enter serial form -->
        <form role="form" role="form" method="POST" accept-charset="UTF-8">
            <div class="form-group">
              Serial Search: 
         
              <input  type="text" id="serial_search" class='form-control' action='resources/JSON/serial_json.cgi' autofocus autocomplete='off'>
              <div style="display='none'; display: none;" ><input type="reset" id="rst_form"></div>
            </div>
        </form>       
        <br>
        <div id='serial_table'></div>
