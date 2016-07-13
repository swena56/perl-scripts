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
    width:90%;
    padding:40px;
    position:absolute;
    top:50%;
    left:50%;
    -webkit-transform:translate(-50%, -50%);
    transform:translate(-50%, -50%);
    box-shadow:0px 2px 6px rgba(0,0,0,1);
    border-radius:3px;
    background:#fff;
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
 jQuery(document).ready(function($) {

        $(function() {
            //----- OPEN
            $('[data-popup-open]').on('click', function(e)  {
                
                var calling_row = $(this).context;
                console.log(calling_row);

                var model_id = calling_row.getElementsByTagName('td')[0].innerText;
                 console.log("clicked on: " + model_id);

                 if(model_id){
                    //post request for trend data
                    $.post('resources/JSON/trend_data.cgi', {
                        trend_type: "models",
                        trend_by: "calltype",
                        input: model_id

                    }, function(json) {
                       
                        console.log(json);
                        $( "#draw_trend_data_here" ).append( response );
                        

                        //render json data
                        $.post('graphing_engine.cgi', { 
                            graph_data: {json}
                        }, function(response) {
                            $("#draw_trend_data_here").empty();
                            $("#draw_trend_data_here").append($("<br><p>Data to graph: "+response+"</p>"));
                            /*$( "#draw_trend_data_here" ).append( response );*/
                            console.log(response);
                        });

                    }, 'json');
                 } 

                $("#trend_title").empty().append($("<h3> Trend Data for "+model_id+"</h3>"));
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
    });
</script>
