<!doctype html>
<link rel ="stylesheet" href="style.css">
<title>UAFTRAFFIC</title>

<?php
include_once '../api.php';
include_once "../constants.php";

$api = new API();

//redirect to login page if user is not logged in
if (!$api->isloggedin) {
    header("Location: login.php");
    exit();
}

$api->makePage();


//if passed a username and user is admin, go to that users account page
if(isset($_POST['username'])) $name = $_POST['username'];
//else go to signed in users account page
else $name = $api->username;

print("<pre>");
print_r($api->getUser($name));
print("</pre>");
?>

<article>
    <h3> <?php print($api->userfullname) ?> </h3>

</article>