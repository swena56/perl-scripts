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



<div>
<div id="dash" align='center' >
  <br><br><br><br>
     <br><br><b><h2> [%dashboard_title %] for [% dashboard_data.month %]  </h2></b><br>
     
     <p> Total Serials With Calls:  [% dashboard_data.total_serials_w_calls %] </p>
     <p> Total Technicians With Calls:  [% dashboard_data.total_techs_w_calls %] </p>
     <p> Total Models With Calls:  [% dashboard_data.total_models_w_calls %] </p>
     <p> Total Parts With Calls:  [% dashboard_data.total_parts %] </p>
    <div  class="panel-group" id="accordion">

    <div class="panel panel-default">
      <div id="total_calls" class="panel-heading">
        <h4 class="panel-title">
          <a id="total_calls" data-toggle="collapse" data-parent="#accordion" href="#collapse1">Total Calls: [% dashboard_data.total_calls %]</a>
        </h4>
      </div>
      <div id="collapse1" class="panel-collapse collapse">
               <div class="panel-body">            
            <div class="col-md-4">
[% INCLUDE top10/calltypes_by_totalcalls.tpl rendering_info = top_ten_calltypes(dashboard_data.month_index) %]
            <div id="draw_top_ten_models_here"></div>
            </div>
            <div class="col-md-4">
[% INCLUDE top10/models_by_totalcalls.tpl rendering_info = top_ten_models(dashboard_data.month_index) %]
            </div>
            <div class="col-md-4">
 [% INCLUDE top10/techs_by_totalcalls.tpl rendering_info = top_ten_techs(dashboard_data.month_index) %] 
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
            <div class="col-md-3"> 
              [% INCLUDE top10/calltypes_by_partscost.tpl rendering_info = calltypes_by_partscost(dashboard_data.month_index) %] 
            </div>
            <div class="col-md-3"> 
              [% INCLUDE top10/parts_by_partscost.tpl rendering_info = parts_by_partscost(dashboard_data.month_index) %]    
            </div>
            <div class="col-md-3">           
              [% INCLUDE top10/models_by_partscost.tpl rendering_info = models_by_partscost(dashboard_data.month_index) %] 
            </div>
             <div class="col-md-3">           
             [% INCLUDE top10/techs_by_partscost.tpl rendering_info = techs_by_partscost(dashboard_data.month_index) %] 
            </div>
            </div>
        </div>
      </div>
      </div>
  </div> 
</div>

[%  show_trends() %]