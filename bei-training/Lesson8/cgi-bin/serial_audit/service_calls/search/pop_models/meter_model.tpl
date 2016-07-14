
<h2> [% model_number %] [% title %] </h2>
<p> [% message %] </p>
<!-- <p> [% user_input %]</p> 
-->
<p> [% var_dump_data %]</p>
<p> Service required based on meter reading: unknown </p>
<!-- Columns -->
<table  text-align='left' class='table table-hover table-responsive'>
    <tr>
        [% FOREACH i IN columns %]
            
        [% END %]      
    </tr>
</table>

<div class='bodycontainer'>
    <table text-align='left' class='table table-hover table-responsive'>
        <tr>
        [% FOREACH i IN columns %]
            <th> [% i %] </th>
        [% END %]      
        </tr>

        [% FOREACH row = table_data %]
        <tr>          
            <td> [% row.serial_number %]</td>
            <td> [% row.meter_code %]</td>
            <td> [% row.meter_description %]</td>
            <td> [% commify(row.meter) %]</td>            
       </tr> 
        [% END %]               
    </table>
</div>

