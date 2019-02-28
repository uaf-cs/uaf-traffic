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
        <div id="logo">UAFTRAFFIC Admin Console </div>
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
            <form method="post" action= "<?php echo $URL;?>?pinmenu">
            <button type="submit">PIN options</button>
            </form>
            <li> 
            <form method="post" action="<?php echo $URL;?>?accountmenu">
            <button type="submit">Manage User/Admin Accounts</button>
            </form>
        </ul>
		</nav> 
</section>

<?php
////////////////
//  PIN Menu //
///////////////
if(isset($_GET['pinmenu']) or isset($_GET['getpins'])) {
?>
<article>
<h3> Check PIN Status: </h3> 
    <form action = "<?php echo $URL;?>?checkpin" method="post">
            <input type='text' name='pin'>
            <button type='submit'>Check PIN </button>
    </form>
</article>

<article>
<h3> Create pin </h3>
    <form action = "<?php echo $URL;?>?createpin" method="post">
            Expiration time (minutes):
            <input type="number" name="expiration" value="expiration"/>
            <input type="submit" value="Create PIN"/>
    </form>
</article>

<article>
    <h3> View Active PINS </h3>
    <form method="post" action="<?php echo $URL;?>?getpins">
                    <button type="submit">View All</button>
    </form>
    <?php 
    if(isset($_GET['getpins'])) {
        print "<pre>";
        print_r($api->getPINS());
        print "</pre>";
    }?>

 </article>

<?php
}

////////////////
//  PIN Menu //
///////////////
if(isset($_GET['accountmenu'])) {
    print "<form action='${URL}?getusers' method='post'>\n";  
}
?>
</body>
</html>