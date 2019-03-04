<?php
$URL = 'adminconsole.php';

print "Log in to continue";
print "<form action='${URL}?login' method='post'>";
print "username: <input type='text' name='username'>";
print "password: <input type='password' name='password'>";
print "<input type='submit' value='login'>";
print "</form>";

?>