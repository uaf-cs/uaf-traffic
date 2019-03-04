<?php
include_once 'states/userstate.php';
include_once 'constants.php';

session_name(SITENAME);
session_start();

class API {
    protected $traffic_db;
    private $auth_db;
    protected $authState;

    public $isloggedin = false;
    public $userid = '';
    public $username = '';
    public $userrole = '';
    public $userfullname = '';
    public $userorganization = '';
    public $useremail = '';

    public function __construct(){
        $this->traffic_db = new SQLite3(TRAFFICDB);
        $this->auth_db = new SQLite3(AUTHDB);

        $this->getSession();
        if($this->userrole == 'admin') {
            $this->isloggedin = true;
            $this->authState = new AdminState($this);
        } 
        else if($this->userrole == 'app') {
            $this->isloggedin = true;
            $this->authState = new AppState($this);
        } 
        else $this->authState = new UserState($this);

        $this->checkForms();
        $this->setSession();
    }

    /////////////////////////////////
    //      API Utility methods   //
    ////////////////////////////////
    function post($id) {
        return isset($_POST[$id]) ? $_POST[$id] : '';
    }
    function session($id) {
        return isset($_SESSION[$id]) ? $_SESSION[$id] : '';
    }

    //checks if any functions have been called on page load
    function checkForms() {
        if(isset($_GET['login'])) $this->login(); 
        if(isset($_GET['logout'])) $this->logout(); 
        if(isset($_GET['checkpin'])) $this->checkPIN();
        if(isset($_GET['createuser'])) $this->createUser();
    }

    function getPINS() {
        return $this->authState->getPINS();
    }

    function getUsers() {
        return $this->authState->getUsers();
    }

    function getUser() {
        if(!isset($_POST['username']) || $_POST['username'] == "") 
            return;
        $name = $_POST['username'];
        return $this->authState->getUser($name);
    }

    function createUser() {
        $username = $this->post('username');
        // if($username == '' || $this->userExists($username)) {
        //     print "Invalid Username/Username exists";
        //     return;
        // }
        $hash = password_hash($this->post('password'), PASSWORD_DEFAULT);
        $sql = "INSERT INTO users (username, hash, role, fullname, organization, email, lockedout, authfailures) "
            . "VALUES (:username, :hash, :role, :fullname, :organization, :email, :lockedout, :authfailures)";        
        $stmt = $this->auth_db->prepare($sql);
        $stmt->bindValue(':username', $username);
        $stmt->bindValue(':hash', $hash);
        $stmt->bindValue(':fullname', $this->post('fullname'));
        $stmt->bindValue(':organization', $this->post('organization'));
        $stmt->bindValue(':email', $this->post('email'));
        $stmt->bindValue(':role', $this->post('role'));
        $stmt->bindValue(':lockedout', 0);
        $stmt->bindValue(':authfailures',0);
        $result = $stmt->execute();
        if (!$result) { 
            print "INSERT query failed";
            echo `whoami`;
            print "Error code: $this->lastErrorCode()} {$this->lastErrorMsg()}";
        } else {
            print "<br>Inserted new user $username";
        }
    }

    function createPIN() {
        (isset($_POST['expiration']) && $_POST['expiration'] != "") ? $expirationTime = $_POST['expiration'] : $expirationTime = 30;
        $this->authState->createPIN($expirationTime);
    }

    function deletePINS() {
        $this->authState->deletePINS();
    }

    ///////////////////////////////
    //  State altering methods   //
    //////////////////////////////
    function checkPIN() {
        $pins_db = new SQLite3(PINDB);
        $pin = isset($_POST['pin'])? $_POST['pin'] : '';
        $query = "SELECT * FROM pins "
                . "WHERE pin = :pin "
                . "AND expires > DATETIME(CURRENT_TIMESTAMP)";
        $statement = $pins_db->prepare($query);
        $statement->bindValue(':pin', $pin, SQLITE3_TEXT);
        $result = $statement->execute();

        while($row = $result->fetchArray(SQLITE3_ASSOC)) {
            $this->authState = new AppState($this);
            print "PIN accepted. Gimme the data <br />";
            return true;
        }
        $statement->close();
        $pins_db->close();

    }

    function getSession() {
        $this->userid = $this->session('userid');
        $this->username = $this->session('username');
        $this->userrole = $this->session('userrole');
        $this->userfullname = $this->session('userfullname');
        $this->userorganization = $this->session('userorganization');
        $this->useremail = $this->session('useremail'); 
    }
    
    function setSession() {
        $_SESSION['userid'] = $this->userid;
        $_SESSION['username'] = $this->username;
        $_SESSION['userrole'] = $this->userrole;
        $_SESSION['userfullname'] = $this->userfullname;
        $_SESSION['userorganization'] = $this->userorganization;
        $_SESSION['useremail'] = $this->useremail;
    }

    function login() {
        if($this->isAuthorized()) {
            $this->isloggedin = true;
            if($this->userrole == 'admin') {
                $this->authState = new AdminState($this);
            } else if ($this->userrole == 'app') {
                $this->authState = new AppState($this);
            }
        } 
    }
    
    private function isAuthorized() {
        $username = isset($_POST['username'])? $_POST['username'] : '';
        $password = isset($_POST['password'])? $_POST['password'] : '';
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $sql = "SELECT * FROM users "
            . "WHERE username = :username AND lockedout = 0";
        $stmt = $this->auth_db->prepare($sql);
        if(!$stmt) {
            print "could not prepare statement";
            print "'" . $sql . "'";
            return;
        }

        $stmt->bindValue(':username', $username, SQLITE3_TEXT);
        $result = $stmt->execute();
        if($result->numColumns()) {
            while($row = $result->fetchArray()) {
                $hash = $row['hash'];
                if(!password_verify($password, $hash)) {
                    return false;
                }
                $this->userid = $row['id'];
                $this->username = $row['username'];
                $this->userrole = $row['role'];
                $this->userfullname = $row['fullname'];
                $this->userorganization = $row['organization'];
                $this->useremail = $row['email'];
                $this->setSession();          
                return true;
            }
            print "<br>Account locked or does not exist\n";
            return false;
        } else {
            print "<br>Log in to continue\n";
            return false;
        }
    }

    function logout() {
        $this->authState = new UserState($this);
        $this->isloggedin = false;
        session_unset();
        session_destroy();
        $this->getSession();
        session_start();
    }
}
?>