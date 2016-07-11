<div id='result'></div>
<h3> Top Ten Technicians</h3><br>

<div class='bodycontainer'>
    <table id="table_body" class='table table-hover '>
        
        <tr id="table_header">
            <th> Tech ID </th>
            <th> Parts Cost </th>
        </tr>

        [% FOREACH row IN rendering_info.table_data %]
        <tr id="data-popup-open" data-popup-open="trend_data" target="techs_by_partscost">
                <td>[%  row.technician_number %]</td>
                <td>[%  row.parts_cost_total %]</td>               
        </tr>
        [% END %]    
    </table>
</div>
