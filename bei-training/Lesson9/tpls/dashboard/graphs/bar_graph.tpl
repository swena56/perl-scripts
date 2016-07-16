<!--  Example useage
[ INCLUDE graphs/d3_practice.tpl 
    title = 'd3 practice graph',
    columns = ['column1', 'column2', 'column3' ],
    data = [100,200,300],
    data_type = 'calls',
    height = 500,
    width = 500,
    min = 100,
    max = 300,
 %]
-->

<!DOCTYPE html>
<html>
<head>
	
	<style>
	#xaxis .domain {
		fill:none;
		stroke:#000;
	}
	#xaxis text, #yaxis text {
		font-size: 13px;
		color: black;
	}
	</style>
</head>
<body>
	<h2> [% title %] </h2>
	<p> [% about %] </p>
	
	<script> console.log("[% columns %]"); </script>
	<div id="wrapper" width="[% width %]" height="[% height %]">
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
	return {'x1':0,'y1':0,'x2':0,'y2':[% height %]};
});

var tickVals = grid.map(function(d,i){
	if(i>0){ return i*10; }
	else if(i===0){ return "100";}
});

//xscale
var xscale = d3.scale.linear()
	.domain([0,d3.max(numeric_data)])
	.range([0,[% height %]]);

var yscale = d3.scale.ordinal()
	.domain(d3.range(0, month_name.length))
	.rangeBands([0,[% width %]], .2);

var colorScale = d3.scale.quantize()
	.domain([0,month_name.length])
	.range(colors);

var canvas = d3.select('#wrapper')
	.append('svg')
	//.attr("preserveAspectRatio", "xMinYMin meet")
	.attr({'width':[% width %],'height':[% height %]});

var	xAxis = d3.svg.axis()
	.orient('bottom')
	.scale(xscale)
	.tickFormat("[% data_type %]")
	.tickValues(tickVals);

var	yAxis = d3.svg.axis()
	.scale(yscale)
	.orient('left')
	.ticks(3)
	.tickSize(3)
	.tickPadding(3)
	.tickFormat(function(d,i){ return month_name[i]; })
	.tickValues(d3.range(month_name.length) );

/*My xy start position relative to the container
	and the size of my largest id month string
*/
var y_xis = canvas.append('g')
	  .attr("transform", "translate(50,10)")
	  .attr('id','yaxis')
	  .call(yAxis);

var x_xis = canvas.append('g')
  .attr("transform", "translate(50,[% height %])")
  .attr('id','xaxis')
  .call(xAxis);

//var r = Math.min(w, h) / 2;

var chart = canvas.append('g')
	.attr("transform", "translate(40,0)")
	.attr('id','bars')
	.selectAll('rect')
	.data(numeric_data)
	.enter()
	.append('rect')
	.attr('height',30)		/* size of my bars is relevant to how many bars I have */
	.attr({'x':10,'y':function(d,i){ return yscale(i)+10; }})
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
	.attr({'x':function(d) {  return xscale(d)-120; },
		   'y':function(d,i){ return yscale(i)+35; }}).text(function(d)
		     /*{ return  d; }).style({'fill':'#fff','font-size':'14px'});*/
			 { return d +" [% data_type %]"; }).style({'fill':'#fff','font-size':'14px'});

</script>
</body>
</html>