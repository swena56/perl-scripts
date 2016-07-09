 <head>
<meta name="viewport" charset="UTF-8" content="width=device-width, initial-scale=1">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

  <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

  <!-- Optional theme -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

  <!-- Latest compiled and minified JavaScript -->
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

  <!--d3 dashboard -->
  <link rel="stylesheet" type="text/css" href="http://www.ankerst.de/lib/itemExplorer_10.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js"></script>
  <script src="http://www.ankerst.de/lib/itemExplorer_10.min.js"></script>
  <!-- xcharts 
  <link rel="stylesheet" type="text/css" href="http://localhost/xcharts/xcharts.css">
  <script type='text/javascript' src='http://localhost/xcharts/xcharts.js'/>
  http://lesscss.org/features/
  <script src="//cdnjs.cloudflare.com/ajax/libs/less.js/2.6.1/less.min.js"></script>-->

<style>
a { 
    text-decoration: none;
     }
a:hover{
    text-decoration: none;
}
.dashboard_link {text-decoration: none;}

ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    background-color: black;
}

li {
    float: left;
}

li a {
    display: block;
    color: white;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;

}
.title{
    border: 1px solid white;
    outline-color: black; 
    background-color: white;
}
.jumbotron{
    background-color: white;
   
}
li a:hover:not(.active) {

    background-color: white;
}
.active {
    text-decoration: none;
    color: black;
    background-color: white;
}
</style>
</head>
<div class='title'>
  <ul>
     <li><b><a class='dashboard_link' href="http://localhost/cgi-bin/serial_audit/">Home</a></b></li>
     <li><b><a class="active" href="">[% title %] </a></b></li>
  </ul>
</div>
