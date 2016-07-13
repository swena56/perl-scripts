<style>
/* The Modal (background) */
.modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1; /* Sit on top */
    padding-top: 100px; /* Location of the box */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}

/* Modal Content */
.modal-content {
    background-color: #fefefe;
    margin: auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
}

/* The Close Button */
.close {
    color: #aaaaaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: #000;
    text-decoration: none;
    cursor: pointer;
}
</style>

<!-- model functionality -->
<script type='text/javascript'>

    function view_parts_click(x){
         alert("Row index is: " + x.rowIndex);
    }
    var modal = document.getElementById('parts_model');
    var btn = document.getElementById("show_parts");
    var span = document.getElementsByClassName("close")[0];

    btn.onclick = function() {
        modal.style.display = "block"; 
    }

    // When the user clicks on <span> (x), close the modal
    span.onclick = function() {
        modal.style.display = "none";
    }

    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    } 
</script> 

<h2> [% title %] </h2>
<p> [% message %] </p>
<p> [% user_input %]</p>

<!-- Columns -->
<table align='left' class='table table-hover table-responsive'>
    <tr>
        [% FOREACH i IN columns %]
            <th> [% i %] </th>
        [% END %]      
    </tr>
</table>

<div class='bodycontainer scrollable'>
    <table align='left' class='table table-hover table-responsive'>
       
       [% FOREACH row = table_data %]
        <tr>
            [% FOREACH i = row %]
                <td>   [% i %]  </td>
            [% END %]
        </tr>
        [% END %]  
    </table>
</div>

<p> [% var_dump_data %] </p>

<p> Total Parts Cost [% total_parts_cost %] </p>
<!-- The Modal -->
<div id="model" class="modal">
  <!-- Modal content -->
  <div class="modal-content">
    <span class="close">x</span>
  </div>
</div>