<!DOCTYPE html>
<html>
<head>
<!--  Example useage
[ INCLUDE graphs/d3_practice.tpl 
    title = 'd3 practice graph',
    columns = ['column1', 'column2', 'column3' ],
    data = [100,200,300],
    data_type = 'calls',
    height = 500,
    width = 500,

 %]
-->
	<style>
	
		.axis path,
		.axis line {
			fill:none;
			stroke:#000;
			shape-rendering: crispEdges;
		}

		h1{
			text-align: center;

		}
	</style>
</head>
<body>
	<h2> [% title %] </h2>
	<p> [% about %] </p>
	
	<p> Scatter plot - weight by gender</p>
	<script> console.log("[% columns %]"); </script>
	<div id="svg"></div>

	<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
	<script type='text/javascript'>
		

	var colors = d3.scale.category10();

	var margin = {
		top: 20,
		right: 20,
		bottom: 30,
		left: 40
	};
	
//Data
	var data = [
	  {h: 66, w: 100, gender: 'female', age: 20},
	  {h: 46, w: 140, gender: 'male', age: 21},
	  {h: 76, w: 120, gender: 'female', age: 22},
	  {h: 86, w: 160, gender: 'male', age: 25}
  	];

	var width = 300 - margin.left - margin.right;
	var height = 500 - margin.top - margin.bottom;

	var x_value = function(d){
		return d.height;
	}

	var x_scale = d3.scale.linear()
		.range([0,width]);

	var x_map = function(d){
		return x_scale(x_value(d))
	};

	var x_axis =  d3.svg.axis()
		.scale(x_scale)
		.orient('bottom');


	var y_value = function(d){
		return d.width;
	};

	var y_scale = d3.scale.linear()
		.range([height,0]);

	var y_map = function(d){
		return y_scale(y_value(d));
	};

	var y_axis =  d3.svg.axis()
		.scale(y_scale)
		.orient('left');

	//colors
	var color_value = function(d){
		return d.gender;
	};

	//canvas
	var svg = d3.select('#svg').append('svg')
		.attr('width', width +  margin.left + margin.right)
		.attr('height', width +  margin.top + margin.bottom)
		.style('background', 'grey')
		.style('width', '100%')
		.style('padding-left', '200px')
		.append('g')
		.attr('transform', 'translate('+margin.left+','+margin.top+')');


	


	data.forEach(function(d){
		console.log(d);
		d.h = +d.h;
		d.w = +d.w;
	});
	
	//x_scale.domain(data.map(function(d) { return d.h; }));


	x_scale.domain([d3.min(data, x_value) -1], d3.max(data, x_value)+1);
	y_scale.domain([d3.min(data, y_value) -1], d3.max(data, y_value)+1);

	svg.append('g')
		.attr('class','x axis')
		.attr('transform','translate(0,'+h+')')
		.call(x_axis)
	.append('text')
		.attr('class', 'label')
		.attr('x', width)
		.attr('y', -6)
		.style('text-anchor', 'end')
		.text('height')

	svg.append('g')
		.attr('class','y axis')
		.call(y_axis)
	.append('text')
		.attr('class', 'label')
		.attr('transform','rotate(-90)')
		.attr('dy', '.71em')
		.attr('y', 6)
		.style('text-anchor', 'end')
		.text('weight')

	svg.selectAll('.dot')
		.data(data)
		.enter().append('circle')
		.attr('class', 'dot')
		.attr('r', 3.5)
		.attr('cx', x_map)
		.attr('cy', y_map)
		.style('fill', function(d){
			return color(c_value(d))
		})



	</script>
	
</body>
</html>