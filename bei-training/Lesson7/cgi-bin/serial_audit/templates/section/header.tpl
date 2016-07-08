 
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
    background-color: black;
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
    border: 1px solid white;
    outline-color: black; 
    background-color: white;
}

.jumbotron{
	background-color: white;
   
}

li a:hover:not(.active) {

    background-color: white;
}

.active {
	text-decoration: none;
    color: black;
    background-color: white;
}
</style>
</head>
<body>



<div class='title'>
    <ul>
     <li><b><a class='dashboard_link' href="http://localhost/cgi-bin/serial_audit/">Home</a></b></li>
     

      <!-- <li style="float:right"><b><a class='dashboard_link' href="https://www.beiservices.com/"><img style="-webkit-user-select: none" width='50px' src="http://192.168.1.230/bei_high.png"></a></b></li> -->
      
      <li><b><a class="active" href="">[% title %] </a></b></li>
    </ul>
    
 </div>
 <br>


</body>
</html>



 

