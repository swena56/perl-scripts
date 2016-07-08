<!DOCTYPE html>
<html lang="en">
 <head>
        <meta name="viewport" charset="UTF-8" content="width=device-width, initial-scale=1">
        [% INCLUDE section/external_sources.tpl %]

        <title>[% title %] </title>
</head>
    <body>
        [% INCLUDE section/header.tpl %]


    	<div align='center'  class='jumbotron'>

                <h1> [% title %] </h1>
                <p> [% guest_welcome_message %]</p> 
                <p> [% about %]</p>
                
                [% INCLUDE section/dashboard_serials.tpl %]
                [% INCLUDE section/serial_audit_search.tpl %] 
    	</div>  

		
    		
          
        
        [% INCLUDE section/footer.tpl %]
    </body>
</html>
