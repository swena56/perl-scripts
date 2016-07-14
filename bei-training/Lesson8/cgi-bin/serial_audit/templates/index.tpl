<!DOCTYPE html>
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

.ui-datepicker-calendar {
    display: none;
}

</style>

  <script>
   $(function() {
    
    //check what months of data are available
    var availableMonths = [];
    [% FOREACH mon IN available_months() %]
      availableMonths.push('[% mon %]');
    [% END %]

    console.log(availableMonths);

    var currentTime = new Date();
    var min = '[% available_months().first %]';
    var max = '[% available_months().last %]';

    var minDate = new Date(currentTime.getFullYear(), parseInt(min), 0); 
    console.log("minDate: ("+min+") " + minDate); 
    var maxDate =  new Date(currentTime.getFullYear(), parseInt(max), 0); 
    console.log("maxDate: ("+max+") " + maxDate);
     var month;

    /*
    $( "#datepicker" ).datepicker({ 
        dateFormat: 'yy-mm-dd',
        hideIfNoPrevNext: true,
        minDate: minDate, 
        maxDate: maxDate,
        onSelect: function(){},
        onFocus: function(){console.log('datepicker active focus');},

    });
    */
    //contains function for checking if month index exists in available months array
    function contains(a, obj) {
    var i = a.length;
    while (i--) {
       if (a[i] === obj) {
           return true;
       }
    }
    return false;
    }

    //next month button
    $(document).on('click', '.ui-datepicker-next', function () {
      var dateString = $("#datepicker").datepicker( "getDate" );
      var date = $("#datepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();        //var date = $("#datepicker").datepicker( 'getDate' );
      var m = new Date(date).getMonth();
      var next_month = (m+1).toString();
      if( contains(availableMonths,next_month ) ) {
       
        console.log('Clicked Next, dateString: '+dateString+' current: ('+ m +') ' + get_month(m) + ', next: ('+next_month+') '+get_month(next_month));
        console.log("Drawing Dashboard for: " +get_month(next_month));
        getDashBoardData(next_month);
      }
    })

    //previous month
    $(document).on('click', '.ui-datepicker-prev', function () {
        var dateString = $("#datepicker").datepicker( "getDate" );
        var date = $("#datepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();        //var date = $("#datepicker").datepicker( 'getDate' );
        var m = new Date(date).getMonth();
        var prev_month = (m-1).toString();
        if( contains(availableMonths, prev_month) ) {
          
           console.log('Clicked Previous, dateString: '+dateString+' current: ('+ m +') ' + get_month(m) + ', prev: ('+ prev_month +') ' +get_month(prev_month));  
           console.log("Drawing Dashboard for: " +get_month(prev_month));
          getDashBoardData(prev_month);
        } 
    })

    /* Initally load the last month of data */
    getDashBoardData('[% available_months().last %]');

  });
  </script>
  <script>

  function get_month(month_value) {

    var months = new Array(12);
    months[0] = "January";
    months[1] = "February";
    months[2] = "March";
    months[3] = "April";
    months[4] = "May";
    months[5] = "June";
    months[6] = "July";
    months[7] = "August";
    months[8] = "September";
    months[9] = "October";
    months[10] = "November";
    months[11] = "December";

    return months[month_value];
  }

  function getDashBoardData(month){
   
    $.post('dashboard/index.cgi', { 
          current_dashboard_data: parseInt(month),
          current_month: parseInt(month),
      }, function(response) {
          console.log("Drawing dashboard for month: "+month);
          $("#draw_dash_board_here").empty();
          $("#draw_dash_board_here").append($("<div>"+response+"</div>"));
          $( "" ).datepicker( "refresh" );
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
        <br>
        
        </div>
    </div>
[% INCLUDE section/footer.tpl %]
</body>
</html>
