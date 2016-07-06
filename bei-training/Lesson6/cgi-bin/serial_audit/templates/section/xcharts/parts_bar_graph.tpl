
<html>
<head>
<link rel="stylesheet" type="text/css" href="http://localhost/xcharts/xcharts.css">
<script src="http://localhost/xcharts/xcharts.js"></script>


</head>
<body>




<p> xchart </p>
  <p>The chart will render here!</p>

<figure style="width: 500px; height: 300px;" id="myChart"></figure>
<script>


var data1 = {
  xScale:"ordinal", 
    yScale:"linear", 
    type:"bar"
};

//post request for serial data
$.post('resources/JSON/serial_all_json.cgi', {serial:'none'}, function(json) {

    console.log("xcharts");
    console.log(json);
 
  var main_data = {
      className: "serial_number",
        data: [] 
      };
 
      
       
        json.columns.forEach(function(index){
        //   data.concat()
        });
       
        json.result_data.forEach(function(row){
           
           
        });        
                          
}, 'json');         



var data = {
  xScale:"ordinal", 
    yScale:"linear", 
    type:"bar",
  main: [
    {
      className: ".pizza",
      data: [
        {
          x: "W862LA00476",
          y: 12
        },
        {
          x: "Cheese",
          y: 8
        }
      ]
    }
  ],
  comp: [
    {
      className: ".pizza",
      type: "line-dotted",
      data: [
        {
          x: "Pepperoni",
          y: 10
        },
        {
          x: "Cheese",
          y: 4
        }
      ]
    }
  ]
};
/*console.log(main_data);*/

var myChart = new xChart('bar', data, '#myChart');
 </script>

</body>
</html>
