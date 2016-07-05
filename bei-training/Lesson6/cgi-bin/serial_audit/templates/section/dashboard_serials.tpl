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

</style>
<!--body-->
<div id='dashboard'>
</div>
<script src="http://d3js.org/d3.v3.min.js"></script>


<script>

$.post("serial_all_json.cgi", {}, function(json){

  console.log("returning json data");
  console.log(json);
});


</script>
<h3> Serial Data Dashboard </h3>
<p> </p>


<!-- Get All Serial Data in Json -->


