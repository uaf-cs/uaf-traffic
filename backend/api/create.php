<?php
include_once 'session.php';
include_once '../auth.php';

$db = new AuthDatabase();
$session = new Session($db);


$data = json_decode(file_get_contents("php://input"));

$session->create($data);

?>
