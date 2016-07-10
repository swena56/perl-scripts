<div id="calltypes_by_totalcalls.tpl">

<div id='result'></div>
<h3> Top Ten Call Types </h3><br>

<div class='bodycontainer'>
    <table id="table_body" class='table table-hover '>
        
        <tr id="table_header">
            <th> Call Type </th>
            <th> Parts Cost </th>
        </tr>

        [% FOREACH row IN rendering_info.table_data %]
        <tr id="data-popup-open" data-popup-open="trend_data" value="calltypes_by_totalcalls" >
                <td>[%  row.call_type %]</td>
                <td>[%  row.part_cost_total %]</td>              
        </tr>
    [% END %]    
    </table>
</div>
</div>