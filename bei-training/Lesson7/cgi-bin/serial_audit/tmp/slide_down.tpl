<style>
body {
    margin: 0;
    font-family: 'Lato', sans-serif;
}

.overlay {
    height: 0%;
    width: 100%;
    position: fixed;
    z-index: 1;
    top: 0;
    left: 0;
    background-color: rgb(0,0,0);
    background-color: rgba(0,0,0, 0.9);
    overflow-y: hidden;
    transition: 0.5s;
}

.overlay-content {
    position: relative;
    top: 25%;
    width: 100%;
    text-align: center;
    margin-top: 30px;
}

.overlay a {
    padding: 8px;
    text-decoration: none;
    font-size: 36px;
    color: #818181;
    display: block;
    transition: 0.3s;
}

.overlay a:hover, .overlay a:focus {
    color: #f1f1f1;
}

.closebtn {
    position: absolute;
    top: 20px;
    right: 45px;
    font-size: 60px !important;
}

@media screen and (max-height: 450px) {
  .overlay {overflow-y: auto;}
  .overlay a {font-size: 20px}
  .closebtn {
    font-size: 40px !important;
    top: 15px;
    right: 35px;
  }
}
</style>
<body>
    
<script>
function openNav() {
    document.getElementById("myNav").style.height = "100%";
}

function closeNav() {
    document.getElementById("myNav").style.height = "0%";
}
</script>
<div id="myNav" class="overlay">
  <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">X</a>
  <div class="overlay-content">
    <a href="#">About</a>
    <a href="#">Services</a>
    <a href="#">Clients</a>
    <a href="#">Contact</a>
  </div>
</div>


<span style="font-size:30px;cursor:pointer" onclick="openNav()">open</span>