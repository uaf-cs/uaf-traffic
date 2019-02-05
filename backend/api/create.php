<?php
include_once '../api.php';
include_once '../trafficdb.php';

$db = new TrafficDB();
$api = new Session($db);


$data = json_decode(file_get_contents("php://input"));

$api->create($data);

?>
