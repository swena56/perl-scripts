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
<h3> [% rendering_info.title %] </h3>

<br><h3> [% rendering_info.message %] </h3>
<p> [% rendering_info.data_vault %] </p>

<!-- Columns -->
<div style="overflow: hidden;"class='bodycontainer'>
    <table id="table_body" class='table table-hover '>
        
        <tr id="table_header">
            [% FOREACH i = rendering_info.table_columns %]
                <th> [% i %] </th>
            [% END %]  
        </tr>

        [% FOREACH row IN rendering_info.table_data %]
        <tr class='clickable-row' data-href='http://www.google.com' >
          
            [% FOREACH value IN row %]
                <td>[%  row.model_number %]</td>
            [% END %]
        </tr>
    [% END %]    
    </table>
</div>