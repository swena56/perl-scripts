<!DOCTYPE html>
<html>
<head>
	<title>Dsnap - Charts</title>
	<style>
	#xaxis .domain {
		fill:none;
		stroke:#000;
	}
	#xaxis text, #yaxis text {
		font-size: 12px;
	}
	</style>
</head>
<body>
	<h2> [% title %] </h2>
	<p> [% about %] </p>
	<p> [% debug %] </p>

	<script> console.log("[% columns %]"); </script>
	<div id="wrapper">
	</div>
	<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<script>
		
var month_name = [];
[% FOREACH month IN columns %]
      month_name.push("[% month %]");
[% END %]

var numeric_data = [];
[% FOREACH value IN data %]
      numeric_data.push("[% value %]");
[% END %]


var colors = ['red','green','blue'];

var grid = d3.range(4).map(function(i){
	return {'x1':100,'y1':100,'x2':0,'y2':[% height %]};
});

var tickVals = grid.map(function(d,i){
	if(i>0){ return i*10; }
	else if(i===0){ return "100";}
});

var xscale = d3.scale.linear()
	.domain([[% min %],[% max %]])
	.range([0,[% max %]]);

var yscale = d3.scale.linear()
	.domain([0,month_name.length])
	.range([0,[% height %]]);

var colorScale = d3.scale.quantize()
	.domain([0,month_name.length])
	.range(colors);

var canvas = d3.select('#wrapper')
	.append('svg')
	.attr({'width':[% width %],'height':[% height %]});

var	xAxis = d3.svg.axis();
xAxis.orient('bottom')
	.scale(xscale)
	.tickValues(tickVals);

var	yAxis = d3.svg.axis();
	yAxis
	.orient('left')
	.scale(yscale)
	.tickSize(2)
	.tickFormat(function(d,i){ return month_name[i]; })
	.tickValues(d3.range(3));

/*My xy start position relative to the container*/
var y_xis = canvas.append('g')
	  .attr("transform", "translate(150,0)")
	  .attr('id','yaxis')
	  .call(yAxis);

var x_xis = canvas.append('g')
  .attr("transform", "translate(140,[% height %])")
  .attr('id','xaxis')
  .call(xAxis);

var chart = canvas.append('g')
	.attr("transform", "translate(150,0)")
	.attr('id','bars')
	.selectAll('rect')
	.data(numeric_data)
	.enter()
	.append('rect')
	.attr('height',16)
	.attr({'x':0,'y':function(d,i){ return yscale(i)+19; }})
	.style('fill',function(d,i){ 
		return colorScale(i); 
	}).attr('width',function(d){ 
		return 0; 
	});

var transit = d3.select("svg").selectAll("rect")
    .data(numeric_data)
    .transition()
    .duration(1000) 
    .attr("width", function(d) {
    	return xscale(d); 
    });

var transitext = d3.select('#bars')
	.selectAll('text')
	.data(numeric_data)
	.enter()
	.append('text')
	.attr({'x':function(d) {  return xscale(d)-200; },
		   'y':function(d,i){ return yscale(i)+35; }}).text(function(d)
		   { return d+"$"; }).style({'fill':'#fff','font-size':'14px'});

</script>
</body>
</html>