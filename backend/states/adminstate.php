<?php
//Overrides API actions for users logged in as Admin
class AdminState extends UserState {

    private $pin_db;
    private $auth_db;
    private $traffic_db;

    function __construct(API $api) {
        parent::__construct($api);
        $this->pin_db = new SQLite3(PINDB);
        $this->auth_db = new SQLite3(AUTHDB);
    }

    function createUser() {
        $username = $this->api->post('username');
        $username = preg_replace(
            "/(\t|\n|\v|\f|\r| |\xC2\x85|\xc2\xa0|\xe1\xa0\x8e|\xe2\x80[\x80-\x8D]|\xe2\x80\xa8|\xe2\x80\xa9|\xe2\x80\xaF|\xe2\x81\x9f|\xe2\x81\xa0|\xe3\x80\x80|\xef\xbb\xbf)+/",
            "_",
            $username
        );
        if ($username == '' || $this->api->userExists($username)) {
            print "$username is an invalid username, try again";
            return;
        }
        $hash = password_hash($this->api->post('password'), PASSWORD_DEFAULT);
        $sql = "INSERT INTO users (username, hash, role, fullname, organization, email, lockedout, authfailures) "
            . "VALUES (:username, :hash, :role, :fullname, :organization, :email, :lockedout, :authfailures)";
        $stmt = $this->auth_db->prepare($sql);
        $stmt->bindValue(':username', $username);
        $stmt->bindValue(':hash', $hash);
        $stmt->bindValue(':fullname', $this->api->post('fullname'));
        $stmt->bindValue(':organization', $this->api->post('organization'));
        $stmt->bindValue(':email', $this->api->post('email'));
        $stmt->bindValue(':role', $this->api->post('role'));
        $stmt->bindValue(':lockedout', 0);
        $stmt->bindValue(':authfailures', 0);
        $result = $stmt->execute();
        if (!$result) {
            print "INSERT query failed";
            echo `whoami`;
            print "Error code: $this->lastErrorCode()} {$this->lastErrorMsg()}";
        } else {
            print "<br>Inserted new user $username";
        }
    }

    function deleteUser(&$username) {
        print $username . " deleted";
        $sql = $this->auth_db->prepare("DELETE FROM users WHERE username = :username");
        $sql->bindValue(':username', $username);
        $result = $sql->execute();
        return $this->prepareData($result);
    }

    function getUsers() {
        $sql = $this->auth_db->prepare('SELECT * FROM users;');
        $result = $sql->execute();

        return $this->prepareData($result);
    }

    function getUser(&$username) {
        $stmt = $this->auth_db->prepare("SELECT * FROM users WHERE username = :username");
        $stmt->bindValue(':username', $username);
        $result = $stmt->execute();

        return $this->prepareData($result);
    }

    function createPIN(&$expirationTime) {
        $pin = sprintf("%04d", random_int(0000,9999));
        $insert = <<<EOF
        INSERT INTO pins(pin, expires)
        VALUES( $pin, DATETIME(CURRENT_TIMESTAMP, '+$expirationTime minutes'));
EOF;

       if($this->pin_db->exec($insert)) {
            $result = "<br/> PIN Created: <br/> "
                    . "<p style='color:midnightblue; font-size:30px;'> " . $pin . "<p>"
                    . "<p style='font-size:15px;'> expires in " . $expirationTime . " minutes <br/>";
            print $result;
        }
    }

    function getPINS() {
        $statement = $this->pin_db->prepare("SELECT * FROM pins");
        $result = $statement->execute();

        return $this->prepareData($result);
    }

    function getPIN(&$pin) {
        $stmt = $this->pin_db->prepare("SELECT * FROM pins WHERE pin = :pin");
        $stmt->bindValue(':pin', $pin);
        $result = $stmt->execute();
 
        return $this->prepareData($result);
    }

    function deletePINS() {
        $stmt = $this->pin_db->prepare("DELETE FROM pins");
        $result = $stmt->execute();

    }

    function makePage() {
        ?>
        <body>
        <div class="header">

            <div class="leftbox">
                <h3>UAFTRAFFIC</h3>
                <p>Admin Console <p>
            </div>

            <div class="rightbox">
                <?php 
                print "<p style= 'font-size:20px;'>" . $this->api->userfullname . "</p>";
                print "<p style= 'font-size:18px; color:orange;'>" . $this->api->userrole; ?>
            </div>
        </div>
        <div class="navbar">
            <form method="post" action="<?php echo ACCOUNTURL; ?>">
                <button type="submit">Account</button>
            </form>
            <form method="post" action="<?php echo ADMINURL; ?>?logout">
                <button type="submit">Logout</button>
            </form>

        </div>

        <div class="main">
            <div class="sidebar">
                <form method="post" action="<?php echo ADMINURL; ?>?datamenu">
                    <button type="submit">View Traffic Data</button>
                </form>

                <form method="post" action="<?php echo ADMINURL; ?>?pinmenu">
                    <button type="submit">Manage PINs</button>
                </form>

                <form method="post" action="<?php echo ADMINURL; ?>?accountmenu">
                    <button type="submit">Manage User Accounts</button>
                </form>
            </div>

            <div class="mainbody">
        <?php
    }

}
?>