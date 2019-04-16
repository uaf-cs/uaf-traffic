<!doctype html>
<link rel ="stylesheet" href="style.css">
<title>UAFTRAFFIC</title>

<?php
include_once "api/api.php";
$URL = SITEINFO::ADMINURL;
$api = new API();


//redirect to login page if user is not logged in
if (!$api->isloggedin) {
    header("Location: login.php");
    exit();
}

$api->makePage();


//if passed a username and user is admin, go to that users account page
if(isset($_POST['username'])) $user = $api->getUser($_POST['username']);
//else go to signed in users account page
else $user = $api->getUser($api->username);

?>

<article>
    <h3> Update User Information </h3>
    <form method="post" action="<?php echo $URL;?>?updateuser">
    <fieldset>
        <p>
        <label> Role: </label>
            <select name="role">
                <option value="user">User</option>
                <option value="admin">Admin</option> 
            </select>
        </p>

        <p><label>Username: </label> <input type="text" name="username" disabled="true" value=<?php echo $user['username'];?>> </p>
        <p><label>Password: </label> <input type='password' name='password'/></p>
        <p><label>Full name: </label> <input type="text" name="fullname" value=<?php echo $user['fullname'];?>> </p>
        <p><label>Organization: </label> <input type='text' name='organization' value=<?php echo $user['organization'];?>></p>
        <p><label>Email:</label> <input type='text' name='email' value='<?php echo $user['email'];?>'></p>

        <button type='submit' style='width:100%;'>Save Changes</button>
        </fieldset>
    </form>
</article>

<article> <h3> Admin Actions </h3>
<?php if($api->userrole=="admin") {?>
    <?php if($user['lockedout'] == true)  {
        $background = "darkred";
    } ?>



    <p> <label></label>
        <form action = "account.php?deleteuser" method="post">
            <button type="submit" style="background:darkred;"  name='todelete' value="<?php echo $user['username'] ?>">
                DELETE USER
            </button>

    </p>

    <?php 
    if(isset($_GET['deleteuser'])) {
        $api->deleteUser($_POST['todelete']);
        header("Location: adminconsole.php?getusers");
    }?>

<?php } ?>
</article>