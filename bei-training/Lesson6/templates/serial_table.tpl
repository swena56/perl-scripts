<!DOCTYPE html>
<html lang="en">
    <head>
        <meta name="viewport" charset="UTF-8" content="width=device-width, initial-scale=1">
    
      <!-- Jquery 2.1 -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

        <!-- Optional theme -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

        <!-- Latest compiled and minified JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
        
        <style>
        .bodycontainer { max-height: 350px; width: 100%; margin: 0; overflow-y: auto; }
        .table-scrollable { margin: 0; padding: 0; }
        .jumbotron{ background : lightblue;}

                .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            padding-top: 100px; /* Location of the box */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
        }

        /* Modal Content */
        .modal-content {
            background-color: #fefefe;
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
        }

        /* The Close Button */
        .close {
            color: #aaaaaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: #000;
            text-decoration: none;
            cursor: pointer;
        }
        </style>
        <!-- <script type='text/javascript' src='resources/serial_table.js'>-->
        <script type='text/javascript'>

        function draw_table_with_json(json) {

            //header
                    var table_header = $("<table align='left' class='table table-hover table-responsive'></table>");
                    var header_row = $("<tr></tr>");
                    json.columns.forEach(function(index){
                        header_row.append($("<th>"+index+"</th>"));
                    });
                    table_header.append(header_row);

                    var div = $("<div class='bodycontainer scrollable'></div>");
                    var table_body = $("<table align='left' class='table table-hover table-responsive'></table>");

                    var valid_parts = true;         //validation should be server side, this is primary an implmentation reminder 
                    var valid_meter_codes = true;   //validation should be server side, this is primary an implmentation reminder 

                    //expecting json serial data from post request
                    json.result_data.forEach(function ( query_results ) {
                        var row = $("<tr></tr>");
                        var ser_id = query_results.pop();     
                        
                        //static table creation
                        row.append($("<td>"+query_results[0]+"</td>"));     //"serial_number"
                        row.append($("<td>"+query_results[1]+"</td>"));     //"model_number"
                        row.append($("<td>"+query_results[2]+"</td>"));     //"call_type"
                        row.append($("<td>"+query_results[3]+"</td>"));     //"completion_datetime"
                        row.append($("<td>"+query_results[4]+"</td>"));     //"technician_number"
                        row.append($("<td>"+query_results[5]+"</td>"));     //"call_id_not_call_type"
                        
                        //checking validity of cost data - no null cost means no parts
                        if (typeof(query_results[6]) != 'undefined' && query_results[6] != null){
                                 
                            var service_action = $("<td></td>");
                            service_action.append($("<span>   </span>"));       //spacing between buttons
                            
                            //render parts button                                                   
                            var parts_button = $("<button id='show_parts_"+ser_id+"' name='myBtn' value='"+ser_id+"' >Parts</button>").on('click', function() {

                                //display parts list
                                var modal = document.getElementById('parts_model');
                                modal.style.display = "block";

                                var span = document.getElementsByClassName("close")[0];

                                //model use fucntion
                                span.onclick = function() {
                                    modal.style.display = "none";
                                }

                                window.onclick = function(event) {
                                    if (event.target == modal) {
                                        modal.style.display = "none";

                                        
                                    }
                                }
                                
                                //detect escape to close popup
                                $(document).keyup(function(event) {
                                    /* Act on the event */
                                    if(event.which == 27){
                                        console.log("escape button detected");    
                                        modal.style.display = "none";
                                    }
                                });
                                 
                                 //my cgi ajax way of getting my parts list
                                 render_parts_template(['show_parts_'+ser_id],['draw_parts_popup_here'], 'POST');     

                                 //ajax is not working as well as I would like, I need to implement this in jquery  


                            }); 
                            
                            service_action.append(parts_button); 
                            
                            //render meter_codes button
                            var meter_button = $("<button id='show_meters_button_" + ser_id + "' name='myBtn' value='"+ser_id+"' >Meters</button>").on('click', function() {
                                //display parts list
                                //TODO change the meter codes so the button is not shown if there are no meter codes
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

                                //detect esacape to close popup
                                $(document).keyup(function(event) {
                                    /* Act on the event */
                                    if(event.which == 27){
                                        console.log("escape button detected");    
                                        modal.style.display = "none";
                                    }
                                });
                                    
                                 //my cgi ajax way of getting my parts list
                                 render_meter_codes_template(['show_meters_button_'+ser_id],['draw_parts_popup_here'], 'POST');
                                 //render_meter_codes_table(['show_meters_button_'+ser_id],['draw_parts_popup_here'], 'POST');

                                //ajax is not working as well as I would like, I need to implement this in jquery
                                
                            });

                            service_action.append(meter_button);     

                            row.append( $("<td>"+query_results[6]+"</td>") );              //"total_parts_cost"
                            row.append( service_action );                                   //append collection of service action buttons   
                        
                        } else {
                            row.append($("<td> - </td>"));                                //"total_parts_cost in the event of null data"
                            row.append($("<td> - </td>"));                                //place holder for not needed action buttons
                        }



                        //row.append($("<td>"+query_results[7]+"</td>"));     //"service_id"     //Do not append this,  at the moment its being used for a placeholder for the ui buttons

                        //dynamic way of creating table
                        /* $(query_results).map(function(i) {

                            //if we have any undefined data we better not show it.
                            if (typeof(query_results[i]) == 'undefined' || query_results[i] == null){
                                query_results[i] = "-";
                                valid_parts = valid_meter_codes = false;
                            }
                          
                            //console.log("data: "+ query_results[i] );
                            
                        });
                        */

                       table_body.append(row);     //append table row
                    });

                div.append(table_body);

                //message
                var message_text_color = (json.num_rows <= 0) ? 'red' : 'green' ;                      
                var message = "<p> <span style='color:" + message_text_color + ";'>" + json.num_rows+ " Matches for  </span><b>" + json.user_input +"</b></p>" ;
                
                //put everything on screen.
                var title = $(document.createElement("h3"));
                title.text = "Serial Data";
                $('#serial_table').empty();
                $('#serial_table').append( message );
                $('#serial_table').append( $('<h3> Service Calls </h3>') );
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
                $.post('serial_json.cgi', {serial: user_input}, function(json) {

                    console.log(json);

                    if(user_input != ""){
                        draw_table_with_json(json);
                    }                       
                }, 'json');

            });    
        });    
            //TODO fetch service parts data via JSOn
            function get_parts()  {
                 $.post('parts_json.cgi', {serial: user_input}, function(json) {
                                    console.log(json);
                                    if(user_input == ""){
                                        return;
                                    }                                
                                 }, 'json');
            }
        </script>
        <title>Serial Audit</title>
    </head>

    <body>
          <div align='center' id='title' class='jumbotron'>
                <h1> [% title %] </h1>
                <p> [% guest_welcome_message %]</p> 
                <p> [% about %]</p>
                <a href="https://www.beiservices.com/">Home</a>
            </div>
         
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
         
              <input  type="text" id="serial_search" class= 'form-control' action='serial_json.cgi' autofocus autocomplete='off'>
              <div style="display='none'; display: none;" ><input type="reset" id="rst_form"></div>
            </div>
        </form>       

        <div id='serial_table'></div>

         <p> [% footer %] <p>
    </body>
</html>