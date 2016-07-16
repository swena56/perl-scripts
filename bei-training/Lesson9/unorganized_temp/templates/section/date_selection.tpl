<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title> [% title %] </title>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
  <script src="//code.jquery.com/jquery-1.10.2.js"></script>
  <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"/>

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
        minDate: minDate, 
        maxDate: maxDate
    });

    $("#datepicker").on('click',function(){
      var date = $("#datepicker").datepicker( 'getDate' );
      console.log(date);
    });

  });
  </script>
</head>
<body>

  <!-- <p> Current Month: [ current_month %] </p> -->
  <div id="datepicker"></div>
</body>
</html>