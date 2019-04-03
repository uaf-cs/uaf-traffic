<?php
include_once "api/api.php";

$api = new API();

$pin = isset($_POST['pin'])? $_POST['pin'] : '' ;

$api->checkPIN($pin);

?>
