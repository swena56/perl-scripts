[<!DOCTYPE html>
<html lang="en">
  [% INCLUDE section/header.tpl %]

<style>
#block_container
{
    text-align:center;
}
#previous_month, #next_month
{
    display:inline;
}
</style>
  <script>

  function getDashBoardData(current_month){
    $.post('dashboard/index.cgi', { 
          current_dashboard_data: {current_month},
          current_month: {current_month},
      }, function(response) {
          $("#draw_dash_board_here").empty();
          $("#draw_dash_board_here").append($("<div>"+response+"</div>"));
      });  
  }

  $(document).ready(function(){
      
    var current_month = parseInt("[% available_months.last %]");
    console.log("Current month: "+ current_month);

    //initally set current month display
    $("#current_month").text("Current Month: "+ current_month);

    //draw dashboard
    getDashBoardData(current_month);
    //detech previous month change button
    $("#previous_month").on('click', function(){
      console.log("previous month click");
      current_month--;
       getDashBoardData(current_month);
    });

    //detech next month change button
    $("#next_month").on('click', function(){
        current_month++;
       getDashBoardData(current_month);
    });

    //post request based on month data.
    

      console.log("document ready draw dashboard");
      
  });
  </script>
<body>
 	<div align='center'  class='jumbotron'>
    <div class="row">
        <h1> [% title %] </h1>
        <p> [% guest_welcome_message %]</p> 
        <p> [% about %]</p>
        <br>
        <div alighn='center' class="col-sm-16"> 
              <!-- Draw Dashboard -->
            <div id="block_container">
              <h3 id='current_month'></h3>
              <div  class="pager previous"><a id="previous_month" href="">Previous</a></div>
              <div class="pager next"><a id="next_month" href="">Next</a></div>
            </div>
            <div class="col-sm-16" id="draw_dash_board_here"></div>
              [% INCLUDE section/serial_audit_search.tpl %]   
        </div>
    </div>
[% INCLUDE section/footer.tpl %]
</body>
</html>
