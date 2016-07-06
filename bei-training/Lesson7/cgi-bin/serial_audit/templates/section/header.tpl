 
<!DOCTYPE html>
<html>
<head>
<style>
a { 
    text-decoration: none;
     }
a:hover{
    text-decoration: none;
}
.dashboard_link {text-decoration: none;}

ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    background-color: #5745b6;
}

li {
    float: left;
}

li a {
    display: block;
    color: white;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;

}
.title{
    border: 1px solid blue;
    outline-color: blue; 
    background-color: lightgrey;
}

.jumbotron{
	background-color: lightgrey;
   
}

li a:hover:not(.active) {

    background-color: white;
}

.active {
	text-decoration: none;
    color: black;
    background-color: lightgrey;
}
</style>
</head>
<body>



<div class='title'>
    <ul>
     <li><b><a class='dashboard_link' href="#home">Home</a></b></li>
     <li><b><a class='dashboard_link' href="#customer">Customers</a></b></li>
      <li><b><a class='dashboard_link' href="#meter">Meters</a></b></li>

      <!-- <li style="float:right"><b><a class='dashboard_link' href="https://www.beiservices.com/"><img style="-webkit-user-select: none" width='50px' src="http://192.168.1.230/bei_high.png"></a></b></li> -->
      
      <li><b><a class="active" href="#active_dashboard_selection">[% title %] </a></b></li>
    </ul>
    <div align='center'  class='jumbotron'>

                <h1> [% title %] </h1>
                <p> [% guest_welcome_message %]</p> 
                <p> [% about %]</p>
                
              </div>  
 </div>
 <br>


</body>
</html>



 

