<!doctype html>
<link rel ="stylesheet" href="style.css">
<title>UAFTRAFFIC</title>

<?php
include_once "api/constants.php";
include_once APIURL;

$api = new API();
$api->makePage();

?>

<form action="<?php echo ADMINURL?>?login" method='post'>
    <fieldset>
        <legend> Log in to continue </legend>
        <p><label> Username: </label> <input type='text' name='username'></p>
        <p><label> Password: </label> <input type='password' name='password'></p>
        <button type='submit' style="width:100%;"> Login </button>
    </fieldset>
</form>
</fieldset>

