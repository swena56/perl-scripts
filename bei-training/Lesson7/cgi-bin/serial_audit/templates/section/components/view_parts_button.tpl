
<script>
var parts_button = $("<button id='show_parts_"+ser_id+"' name='myBtn' value='"+ser_id+"' >Parts</button>").on('click', function() {

//display parts list
var modal = document.getElementById('parts_model');
modal.style.display = "block";

var span = document.getElementsByClassName("close")[0];

//model use fucntion
    span.onclick = function() {
    modal.style.display = "none";
}

//detect escape to close popup
$(document).keyup(function(event) {
/* Act on the event */
if(event.which == 27){
console.log("escape button detected");    
modal.style.display = "none";
}
});


//[% render_parts_template(378) %]
//my cgi ajax way of getting my parts list
render_parts_template(['show_parts_'+ser_id],['draw_parts_popup_here'], 'POST'); 
}); 
</script>