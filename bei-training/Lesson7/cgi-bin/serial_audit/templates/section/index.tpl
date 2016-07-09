[<!DOCTYPE html>
<html lang="en">
  [% INCLUDE section/header.tpl %]
<body>
 	<div align='center'  class='jumbotron'>
    <div class="row">
       <div class="col-sm-4">
          <h1> [% title %] </h1>
            <p> [% guest_welcome_message %]</p> 
              <p> [% about %]</p>
               </div>
                  <div class="col-sm-8">
                   [% INCLUDE section/dashboard_serials.tpl %]
                  </div>
                </div>
              [% INCLUDE section/serial_audit_search.tpl %] 
    </div>  
[% INCLUDE section/footer.tpl %]
</body>
</html>
