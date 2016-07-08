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
      margin-bottom:100px;
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
      border: 1px solid blue;
     /* outline-color: blue; 
      background-color: lightgrey;*/
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
}


</style>




<script>



</script>

<div id="dash" align='center' >
  <h3 value='3'> [% dashboard_title %] for [% dashboard_data.month %] </h3><br>
  <div  class="panel-group" id="accordion">
    <div class="panel panel-default">
      <div id="total_calls" class="panel-heading">
        <h4 class="panel-title">
          <a id="total_calls" data-toggle="collapse" data-parent="#accordion" href="#collapse1">Total Calls: [% dashboard_data.total_calls %]</a>
        </h4>
      </div>
      <div id="collapse1" class="panel-collapse collapse">
        <div class="panel-body">            
            <div class="col-md-4" style="background-color:white;">
[% INCLUDE section/tables/models_top10.tpl rendering_info = top_ten_call_types_month_index(dashboard_data.month_index) %]
            <div id="draw_top_ten_models_here"></div>
            </div>
            <div class="col-md-4" style="background-color:white;">
[% INCLUDE section/tables/models_top10.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
            </div>
            <div class="col-md-4" style="background-color:white;">
[% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
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
            <div class="col-md-4" style="background-color:white;">
            [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
            </div>
            <div class="col-md-4" style="background-color:white;">
             [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
            </div>
            <div class="col-md-4" style="background-color:white;">
              [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
            </div>
            </div>
        </div>
      </div>
    
    <div class="panel panel-default">
      <div class="panel-heading">
        <h4 class="panel-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapse3">Total Serials With Calls: [% dashboard_data.total_serials_w_calls %]</a>
        </h4>
      </div>
      <div id="collapse3" class="panel-collapse collapse">
        <div class="panel-body">
              <div class="col-md-4" style="background-color:white;">
             [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
              </div>
             <div class="col-md-4" style="background-color:white;">
              [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
              </div>
             <div class="col-md-4" style="background-color:white;">
              [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
              </div>
            </div>
        </div>
      </div>
     <div class="panel panel-default">
      <div class="panel-heading">
        <h4 class="panel-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapse4">Total Technicians With Calls: [% dashboard_data.total_techs_w_calls %] </a>
        </h4>
      </div>
      <div id="collapse4" class="panel-collapse collapse">
        <div class="panel-body">
              <div class="col-md-4" style="background-color:white;">
             [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
              </div>
             <div class="col-md-4" style="background-color:white;">
              [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
              </div>
             <div class="col-md-4" style="background-color:white;">
              [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
              </div>
            </div>
        </div>
      </div>
      <div class="panel panel-default">
      <div  class="panel-heading ">
        <h4 class="panel-title ">
          <a data-toggle="collapse"  data-parent="#accordion" href="#collapse5">Total Models With Calls: [% dashboard_data.total_models_w_calls %] </a>
        </h4>
      </div>
      <div id="collapse5" class="panel-collapse collapse ">
        <div class="panel-body">
              <div class="col-md-4" >
             [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
              </div>
             <div class="col-md-4" style="background-color:white;">
              [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]

              </div>
             <div class="col-md-4" style="background-color:white;">
              [% INCLUDE section/table.tpl rendering_info = top_ten_models_for_month_index(dashboard_data.month_index) %]
              </div>
            </div>
        </div>
      </div>
      </div>
  </div> 
</div>