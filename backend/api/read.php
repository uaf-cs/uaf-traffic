<?php
include_once '../api.php';
include_once '../trafficdb.php';

$db = new TrafficDB();
$api = new API($db);


$api->read();

?>