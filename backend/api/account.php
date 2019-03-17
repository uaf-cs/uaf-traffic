<?php
include_once '../api.php';

$api = new API();

if(!$api->isloggedin) {
    header("Location: login.php");
    exit();
}

$api->makePage('account.php');
?>

whattup