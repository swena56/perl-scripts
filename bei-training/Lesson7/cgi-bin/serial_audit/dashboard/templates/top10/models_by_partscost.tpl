<h3> Top Ten Models</h3><br>
<div class='bodycontainer'>
    <table id="table_body" class='table table-hover'>
        <tr id="table_header">
            <th> Model number </th>
            <th> Parts Cost </th>
        </tr>

        [% FOREACH row IN rendering_info.table_data %]
        <tr id="data-popup-open" data-popup-open="trend_data" target="models_by_partscost" href="#" >
            <td>[%  row.model_number %]</td>
            <td>[%  row.parts_cost_total %]</td>               
        </tr>
    [% END %]    
    </table>
</div>