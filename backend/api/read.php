<?php
include_once '../api.php';
include_once '../trafficdb.php';

$db = new TrafficDB();
$api = new Session($db);

$api->read();

?>