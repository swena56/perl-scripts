<style>
  #menu_item {
      color: white;
      text-decoration: none;
  }


  .active {
    background-color: white
    color: black;
  }

  .navbar {
    margin-bottom: 0px;
}
  
</style>
<!--&#9776; 3 bars ascii-->
<script>
  function update_page(url){

      $.post(url, {
            bypass: true,
        }, function(response) {

            //append data to div container in main content template
            $("#main_content").empty();
            $("#main_content").append(response);
        }, 'html');
  }

  $(document).ready(function(){
    update_page('[% menu_items.service_calls.addr %]');
  });
</script>

<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <ul class="navbar-header">
      <li class="navbar-brand">
          <p id="menu_item"> [% title %] </p>         
      </li>
    </ul>
    <ul class="nav navbar-nav">
       <!--<li>
          <a id="menu_item" class='active' href="javascript:update_page('index.cgi')">[% menu_items.home.name %]</a>
       </li>-->
       <li>
          <a id="menu_item" class='active' href="javascript:update_page('[% menu_items.service_calls.addr %]')">[% menu_items.service_calls.name %]</a>
       </li>
       <li>
          <a id="menu_item" class='active' href="javascript:update_page('[% menu_items.dashboard.addr %]')">[% menu_items.dashboard.name %]</a>
       </li>
    </ul>
  </div>
</nav>



 