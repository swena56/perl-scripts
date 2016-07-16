<div id='result'></div>
<h3> Top Ten Technicians in [% get_month_string(rendering_info.month) %]</h3>

[% IF rendering_info.num_rows > 0%]
<div class='bodycontainer'>
    <table id="table_body" class='table table-hover '>
        
        <tr id="table_header">
            <th> Tech ID </th>
            <th> Number of Calls </th>
        </tr>
        
        [% FOREACH row IN rendering_info.table_data %]
        <tr id="data-popup-open" data-popup-open="trend_data" target="techs_by_totalcalls">
                <td>[%  row.technician_number %]</td>
                <td>[%  row.total_calls %]</td>               
        </tr>
        [% END %]    
    </table>
</div>
[% ELSE %]

</p><font color="red"> <b> No Technicians With Calls</b></font></p>
[% END %]

