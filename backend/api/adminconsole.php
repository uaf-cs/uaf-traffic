<?php
include_once '../api.php';

$URL = 'adminconsole.php';

$api = new API();

//redirect to login page if user is not logged in
if (!$api->isloggedin) {
    header("Location: login.php");
    exit();
}
?>


<!doctype html>
<link rel ="stylesheet" href="style.css">
<title>UAFTRAFFIC</title>

<body>
	<header>
        <div id="logo"><h3 style='color:goldenrod;'>UAFTRAFFIC</h3> Admin Console </div>
		<nav>
            <?php 
                print $api->userfullname . "<br/>";
                print "<p style= 'color:orange;'>" . $api->userrole; ?> <br/>

			<ul>
            <li>
            <form method="post" action="<?php echo $URL;?>?logout">
            <button type="submit">Logout</button>
            </form>
            </ul>
		</nav>
</header>
<section>
        <nav>  
        <ul>
            <li>
                <form method="post" action="<?php echo $URL;?>?datamenu">
                <button type="submit">View Traffic Data</button>
                </form>

            </li>
            <li> 
                <form method="post" action= "<?php echo $URL;?>?pinmenu">
                <button type="submit">Create PIN</button>
                </form>
            </li>
            <li>
                <form method="post" action="<?php echo $URL;?>?accountmenu">
                <button type="submit">Manage User/Admin Accounts</button>
                </form>
            </li>
        </ul>
		</nav> 
</section>

<?php
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
            <input type="number" name="expiration" value="expiration"/>
            <input type="submit" value="Create PIN"/>
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
    <h3> View User Accounts </h3>
    <form method="post" action="<?php echo $URL;?>?getusers">
                    <button type="submit">View All</button>
    </form>
    <?php 
    if(isset($_GET['getusers'])) {
        print "<pre>";
        print_r($api->getUsers());
        print "</pre>";
    }?>

 </article>

<article>
    <h3> Create User </h3>
    <form method="post" action="<?php echo $URL;?>?createuser">
        <table>
            <tr>
                <td>Username: <input type='text' name='username'/></td>
                <td>Password: <input type='password' name='password'/></td>
                <td>Full name: <input type='text' name='fullname'/></td>
            </tr>
            <tr>
                <td>
                    Role: 
                    <select name="role">
                        <option value="admin">Admin</option> 
                        <option value="user">User</option>
                    </select>
                </td>
                <td>Organization: <input type='text' name='organization'/></td>
                <td>Email: <input type='text' name='email'/></td>
            </tr>
            <td><button type='submit'>Submit</button></td>
        </table>
    </form>
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