
  <meta name="viewport" charset="UTF-8" content="width=device-width, initial-scale=1"/>
  
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.0/themes/base/jquery-ui.css">
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.0/jquery-ui.js"></script>
<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>-->

  <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

  <!-- Optional theme -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

  <!-- Latest compiled and minified JavaScript -->
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

  <!--d3 dashboard -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js"></script>


   <link rel="stylesheet" href="//code.jquery.com/ui/1.12.0/themes/base/jquery-ui.css">
     <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
     <script src="https://code.jquery.com/ui/1.12.0/jquery-ui.js"></script>
<style>

</style>
<!--
.active {
    text-decoration: none;
    color: black;
    background-color: white;
}
/* The Modal (background) */
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
-->
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
      <li><a  href="/cgi-bin/serial_audit/"> Home </a></li>
      <li class="active dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">Service Calls<span class="caret"></span></a>
        <ul class="dropdown-menu">
          <li><a href="javascript:export_page()">Export Page</a></li>
          <li><a href="javascript:export_all()">Export All</a></li>
        </ul>
      </li>
    </ul>
  </div>
</nav>



