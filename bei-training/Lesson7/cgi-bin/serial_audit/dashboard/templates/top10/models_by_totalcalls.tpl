<h3> Top Ten Models in [% get_month_string(rendering_info.month) %]</h3><br>
<div class='bodycontainer'>
    <table id="table_body" class='table table-hover'>
        
        <tr id="table_header">
            <th> Model number </th>
            <th> # Calls </th>
        </tr>

        [% FOREACH row IN rendering_info.table_data %]
        <tr id="data-popup-open" data-popup-open="trend_data" target="models_by_totalcalls" href="#" >
            <td>[%  row.model_number %]</td>
            <td>[%  row.model_count %]</td>               
        </tr>
    [% END %]    
    </table>
</div>