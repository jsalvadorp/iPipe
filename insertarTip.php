<?php 

$conexion = mysqli_connect("localhost", "root", "","tips") or die();


mysqli_query($conexion, 
	"INSERT INTO tips(tip, timestamp) VALUES ('" . $_POST["tip"] . "', " . time() . ")") or die();
mysqli_close($conexion);
?>
