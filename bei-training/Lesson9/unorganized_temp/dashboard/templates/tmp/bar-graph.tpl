
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<style>

body {
  font-family: "Exo 2", sans-serif;
  background: #DDD;
  color: #333;
}

h1 {
  margin: 0;
  padding: 0.1rem 0.4rem;
  font-size: 1rem;
  font-weight: 500;
  text-align: right;
}

.widget {
  display: inline-block;
  border: 1px solid #AAA;
  background: white;
}

#chart {
  height: 400px;
  width: 500px;
}

svg {
  shape-rendering: crispEdges;
}

.bar {
  fill: #A18FDB;
}

.value {
  font-size: 16px;
  font-weight: 300;
  fill: #333;
}

.label {
  font-size: 18px;
  fill: #333;
}

.axis {
  path {
    fill: none;
    //stroke: #333;
  }
  .tick line {
    stroke-width: 1;
    stroke: rgba(0,0,0,0.1);
  }
  //fill: #333;
  font-size: 12px;
}

</style>


<script>


var month_name = [];
[% FOREACH month IN columns %]
      month_name.push("[% month %]");
[% END %]
console.log(month_name);

var numeric_data = [];
[% FOREACH value IN data %]
      numeric_data.push("[% value %]");
[% END %]
console.log(numeric_data);

var data = [
  ["oranges",2312],
  ["mangos",674], 
  ["limes", 994], 
  ["apples", 3433], 
  ["strawberries", 127],
  ["blueberries",2261]
];

var chart = document.getElementById("chart"),
    axisMargin = 20,
    margin = 20,
    valueMargin = 4,
    width = chart.offsetWidth,
    height = chart.offsetHeight,
    barHeight = (height-axisMargin-margin*2)* 0.4/data.length,
    barPadding = (height-axisMargin-margin*2)*0.6/data.length,
    data, bar, svg, scale, xAxis, labelWidth = 0;

max = d3.max(data.map(function(i){ 
  return i[1];
}));

svg = d3.select(chart)
  .append("svg")
  .attr("width", width)
  .attr("height", 400);


bar = svg.selectAll("g")
  .data(data)
  .enter()
  .append("g");

bar.attr("class", "bar")
  .attr("cx",0)
  .attr("transform", function(d, i) { 
     return "translate(" + margin + "," + (i * (barHeight + barPadding) + barPadding) + ")";
  });

bar.append("text")
  .attr("class", "label")
  .attr("y", barHeight / 2)
  .attr("dy", ".35em") //vertical align middle
  .text(function(d){
    return d[0];
  }).each(function() {
    labelWidth = Math.ceil(Math.max(labelWidth, this.getBBox().width));
  });

scale = d3.scale.linear()
  .domain([0, max])
  .range([0, width - margin*2 - labelWidth]);

xAxis = d3.svg.axis()
  .scale(scale)
  .tickSize(-height + 2*margin + axisMargin)
  .orient("bottom");

bar.append("rect")
  .attr("transform", "translate("+labelWidth+", 0)")
  .attr("height", barHeight)
  .attr("width", function(d){
    return scale(d[1]);
  });

bar.append("text")
  .attr("class", "value")
  .attr("y", barHeight / 2)
  .attr("dx", -valueMargin + labelWidth) //margin right
  .attr("dy", ".35em") //vertical align middle
  .attr("text-anchor", "end")
  .text(function(d){
    return d[1];
  })
 .attr("x", function(d){
    var width = this.getBBox().width;
    return Math.max(width + valueMargin, scale(d[1]));
  });

svg.insert("g",":first-child")
 .attr("class", "axis")
 .attr("transform", "translate(" + (margin + labelWidth) + ","+ (height - axisMargin - margin)+")")
 .call(xAxis);
</script>

<div class="widget">
  <h1>My chart</h1>
  <p> [% debug1 %] </p>
  <div id="chart"></div>  
</div