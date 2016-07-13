 <!-- use case
 [ INCLUDE section/model.tpl 
        title = ''
        message = 
        columns =
        table_data =
        draw_chart =
 %]
 -->

<style>
        .bodycontainer { max-height: 360px; width: 100%; margin: 0; overflow-y: auto; }
        .table-scrollable { margin: 0; padding: 0; }

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
<script type='text/javascript'>
    
     $(document).ready(function(){

            $("#serial_search").keyup(function(event){
                
                //get user input
                var user_input = $(this).val();
                console.log(user_input);

                if(event.which == 27 || user_input == ""){
                    console.log("escape button detected- changing focus to search: "+  $(this).val());                        
                    $('#rst_form').click();  //clear form
                    $('#serial_table').empty();
                    $("#serial_search").focus();
                    return;
                }

                //post request for serial data
                console.log("requesting data:");
                $.post('resources/JSON/serial_json.cgi', {serial: user_input}, function(json) {

                    console.log(json);

                    if(user_input != ""){
                      
                    }                       
                }, 'json');

            });    
        });
</script>
 <!-- popup modal -->
        <div id="parts_model" class="modal">

          <!-- model container -->
          <div class="modal-content">
            <span class="close">x</span>
             <div id="draw_parts_popup_here"></div>
          </div>
        </div>

           <!-- Enter serial form -->
        <form role="form" role="form" method="POST" accept-charset="UTF-8">
            <div class="form-group">
              Serial Search: 
         
              <input  type="text" id="serial_search" class='form-control'  autofocus autocomplete='off'>
              <div style="display='none'; display: none;" ><input type="reset" id="rst_form"></div>
            </div>
        </form>       
        <br>
        <div id='serial_table'></div>