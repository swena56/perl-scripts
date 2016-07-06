 <!-- use case
 [ INCLUDE section/model.tpl 
        title = ''
        message = 
        columns =
        table_data =
        draw_chart =
 %]
 -->

<style>
/* The Modal (background) */
.modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1; /* Sit on top */
    padding-top: 100px; /* Location of the box */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}

/* Modal Content */
.modal-content {
    background-color: #fefefe;
    margin: auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
}

/* The Close Button */
.close {
    color: #aaaaaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: #000;
    text-decoration: none;
    cursor: pointer;
}
</style>


<link rel="stylesheet" type="text/css" href="http://localhost/xcharts/xcharts.css">
<script type='text/javascript' src='http://localhost/xcharts/xcharts.js'/>

<figure style="width: 400px; height: 300px;" id="example3"></figure>
<!-- model functionality -->
<script type='text/javascript'>

    function view_parts_click(x){
         alert("Row index is: " + x.rowIndex);
    }
    var modal = document.getElementById('parts_model');
    var btn = document.getElementById("show_parts");
    var span = document.getElementsByClassName("close")[0];

    btn.onclick = function() {
        modal.style.display = "block"; 
    }

    // When the user clicks on <span> (x), close the modal
    span.onclick = function() {
        modal.style.display = "none";
    }

    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    } 


/*var data = {
  "xScale": "time",
  "yScale": "linear",
  "type": "line",
  "main": [
    {
      "className": ".pizza",
      "data": [
        {
          "x": "2012-11-05",
          "y": 1
        },
        {
          "x": "2012-11-06",
          "y": 6
        },
        {
          "x": "2012-11-07",
          "y": 13
        },
        {
          "x": "2012-11-08",
          "y": -3
        },
        {
          "x": "2012-11-09",
          "y": -4
        },
        {
          "x": "2012-11-10",
          "y": 9
        },
        {
          "x": "2012-11-11",
          "y": 6
        }
      ]
    }
  ]
};
var opts = {
  "dataFormatX": function (x) { return d3.time.format('%Y-%m-%d').parse(x); },
  "tickFormatX": function (x) { return d3.time.format('%A')(x); }
};
var myChart = new xChart('line', data, '#example3', opts);*/

</script> 

<h2> [% title %] </h2>
<p> [% message %] </p>
<!-- <p> [% user_input %]</p> 
<p> [% var_dump_data %]</p>

-->

<!-- Columns -->
<table  text-align='left' class='table table-hover table-responsive'>
    <tr>
        [% FOREACH i IN columns %]
            <th> [% i %] </th>
        [% END %]      
    </tr>
</table>

<!-- slurp

Inspect perl variables in template toolkit, 
-->

<div class='bodycontainer scrollable'>
    <table text-align='left' class='table table-hover table-responsive'>
      
       [% FOREACH row = table_data %]
        <tr>
            
            <td> [% row.serial_number %]</td>
            <td> [% row.meter_code %]</td>
            <td> [% row.meter_description %]</td>
            <td> [% commify(row.meter) %]</td>
            
       </tr> 
        [% END %] 
         
    </table>
</div>


<p> [% total_parts_cost %] </p>
<!-- The Modal -->
<div id="model" class="modal">
  <!-- Modal content -->
  <div class="modal-content">
    <span class="close">x</span>
  </div>
</div>