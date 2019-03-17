<!doctype html>
<link rel ="stylesheet" href="style.css">
<title>UAFTRAFFIC</title>
<?php
include_once '../api.php';

$URL = 'adminconsole.php';
$api = new API();

//redirect to login page if user is not logged in
if (!$api->isloggedin) {
    header("Location: login.php");
    exit();
}
$api->makePage();

////////////////
//  PIN Menu //
///////////////
if(isset($_GET['pinmenu']) or isset($_GET['getpins']) or isset($_GET['createpin']) or isset($_GET['deletepins'])) {
?>
<article>
<h3> Check PIN Status: </h3> 
    <form action = "<?php echo $URL;?>?checkpin" method="post">
            <input type='text' name='pin'>
            <button type='submit'>Check PIN </button>
    </form>
</article>

<article>
<h3> Create PIN </h3>
    <form action = "<?php echo $URL;?>?createpin" method="post">
            Expiration time (minutes):
            <input type="number" min="1" max="60" step="1" value = "1" name="expiration">
            <button type="submit">Create PIN</button>
    </form>
    <?php
        if(isset($_GET['createpin'])) {
            print "<pre>";
            print $api->createPIN();
            print "</pre>";
        }?>
</article>

<article>
    <h3> View Active PINs </h3>
    <form method="post" action="<?php echo $URL;?>?getpins">
                    <button type="submit">View All</button>
    </form>
    <?php 
    if(isset($_GET['getpins'])) {
        $results = $api->getPINS();

        foreach($results as & $row) {
            print "<article> PIN: ";
            print "<p style='color:midnightblue; font-size:30px;'> " . $row['pin'] . "<p>"
            . "<p style='font-size:15px;'> expires:<br/> " . $row['expires'] . "<br/>";
            print "</article>";
        }
    }?>

 </article>

 <article>
    <h3> Delete All PINs </h3>
    <form method="post" action="<?php echo $URL;?>?deletepins">
                    <button type="submit">Delete All</button>
    </form>
    <?php 
    if(isset($_GET['deletepins'])) {
        print "<pre>";
        print_r($api->deletePINS());
        print "</pre>";
    }?>

 </article>

<?php
}

////////////////////
//  Account Menu //
///////////////////
if(isset($_GET['accountmenu']) || isset($_GET['getusers']) || isset($_GET['getuser'])) {
?>

<article>
    <h3> Find User </h3>
    <form action = "<?php echo $URL;?>?getuser" method="post">
            <input type='text' name='username'>
            <button type='submit'>Find username </button>
    </form>
    <?php 
    if(isset($_GET['getuser'])) {
        print "<pre>";
        print_r($api->getUser());
        print "</pre>";
    }?>

 </article>

<article>
    <h3> Create User </h3>
    <form method="post" action="<?php echo $URL;?>?createuser">
    <fieldset>

        <p>
        <label> Role: </label>
            <select name="role">
                <option value="user">User</option>
                <option value="admin">Admin</option> 
            </select>
        </p>

        <p><label> Username:</label> <input type='text' name='username'/></p>
        <p><label>Password:</label> <input type='password' name='password'/></p>
        <p><label>Full name:</label> <input type='text' name='fullname'/></p>
        <p><label> Organization: </label> <input type='text' name='organization'/></p>
        <p><label>Email:</label> <input type='text' name='email'/></p>

        <button type='submit' style='width:100%;'>Create Account</button>
        </fieldset>
    </form>
</article>

<article>
    <h3> View User Accounts </h3>
    <form method="post" action="<?php echo $URL;?>?getusers">
                    <button type="submit">View All</button>
    </form>
    <?php 
    if(isset($_GET['getusers'])) {
        $results = $api->getUsers();
        ?>
        
        <table>
            <tr>
                <th> Name </th>
                <th> Username </th>
                <th> Role </th>
                <th> Organization </th>
                <th> Email </th>
            </tr>
    <?php
        foreach($results as & $row) {
            print("<tr>");
            print("<td class='name'>" . $row['fullname'] . "</td>");
            print("<td>" . $row['username'] . "</td>");
            print("<td>" . $row['role'] . "</td>");
            print("<td>" . $row['organization'] . "</td>");
            print("<td>" . $row['email'] . "</td>");
            print("</tr>");
        }
    }
?>
    </table>
    </article>
<?php
}

////////////////////
//  Account Menu //
///////////////////
if(isset($_GET['datamenu'])) {
?>
<pre>
    <?php print_r($api->readData()); ?>
</pre>



<?php
}?>
</body>
</html>