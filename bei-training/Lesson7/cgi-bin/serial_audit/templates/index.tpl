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

 

  <style>
  .ui-datepicker-calendar {
      display: none;
      }
  </style>
  <script>
   $(function() {
    
    var currentTime = new Date() 
    var minDate = new Date('2016', 3-1, +1); //one day next before month
    var maxDate =  new Date(currentTime.getFullYear(), 5, -1); // one day before next month
    $( "#datepicker" ).datepicker({ 
        dateFormat: 'yy-mm-dd',
        minDate: minDate, 
        maxDate: maxDate
    });

    var mL = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    $("#datepicker").on('click',function(){
      var date = $("#datepicker").datepicker( 'getDate' );
      console.log(date);
      var date2 = $("#datepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
      var month = new Date(date2).getMonth();
      
      //dateAsObject = $.datepicker.formatDate('mm-dd-yy', new Date(dateAsObject))
      console.log("Current month from datepicker:" + month);
      getDashBoardData(month);
    });

    getDashBoardData(5);

  });
  </script>
  <script>

  function getDashBoardData(month){
   
    $.post('dashboard/index.cgi', { 
          current_dashboard_data: {month},
          current_month: {month},
      }, function(response) {
          console.log("Drawing dashboard for month: "+month);
          $("#draw_dash_board_here").empty();
          $("#draw_dash_board_here").append($("<div>"+response+"</div>"));
      });  
  }
  
  </script>
<body>
 	<div align='center'  class='jumbotron'>
    <div class="row">
        <h1> [% title %] </h1>
        <p> [% guest_welcome_message %]</p> 
        <p> [% about %]</p>
        <br>
        <div id="datepicker"></div>
       
        <div alighn='center' class="col-sm-16"> 
              <!-- Draw Dashboard -->
              <div class="col-sm-16" id="draw_dash_board_here"></div>
              
            
              <br>[% INCLUDE section/serial_audit_search.tpl %]   
        </div>
    </div>
[% INCLUDE section/footer.tpl %]
</body>
</html>
