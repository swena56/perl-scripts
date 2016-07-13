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

$(document).ready(function(){
  /*Disable unimplemented functionality*/
  $('#total_serials_w_calls_button').prop('disabled', true);
  $('#total_technicians_w_calls_button').prop('disabled', true);
  $('#total_models_w_calls_button').prop('disabled', true);
  $('#total_parts_w_calls_button').prop('disabled', true);

});

</script>

 <p> [% debug %] </p>
  <br>
  <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#total_calls">Total Calls: [% dashboard_data.total_calls %]</button>
  <div id="total_calls" class="collapse">
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

<button type="button" class="btn btn-info" data-toggle="collapse" data-target="#total_parts">Total Parts: [% dashboard_data.total_parts %]</button>
  <div id="total_parts" class="collapse">
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

 <!-- <p> Total Calls:  [% dashboard_data.total_calls %] </p>
 <p> Total Parts:  [% dashboard_data.total_parts %] </p> -->
 <br>
 <button id="total_serials_w_calls_button" type="button" class="btn btn-info" style="background-color:grey" data-toggle="collapse" data-target="#total_parts">Total Serials With Calls: [% dashboard_data.total_serials_w_calls %]</button>
 <button id="total_technicians_w_calls_button" type="button" class="btn btn-info" style="background-color:grey" data-toggle="collapse" data-target="#total_parts">Technicians With Calls: [% dashboard_data.total_techs_w_calls %]</button>
 <button id="total_models_w_calls_button" type="button" class="btn btn-info" style="background-color:grey" data-toggle="collapse" data-target="#total_parts">Total Models With Calls:  [% dashboard_data.total_models_w_calls %]</button>
 <button id="total_parts_w_calls_button" type="button" class="btn btn-info" style="background-color:grey" data-toggle="collapse" data-target="#total_parts">Total Parts With Calls: [% dashboard_data.total_parts %] </button>



<!--  <br>
 <div id="block_container">
  <h3 id='current_month'>Month: [% current_month %]</h3>
  <div  class="pager previous"><a id="previous_month" href="">Previous</a></div>
  <div class="pager next"><a id="next_month" href="">Next</a></div>
</div> -->

 <!-- <p> Total Serials With Calls:  [% dashboard_data.total_serials_w_calls %] </p>
 <p> Total Technicians With Calls:  [% dashboard_data.total_techs_w_calls %] </p>
 <p> Total Models With Calls:  [% dashboard_data.total_models_w_calls %] </p>
 <p> Total Parts With Calls:  [% dashboard_data.total_parts %] </p>
 -->

[%  show_trends() %]


<!-- [ INCLUDE graphs/scatter.tpl %] -->

