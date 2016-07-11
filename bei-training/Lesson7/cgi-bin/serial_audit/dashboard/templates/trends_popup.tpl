<style>

.popup {
    width:100%;
    height:100%;
    display:none;
    position:fixed;
    top:0px;
    left:0px;
    background:rgba(0,0,0,0.75);
}
 
/* Inner */
.popup-inner {
    max-width:700px;
    max-width:470px;
    width:100%;
    padding:40px;
    position:absolute;
    top:50%;
    left:50%;
    -webkit-transform:translate(-50%, -50%);
    transform:translate(-50%, -50%);
    box-shadow:0px 2px 6px rgba(0,0,0,1);
    border-radius:3px;
    background: white;
}
 
/* Close Button */
.popup-close {
    width:30px;
    height:30px;
    padding-top:4px;
    display:inline-block;
    position:absolute;
    top:0px;
    right:0px;
    transition:ease 0.25s all;
    -webkit-transform:translate(50%, -50%);
    transform:translate(50%, -50%);
    border-radius:1000px;
    background:rgba(0,0,0,0.8);
    font-family:Arial, Sans-Serif;
    font-size:20px;
    text-align:center;
    line-height:100%;
    color:#fff;
}
 
.popup-close:hover {
    -webkit-transform:translate(50%, -50%) rotate(180deg);
    transform:translate(50%, -50%) rotate(180deg);
    background:rgba(0,0,0,1);
    text-decoration:none;
}

</style>

<div class="popup" data-popup="trend_data">
    <div class="popup-inner">
        <div id='trend_title'></div>

        <div id="draw_trend_data_here"></div>

        <p><a data-popup-close="trend_data" href="#">Close</a></p>
        <a class="popup-close" data-popup-close="trend_data" href="#">x</a>
    </div>
</div>

<script>
 $(document).ready(function($) {

    //if the escape button is pressed
    $(document).keydown(function(event){
        if(event.which == 27){
               $('[data-popup-close]').click();
            return;
        }
    });
      
    //----- OPEN
    $('[data-popup-open]').on('click', function(e)  {
        
        var calling_row = $(this).context;
        var graph_type = $(this).context.getAttribute("target");;
        console.log(calling_row);

        console.log(graph_type);

        var ref_id = calling_row.getElementsByTagName('td')[0].innerText;
         console.log("clicked on: " + ref_id);

         if(ref_id){
                $.post('dashboard/graphing_engine.cgi', { 
                    id:  ref_id,
                    type: graph_type,
                }, function(response) {

                    $("#draw_trend_data_here").empty();
                    $( "#draw_trend_data_here" ).append( response );
                });
         } 

       /* $("#trend_title").empty().append($("<h3> Trend Data for "+model_id+"</h3>"));*/
        var targeted_popup_class = jQuery(this).attr('data-popup-open');
        $('[data-popup="' + targeted_popup_class + '"]').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('[data-popup-close]').on('click', function(e)  {
        var targeted_popup_class = jQuery(this).attr('data-popup-close');
        $('[data-popup="' + targeted_popup_class + '"]').fadeOut(350);
        e.preventDefault();
    });
        
    });
</script>
