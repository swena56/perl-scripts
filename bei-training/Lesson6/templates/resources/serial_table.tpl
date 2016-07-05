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
        .bodycontainer { max-height: 450px; width: 100%; margin: 0; overflow-y: auto; }
        .table-scrollable { margin: 0; padding: 0; }
        </style>
        <script type="text/javascript">
                
                function process1()
                {
                    var value_of_search = document.getElementById('user_input').value;
                    console.log('Typing: ' + value_of_search);
                    $.ajax({
                            type: 'POST',
                            url: 'get_serial.cgi',
                            data: { 'serial': value_of_search },
                            }).done(function( msg ) {
                                                        $('#result').html(msg.result );
                                                    });
                }


        <!--
        $(document).ready(function(){
        $("parts_json").click(function(){
            $("p").click();
        });
        });

        $(document).ready(function(){
            $("button").click(function(){
                $("#div1").load("index.cgi");
            });
        });
        -->
        </script>
        
        <title>Serial Audit</title>
    </head>
    <body>
    
          <div align='center' class='jumbotron'>
            <h1> [% title %] </h1>
            <p> [% guest_welcome_message %]</p> 
            <p> [% about %]</p>
            
          </div>
          
        <!-- Enter serial form -->
        <form role="form" role="form" accept-charset="UTF-8">
            <div class="form-group">
              Serial: 
              <input id="user_input" type="text" name="serial" class="form-control" onkeydown="process()" id="usr">
             
            </div>
        </form> 
        <p> [% hint %]</p><br>

       
        <div id='result'></div>
        <h3> [% table_name %] </h3>
        <p> [% message %] </p>

        <!-- Print serials table -->
        <table class='table table-hover table-responsive'>
            <tr>
                [% FOREACH column = table_columns %]
                    <th> [% column %] </th>    
                [% END %]
            </tr>
        </table>
            <div class='bodycontainer scrollable'>
                <table class='table table-hover table-responsive'>
                   
                    [% FOREACH row = table_data %]
                        <tr> 
                            [% FOREACH value = row %]
                                <td> [% value %]</td>
                            [% END %]
                         </tr> 
                    [% END %]              
                </table>
            </div>
     
        <a onclick='window.history.back()'><b> Back </b></a>
            
         
         <p> [% footer %] <p>
    </body>
</html>