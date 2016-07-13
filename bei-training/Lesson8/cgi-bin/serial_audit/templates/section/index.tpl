<!DOCTYPE html>
<html lang="en">
  [% INCLUDE section/header.tpl %]
  <script>
  $(document).ready(function(){
      
    var current_month = parseInt("[% available_months.last %]");
    console.log("Current month: "+ current_month);

    //initally set current month display
    $("#current_month").text("Current Month: "+ current_month);

    //detech previous month change button
    $("#previous_month").on('click', function(){});

    //detech next month change button
    $("#next_month").on('click', function(){});

    //post request based on month data.
      console.log("document ready draw dashboard");
      $.post('dashboard/index.cgi', { 
          get_dashboard: {'true'},
          current_month: {current_month},
      }, function(response) {
          $("#draw_dash_board_here").empty();
          $("#draw_dash_board_here").append($("<div>"+response+"</div>"));
      });  
  });
  </script>
<body>
 	<div align='center'  class='jumbotron'>
    <div class="row">
      <h1> [% title %] </h1>
          <p> [% guest_welcome_message %]</p> 
          <p> [% about %]</p>
       <div class="col-sm-6">
          [% INCLUDE section/serial_audit_search.tpl %]   
        </div>
        <div class="col-sm-6">
          <!-- Draw Dashboard -->
          <div class='pager' id="month_selection">
            <h3 id='current_month'></h3>
            <div align='left' class="previous"><a href="">Previous</a></div>
            <div align='right' class="next"><a id="next_month" href="">Next</a></div>
          </div>
          <div id="draw_dash_board_here"></div>
          
        </div>
    </div>
  </div>

[% INCLUDE section/footer.tpl %]
</body>
</html>
