<?php
include_once "api/constants.php";
include_once APIURL;

$api = new API();

$pin = isset($_POST['pin'])? $_POST['pin'] : '' ;

$api->checkPIN($pin);

?>
