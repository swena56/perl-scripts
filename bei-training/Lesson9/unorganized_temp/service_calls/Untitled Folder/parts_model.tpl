<h2> [% model_number %] [% title %] </h2>
<p> [% message %] </p>

<!-- Columns -->
<table  class='table table-hover table-responsive'>
    <tr>
        [% FOREACH i IN columns %]
            <th> [% i %] </th>
        [% END %]      
    </tr>
</table>
<div class='bodycontainer scrollable'>
    <table  class='table table-hover table-responsive'>
      
       [% FOREACH row IN table_data %]
        <tr>
            <td> [% row.serial_number %]</td>
            <td> [% row.part_number %]</td>
            <td> [% row.parts_cost %]</td>
         </tr>        
        [% END %] 
    </table>
</div>

<p> Total Parts Cost: [% total_parts_cost %] </p>