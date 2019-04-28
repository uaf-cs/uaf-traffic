<!doctype html>
<link rel ="stylesheet" href="style.css">
<title>UAFTRAFFIC</title>
<?php
include_once "api/api.php";

$api = new API();
$api->makePage();

$results = $api->readData();

//if user requests traffic data download
////////////////////////////////////////////////////////////////////////////////////
// if(isset($_GET['download'])) {                                                 //
//    $handle = fopen("trafficdata.txt", "w");                                    //
//     fwrite($handle, $_POST['data']);                                           //
//     fclose($handle);                                                           //
//                                                                                //
//     header('Content-Type: application/octet-stream');                          //
//     header('Content-Disposition: attachment; filename='.basename('file.txt')); //
//     header('Expires: 0');                                                      //
//     header('Cache-Control: must-revalidate');                                  //
//     header('Pragma: public');                                                  //
//     header('Content-Length: ' . filesize('file.txt'));                         //
//     readfile('file.txt');                                                      //
// }                                                                              //
////////////////////////////////////////////////////////////////////////////////////

foreach($results as & $row) {

    print "<article>";

    print "<h3> Traffic Data <br>" . $row['date'] . "<br>";
    print "<h4>Location (Lat Long): ". $row['lat'] .", " . $row['lon'] . "</h4></h3>";  

    print "<img src='graphs/".$row['id']."map.png'>";

    print "<br><a href='graphs/".$row['id']."map.png' download>Download Traffic Map</a>";

    print "<form action ='trafficdata.php?download' method='post'> "
          . "<button type='submit'>Download Traffic Data</button> ";
    print "</article>";
}?>
