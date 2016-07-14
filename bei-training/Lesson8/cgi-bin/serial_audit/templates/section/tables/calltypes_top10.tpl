<!--    Usage example
        [ INCLUDE section/table.tpl          
            title           =   ,
            table_columns   =   ,
            table_data      =   ,
            debug           =    
        %] 
      -->

<script> 
    jQuery(document).ready(function($) {
    $(".clickable-row").click(function() {
        window.document.location = $(this).data("href");
    });
});
</script>

<div id='result'></div>
<h3> Top Ten Call Types </h3>


<div class='bodycontainer'>
    <table id="table_body" class='table table-hover '>
        
        <tr id="table_header">
            <th> Call Type </th>
            <th> Total Calls </th>
            <th> Date </th>
        </tr>

        [% FOREACH row IN rendering_info.table_data %]
        <!-- <tr id="show_parts" class='clickable-row' data-href='http://www.google.com' > -->
        <tr id="show_parts"  >
                <td>[%  row.call_type %]</td>
               
        </tr>
    [% END %]    
    </table>
</div>
