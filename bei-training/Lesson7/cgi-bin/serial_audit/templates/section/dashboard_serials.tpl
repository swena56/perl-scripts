<!-- <!DOCTYPE html>
<meta charset="utf-8">-->
<style>
  body{
      width:1060px;
      margin:50px auto;
  }
  path {  stroke: #fff; }
  path:hover {  opacity:0.9; }
  rect:hover {  fill:blue; }
  .axis {  font: 10px sans-serif; }
  .legend tr{    border-bottom:1px solid grey; }
  .legend tr:first-child{    border-top:1px solid grey; }

  .axis path,
  .axis line {
    fill: none;
    stroke: #000;
    shape-rendering: crispEdges;
  }

  .x.axis path {  display: none; }
  .legend{
      margin-bottom:76px;
      display:inline-block;
      border-collapse: collapse;
      border-spacing: 0px;
  }
  .legend td{
      padding:4px 5px;
      vertical-align:bottom;
  }
  .legendFreq, .legendPerc{
      align:right;
      width:50px;
  }

  .dashboard{
      border: 1px solid blue;
      outline-color: blue; 
      background-color: lightgrey;
  }
</style>

<script type='text/javascript' src='xcharts/xcharts.js'></script>
<div id='dashboard'></div>
<script src="http://d3js.org/d3.v3.min.js"></script>
<link rel='stylesheet' type='text/css/' href='http://localhost/xcharts/xcharts.css'>

<script>
  $.post("resources/JSON/serial_all_json.cgi", {}, function(json){

    console.log("returning json data");
    console.log(json);
    if(json.num_rows > 0){

      console.log("Found " + json.num_rows + " results- should be all serial numbers in database.");

      var num_serials = $("<p> Number of Serial Numbers in database: " + json.num_rows + "</p>");
      $("#dashboard").append($("<h3> Serial Analytic Data Dashboard </h3>"));
      $("#dashboard").append(num_serials);
    }
  });
</script>

<div class='dashboard' id='dashboard'></div> 

<br><br>


<!-- Get All Serial Data in Json -->


