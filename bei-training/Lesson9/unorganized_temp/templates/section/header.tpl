
  <meta name="viewport" charset="UTF-8" content="width=device-width, initial-scale=1">
  

 <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

  <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

  <!-- Optional theme -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

  <!-- Latest compiled and minified JavaScript -->
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

  <!--d3 dashboard -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js"></script>
  
<style>

.active {
    text-decoration: none;
    color: black;
    background-color: white;
}
</style>

<nav class="navbar navbar-inverse">
  <div class="container-fluid">
     <div class="navbar-header">
      <li class="navbar-brand dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">&#9776;<span class="caret"></span></a>
        <ul class="dropdown-menu">
          <li><a>Dashboard</a></li>
          <li><a href="">Total Parts</a></li>
          <li><a href="">Total Calls</a></li>
        </ul>
      </li>
    </div>
    <ul class="nav navbar-nav">
      <li class='active'><a href="/cgi-bin/serial_audit/">Home</a></li>
      <li class="dropdown"><a href="/cgi-bin/serial_audit/service_calls/">Service Calls</a>
      </li>
    </ul>
  </div>
</nav>