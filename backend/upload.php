<?php

include_once "api/api.php";

$api = new API();

$input = file_get_contents("php://input");

$api->upload($input);


?>