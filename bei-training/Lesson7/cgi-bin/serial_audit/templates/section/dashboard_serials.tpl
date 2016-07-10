<!-- <!DOCTYPE html>
<meta charset="utf-8">-->
<style>
 
  path {  stroke: #fff; }
  path:hover {  opacity:0.9; }
  rect:hover {  fill:blue; }
  .axis {  font: 10px sans-serif; }
 

  .axis path,
  .axis line {
    fill: none;
    stroke: #000;
    shape-rendering: crispEdges;
  }

  .x.axis path {  display: none; }
  .legend{
      margin-bottom:150px;
      display:inline-block;
     /* border-collapse: collapse;*/
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
  .btn {
    color: black;
  }
  .dashboard{
      
      outline-color: blue; 
      background-color: white;
  }
  #month_selection{
    background-color: white;
  }
  #previous_month, #next_month{
    /* background-color: grey;*/
  }
  .pager {
    background-color: white;
    color: blue;
  }
  
  
  .accordion > div {
    display:none;
  }
  .accordion:hover > div {
    display:block;
  }
 .panel-title{
  font-size: 30;
 }

#dash{
    float: center;
    width: 1200px;
    height: 800px;
}
</style>

<script>


  /*  var size = parseInt("[% available_months.size %]");
    var first_month = parseInt("[% available_months.first %]");
    var last_month = parseInt("[% available_months.last %]");
    var current_month = last_month;


    console.log("size " + size);
    console.log("current month " + current_month);
    console.log("first_month month " + first_month);
    console.log("last_month month " + last_month);

    //initally set current month display
    $("#current_month").text("Current Month: "+ current_month);

    //detech previous month change button
    $("#previous_month").on('click', function(){
      console.log("Previous Month Click Deteched.  Current: " + current_month + ", previous: " + (current_month - 1));
      current_month--;
      if(current_month < first_month){
        current_month = last_month;

      }
      $("#current_month").text("Current Month: "+ current_month);
    });

    //detech next month change button
    $("#next_month").on('click', function(){
      console.log("Next Month Click Deteched.  Current: " + current_month + ", next: " + (current_month + 1));
      current_month++;
      if( current_month > last_month){
           current_month = first_month;
      }
      $("#current_month").text("Current Month: "+ current_month);
    });
  });
*/

/*$(document).ready(function(){

    [% dashboard_data = get_dashboard_data() %]  
    var size = parseInt("[% available_months.size %]");
      
    var current_month = "[% dashboard_data.selected_month %]";
    console.log("Current month: "+ current_month);
    //initally set current month display
    $("#current_month").text("Current Month: "+ current_month);

    //detech previous month change button
    $("#previous_month").on('click', function(){
    
      [% dashboard_data = get_dashboard_data(3) %]  
     
      current_month = "[% dashboard_data.selected_month %]";
      $("#current_month").text("Current Month: "+ current_month);
    });

    //detech next month change button
    $("#next_month").on('click', function(){
      
     
      
    });
  });*/

</script>

<div id="dash" align='center' >
    
    <h3> [% dashboard_title %] for [% dashboard_data.month %]  </h3>
     <h3> Selected month [% dashboard_data.selected_month %]  </h3>
 
    <div class='pager' id="month_selection">
      
      <h3 id='current_month'></h3>
      <div align='left' class="previous"><a href="#">Previous</a></div>
      <div align='right' class="next"><a id="next_month" href="#">Next</a></div>
    </div>

    <div  class="panel-group" id="accordion">
    <div class="panel panel-default">
      <div id="total_calls" class="panel-heading">
        <h4 class="panel-title">
          <a id="total_calls" data-toggle="collapse" data-parent="#accordion" href="#collapse1">Total Calls: [% dashboard_data.total_calls %]</a>
        </h4>
      </div>
      <div id="collapse1" class="panel-collapse collapse in">
        <div class="panel-body">            
            <div class="col-md-4">
[% INCLUDE section/tables/top10/calltypes_by_totalcalls.tpl rendering_info = top_ten_calltypes(dashboard_data.month_index) %]
            <div id="draw_top_ten_models_here"></div>
            </div>
            <div class="col-md-4">
[% INCLUDE section/tables/top10/models_by_totalcalls.tpl rendering_info = top_ten_models(dashboard_data.month_index) %]
            </div>
            <div class="col-md-4">
 [% INCLUDE section/tables/top10/techs_by_totalcalls.tpl rendering_info = top_ten_techs(dashboard_data.month_index) %] 
            </div>
            </div>
      </div>
    </div>
    <div class="panel panel-default">
      <div class="panel-heading">
        <h4 class="panel-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapse2">Total Parts: [% dashboard_data.total_parts %] </a>
        </h4>
      </div>
      <div id="collapse2" class="panel-collapse collapse">
        <div class="panel-body">
            <div class="col-md-4">      
            </div>
            <div class="col-md-4">           
            </div>
            <div class="col-md-4">    </div>
            </div>
        </div>
      </div>
      </div>
  </div> 


[%  show_trends() %]