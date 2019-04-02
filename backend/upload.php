<?php

include_once "api/constants.php";
include_once APIURL;

$api = new API();

$input = file_get_contents("php://input");

$api->upload($input);


?>