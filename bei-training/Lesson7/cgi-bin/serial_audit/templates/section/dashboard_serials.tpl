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

<div id="dash" align='center' >
  <h3 value='3'> [% dashboard_title %] for [% dashboard_data.month %] </h3><br>
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