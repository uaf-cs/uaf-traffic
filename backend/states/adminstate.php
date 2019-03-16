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

    function upload(){}
    function delete() {}

    function addUser() {
        $username = $this->post('username');

        if($username == '') {
            print "Username is required";
            return;
        }
        if($this->userExists($username)) {
            print "<br>Username $username already exists";
            return;
        }

        $password = $this->post('password');
        $fullname = $this->post('fullname');
        $organization = $this->post('organization');
        $email = $this->post('email');
        $lockedout = 0;
        $authfailures = 0;
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $sql = "INSERT INTO users (username, hash, role, fullname, organization, email, lockedout, authfailures) "
            . "VALUES (:username, :hash, :role, :fullname, :organization, :email, :lockedout, :authfailures)";        
        $stmt = $this->prepare($sql);
        $stmt->bindValue(':username', $username);
        $stmt->bindValue(':hash', $hash);
        $stmt->bindValue(':fullname', $fullname);
        $stmt->bindValue(':organization', $organization);
        $stmt->bindValue(':email', $email);
        $stmt->bindValue(':lockedout', $lockedout);
        $stmt->bindValue(':authfailures', $authfailures);
        $result = $stmt->execute();
        if (!$result) { 
            print "INSERT query failed";
            echo `whoami`;
            print "Error code: $this->lastErrorCode()} {$this->lastErrorMsg()}";
        } else {
            $lastId = $this->lastInsertRowID();
            print "<br>Inserted new user $lastId";
        }

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

}
?>