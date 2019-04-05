<!doctype html>
<link rel ="stylesheet" href="style.css">
<title>UAFTRAFFIC</title>
<?php
include_once "api/api.php";

$api = new API();
$api->makePage();



$results = $api->readData();

foreach($results as & $row) {

    //$trafficData->addPoints($row['crossing']);
    print "<article>";
    print "<h3> Traffic Data <br>" . $row['date'] . "<br>";
    print "<h4>Location (Lat Long): ". $row['lat'] .", " . $row['lon'] . "</h4></h3>";  

    print "<img src='graphs/".$row['id']."map.png'>";
    // $crosses = json_decode($row['crossing'], TRUE);

    // foreach($crosses as $cross) {
    //     foreach($cross as $key => $val) {
    //         print "$key : $val <br>";
    //     }
    // }


    print "</article>";
}?>