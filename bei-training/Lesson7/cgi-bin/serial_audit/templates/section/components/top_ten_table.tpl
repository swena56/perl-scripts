<!--    Usage example
        [ INCLUDE section/table.tpl          
            table_columns =    ,
            table_data =     
        %] 
      -->


<!-- Columns -->
<table class='table table-hover table-responsive'>
    <tr id="table_header">
        [% FOREACH i = table_columns %]
            <th> [% i %] </th>
        [% END %]      
    </tr>
</table>

<div class='bodycontainer scrollable'>
    <table id="table_body" class='table table-hover table-responsive'>
      
       [% FOREACH row = table_data %]
        <tr>
            
            [% FOREACH i = row %]
               <td>    [% i %]   </td>
            [% END %]
           
       </tr> 
        [% END %] 
         
    </table>
</div>