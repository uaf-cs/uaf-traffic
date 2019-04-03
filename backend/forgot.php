<!doctype html>
<link rel ="stylesheet" href="style.css">
<title>UAFTRAFFIC</title>

<?php
include_once "api/api.php";

$api = new API();

$api->makePage();

?>

<form action="<?php echo SITEINFO::APIURL?>?forgot" method='post'>
    <fieldset>
        <legend> Forgot your password? </legend>
        <p><label> Email: </label> <input type='text' name='email'></p>
        <button type='submit' style="width:100%;"> Reset password </button>
    </fieldset>

    
</form>
</fieldset>

