<div id="calltypes_by_totalcalls.tpl">
<script> 



</script>

<div id='result'></div>
<h3> Top Ten CallTypes </h3><br>

<div class='bodycontainer'>
    <table id="table_body" class='table table-hover '>
        
        <tr id="table_header">
            <th> Call Type </th>
            <th> # Calls </th>
        </tr>

        [% FOREACH row IN rendering_info.table_data %]
        <tr id="data-popup-open" data-popup-open="trend_data" value="calltypes_by_totalcalls" >
                <td>[%  row.call_type %]</td>
                <td>[%  row.total_calls %]</td>              
        </tr>
    [% END %]    
    </table>
</div>
</div>