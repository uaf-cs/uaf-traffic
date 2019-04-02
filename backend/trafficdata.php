<!doctype html>
<link rel ="stylesheet" href="style.css">
<title>UAFTRAFFIC</title>
<?php
include_once "api/constants.php";
include_once APIURL;

$URL = ADMINURL;
$api = new API();
$api->makePage();

$results = $api->readData();

foreach($results as & $row) {

    print "<article>";
    print "<h3> Traffic Data <br>" . $row['date'] . "<br>";
    print "<h4>Location (Lat Long): ". $row['lat'] .", " . $row['lon'] . "</h4></h3>";

    // foreach(json_decode($row['crossing']) as & $crossing) {
    //     print($crossing);
    // }

    //just dump everything until we can nail down a format to use
    print "<pre>";
    print_r($row['crossing']);
    print "</pre>";

    print "</article>";
}