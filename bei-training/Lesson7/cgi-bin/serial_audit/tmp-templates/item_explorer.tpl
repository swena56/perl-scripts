<!DOCTYPE html>
<html lang="en">
    

<head>
  <link rel="stylesheet" type="text/css" href="http://www.ankerst.de/lib/itemExplorer_10.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js"></script>
  <script src="http://www.ankerst.de/lib/itemExplorer_10.min.js"></script>
</head>
<body>

   <p> Item explorer template </p>
  

  <div id='serial_chart'></div>

  <script>  
    //var myIEChart = itemExplorerChart("localhost/csv/KochBrothers-06062016-1125-TT-FIXLABOR.scrubbed");
    var myIEChart = itemExplorerChart("http://localhost/csv/items_5.csv");
    
    
      d3.select("#serial_chart")
        .append("div")
        .attr("class", "chart")
        .call(myIEChart);
    
  </script>
 </body> 
 </html>

  
