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

     $("tr").click(function (){
        var index = $("table").index($(this));
        console.log("click index: "+ +)
        $("span").text("That was row index #" + index);
    });
});

</script>

<div id='result'></div>
<h3> [% rendering_info.title %] </h3>

<br><h3> [% rendering_info.message %] </h3>




<!-- Columns -->
<div class='bodycontainer'>
    <table id="table_body" class='table table-hover '>
        
        <tr id="table_header">
            <th> Model number </th>
            <th> Amount </th>
            <th> Date </th>
        </tr>

        [% FOREACH row IN rendering_info.table_data %]
        <!-- <tr id="show_parts" class='clickable-row' data-href='http://www.google.com' > -->
        <tr id="show_parts"  >
                <td>[%  row.model_number %]</td>
                <td>[%  row.model_count %]</td>
                <td>[%  row.completion_datetime %]</td>
        </tr>
    [% END %]    
    </table>
</div>

<div id='parts_model'></div>

[% INCLUDE section/graphs/horizontal.tpl %]