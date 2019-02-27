<?php
include_once 'states/userstate.php';
include_once 'constants.php';

session_name(SITENAME);
session_start();

class API {
    private $traffic_db;
    private $auth_db;
    private $pins_db;
    private $authState; //controls CRUD operations

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
        $this->pins_db = new SQLite3("../db/pins.sqlite3");

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
        if(isset($_GET['adduser'])) $this->authState->addUser();
        if(isset($_GET['readall'])) $this->authState->readAll();
        if(isset($_GET['upload'])) $this->authState->upload();
        if(isset($_GET['getUsers'])) $this->authState->getUsers();
    }

    ///////////////////////////////
    //  State altering methods   //
    //////////////////////////////
    function checkPIN() {
        $pin = isset($_POST['pin'])? $_POST['pin'] : '';
        $query = "SELECT * FROM pins "
                . "WHERE pin = :pin "
                . "AND expires > DATETIME(CURRENT_TIMESTAMP)";
        $statement = $this->pins_db->prepare($query);
        if(!$statement) {
            print "could not prepare PIN query";
            return;
        }
        $statement->bindValue(':pin', $pin, SQLITE3_TEXT);
        $result = $statement->execute();

        while($row = $result->fetchArray(SQLITE3_ASSOC)) {
            $this->authState = new AppState($this);
            print "PIN accepted. Gimme the data <br />";
            return true;
        }
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