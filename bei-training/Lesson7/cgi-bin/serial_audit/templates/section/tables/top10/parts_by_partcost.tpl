<div id='result'></div>
<h3> Top Ten Technicians</h3><br>

<div class='bodycontainer'>
    <table id="table_body" class='table table-hover '>
        
        <tr id="table_header">
            <th> Tech ID </th>
            <th> Number of Calls </th>
        </tr>

        [% FOREACH row IN rendering_info.table_data %]
        <tr id="data-popup-open" data-popup-open="trend_data" value="techs_by_totalcalls">
                <td>[%  row.technician_id %]</td>
                <td>[%  row.technician_number %]</td>               
        </tr>
        [% END %]    
    </table>
</div>
