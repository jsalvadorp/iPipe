<?php 
$conexion = mysqli_connect("localhost", "root", "","tips") or die();
mysqli_set_charset($conexion, "utf8"); //formato de datos utf8
$result = mysqli_query($conexion, "select * from tips where timestamp > " . $_GET['timestamp']) or die();
// deberia ser lo siguiente para limitar el tamaño de la respuesta del servidor:
/* 
$result = mysqli_query($conexion, 
	"select * from tips where timestamp > " . $_GET['timestamp'] . 
	" order by timestamp limit 0, 50") or die(); 
*/ 
$arr = array();
$i = 0;

while($row = mysqli_fetch_array($result)) {
	$arr[$i] = array("tip" => $row['tip'], "timestamp" => $row['timestamp']);
	$i++;
}
 
echo json_encode($arr);
mysqli_close($conexion);
?>