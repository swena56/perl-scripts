
<html>
<head>

<script src="http://static.fusioncharts.com/code/latest/fusioncharts.js"></script>


</head>
<body>




<p> Fusion Chart </p>
<div id="chart-container">
  <p>The chart will render here!</p>
</div>

<script>

var parsedData = {
    "chart": {
        "caption": "Half Yearly Revenue Analysis",
        "subcaption": "Harry's SuperMart",
        "yaxisname": "Revenue",
        "numberprefix": "$",
        "yaxismaxvalue": "250000",
        "rotatevalues": "0",
        "theme": "zune",
        "palettecolors": "grey"
    },
    "data": [
        {
            "label": "Jul",
            "value": "150000",
            "tooltext": "Occupancy: 67%{br}Revenue: $150,000{br}3 conferences hosted!"
        },
        {
            "label": "Aug",
            "value": "130000",
            "tooltext": "Occupancy: 64%{br}Revenue: $130,000{br}Lean summer period!"
        },
        {
            "label": "Sep",
            "tooltext": "Occupancy: 44%{br}Revenue: $80,000{br}Reason: Renovating the Lobby",
            "value": "95000"
        },
        {
            "label": "Oct",
            "value": "170000",
            "tooltext": "Occupancy: 73%{br}Revenue: $170,000{br}Anniversary Discount: 25%"
        },
        {
            "label": "Nov",
            "value": "155000",
            "tooltext": "Occupancy: 70%{br}Revenue: $155,000{br}2 conferences cancelled!"
        },
        {
            "label": "Dec",
            "value": "230000",
            "tooltext": "Occupancy: 95%{br}Revenue: $230,000{br}Crossed last year record!"
        }
    ]
};

new FusionCharts({
  type: 'bar2d',
  renderAt: 'chart-container',
  width: '100%',
  height: '300',
  dataFormat: 'json',
  dataSource: {
    "chart": {
      "caption": "Highest Paid Actors",
      "yAxisName": "Annual Income (in milion USD)",
      "numberPrefix": "$"
    },
  "data": parsedData
  }
}).render();
 </script>

</body>
</html>
