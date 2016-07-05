
        $(document).ready(function(){
            $("#serial_search").keyup(function(){
                
                //get user input
                var user_input = $(this).val();
                console.log(user_input);

                $('#serial_table').empty(); if(user_input == "");

                //post request for serial data
                $.post('serial_json.cgi', {serial: user_input}, function(json) {
                    console.log(json);
                    if(user_input == ""){
                        return;
                    } 

                    //header
                    var table_header = $("<table align='left' class='table table-hover table-responsive'></table>");
                    var header_row = $("<tr></tr>");
                    json.columns.forEach(function(index){
                        header_row.append($("<th>"+index+"</th>"));
                    });
                    table_header.append(header_row);

                    var div = $("<div class='bodycontainer scrollable'></div>");
                    var table_body = $("<table align='left' class='table table-hover table-responsive'></table>");
                    json.result_data.forEach(function(index){
                        var row = $("<tr></tr>");
                        var ser_id = index.pop();     
                        var valid_to_show_parts = true;
                        $(index).map(function(i) {

                            //if we have any undefined data we better not show it.
                            if (typeof(index[i]) == 'undefined' || index[i] == null){
                                index[i] = "-";
                                valid_to_show_parts = false;
                            }
                          
                            //console.log("data: "+ index[i] );
                            row.append($("<td>"+index[i]+"</td>"));
    
                        });

                        var service_action = $("<td></td>");
                         //parts List
                        if(valid_to_show_parts){
                            var table_button = $("<button id='show_parts' name='myBtn' value='"+ser_id+"' >Parts</button>").on('click', function(){
                                //display parts list
                                var modal = document.getElementById('parts_model');
                                 modal.style.display = "block";
                                var span = document.getElementsByClassName("close")[0];
                                  span.onclick = function() {
                                    modal.style.display = "none";
                                }
                                window.onclick = function(event) {
                                    if (event.target == modal) {
                                        modal.style.display = "none";
                                    }
                                } 

                                 //my cgi ajax way of getting my parts list
                                 render_parts_table(['show_parts'],['draw_parts_popup_here'], 'POST');
                            });
                            
                            service_action.append(table_button);                   
                        }

                           //parts List
                        if(valid_to_show_parts){
                            var table_button = $("<button id='show_meters_button' name='myBtn' value='"+ser_id+"' >Meters</button>").on('click', function(){
                                //display parts list
                                var modal = document.getElementById('parts_model');
                                 modal.style.display = "block";
                                var span = document.getElementsByClassName("close")[0];
                                  span.onclick = function() {
                                    modal.style.display = "none";
                                }
                                window.onclick = function(event) {
                                    if (event.target == modal) {
                                        modal.style.display = "none";
                                    }
                                } 

                                 //my cgi ajax way of getting my parts list
                                 render_meter_codes_table(['show_meters_button'],['draw_parts_popup_here'], 'POST');
                            });

                            service_action.append($("<span>   </span>"));       //spacing between buttons
                            service_action.append(table_button);
                            
                        }
                           row.append(service_action);

                        table_body.append(row);                   
                    });
                    div.append(table_body);

                //message
               
                var message;
                if(json.num_rows == 0) {
                    message = "<p> <span style='color:red;'>" + json.num_rows+ " Matches for  </span><b>" + user_input +"</b></p>" ;
                }
                else{
                    message = "<p> <span style='color:green;'>" + json.num_rows+ " Matches for  </span><b>" + user_input +"</b></p>"; 
                }

                var title = $(document.createElement("h3"));
                title.text = "Serial Data";
                $('#serial_table').empty();
                $('#serial_table').append( message );
                $('#serial_table').append( $('<h3> Service Calls </h3>') );
                $('#serial_table').append(table_header);
                $('#serial_table').append(div);
                    
                }, 'json');
                });    
            })    
            //TODO fetch service parts data via JSOn
            function get_parts()  {
                 $.post('parts_json.cgi', {serial: user_input}, function(json) {
                                    console.log(json);
                                    if(user_input == ""){
                                        return;
                                    }                                
                                 }, 'json');
            }