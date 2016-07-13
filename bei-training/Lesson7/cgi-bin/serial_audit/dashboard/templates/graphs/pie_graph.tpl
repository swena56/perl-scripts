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
	
	</style>
</head>
<body>
	<h2> [% title %] </h2>
	<p> [% about %] </p>
	
	<script> console.log("[% columns %]"); </script>
	<div id="chart"></div>

	<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
	<script type='text/javascript'>
		
	var width = 400;
	var height = 400;
	var radius = 200;
	var colors = d3.scale.category10();

	var month_names = [];
	[% FOREACH month IN columns %]
      month_names.push("[% month %]");
	[% END %]
	console.log(month_names);

	var numeric_data = [];
	[% FOREACH value IN data %]
	      numeric_data.push("[% value %]");
	[% END %]
	console.log(numeric_data);


	var pieData = [];
	if(month_names.length == numeric_data.length)
	{
		for(i=0; i < month_names.length; i++){
			pieData.push({ 
							month: month_names[i], 
						   	amount: numeric_data[i] 
						});
		}
	}

	var pie = d3.layout.pie()
		.value(function(d){
			return d.amount;
		});

	var arc = d3.svg.arc()
		.outerRadius(radius);

	var chart = d3.select('#chart').append('svg')
		.attr('width', width)
		.attr('height', height)
		.append('g')
			.attr('transform', 'translate('+(width-radius)+','+(height-radius)+')')
			.selectAll('path')
			.data(pie(pieData))
			.enter()
			.append('g')
				.attr('class', 'slice');

	var slices = d3.selectAll('g.slice')
		.append('path')
			.attr('fill', function(d,i){
				return colors(i);
			})
			.attr('d', arc);

	var text = d3.selectAll('g.slice')
		.append('text')
		.text(function(d,i){
			return ( d.data.month + " - " + d.data.amount + " [% data_type %]" )
		})
		.attr('text-anchor', 'middle')
		.attr('fill', 'white')
		.attr('transform', function(d){
			d.innerRadius = 0;
			d.outerRadius = radius;
			return 'translate('+arc.centroid(d)+')'
		});


	</script>
	
</body>
</html>