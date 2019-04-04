<?php
include_once 'siteinfo.php';
include_once 'states/userstate.php';


session_name(SITEINFO::SITENAME);
session_start();

class API
{
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
    public $lockedout = false;

    public function __construct()
    {
        $this->traffic_db = new SQLite3(SITEINFO::TRAFFICDB);
        $this->auth_db = new SQLite3(SITEINFO::AUTHDB);

        $this->getSession();
        if ($this->userrole == 'admin') {
            $this->isloggedin = true;
            $this->authState = new AdminState($this);
        } else if ($this->userrole == 'app') {
            $this->isloggedin = true;
            $this->authState = new AppState($this);
        } else $this->authState = new UserState($this);

        $this->checkForms();
        $this->setSession();
    }

    /////////////////////////////////
    //      API Utility methods   //
    ////////////////////////////////
    function post($id)
    {
        return isset($_POST[$id]) ? $_POST[$id] : '';
    }
    function session($id)
    {
        return isset($_SESSION[$id]) ? $_SESSION[$id] : '';
    }


    //checks if any functions have been called on page load
    function checkForms()
    {
        if (isset($_GET['login'])) $this->login();
        if (isset($_GET['logout'])) $this->logout();
        if (isset($_GET['checkpin'])) $this->checkPIN();
        if (isset($_GET['createuser'])) $this->createUser();
        if (isset($_GET['forgot'])) $this->forgotPass();
    }


    //////////////////////////////////////
    //   AuthState Deferred Functions   //
    /////////////////////////////////////
    function makePage() { $this->authState->makePage(); }
    function upload(&$jsonData) { $this->authState->upload($jsonData); }
    function getPINS() { return $this->authState->getPINS(); }
    function getUsers() { return $this->authState->getUsers(); }
    function getUser(&$username) { return $this->authState->getUser($username); }
    function createUser() { $this->authState->createUser(); }
    function deleteUser(&$username) { $this->authState->deleteUser($username); }
    function deletePINS() { $this->authState->deletePINS(); }
    function readData() { return $this->authState->readData(); }

    function userExists($username)
    {
        $query = "SELECT * FROM users "
            . "WHERE username = :username";
        $statement = $this->auth_db->prepare($query);
        $statement->bindValue(':username', $username);
        $result = $statement->execute();
        $row = $result->fetchArray(SQLITE3_ASSOC);
        return !empty($row);
    }

    function createPIN()
    {
        (isset($_POST['expiration']) && $_POST['expiration'] != "") ? $expirationTime = $_POST['expiration'] : $expirationTime = 30;
        $this->authState->createPIN($expirationTime);
    }


    ///////////////////////////////
    //  State altering methods   //
    //////////////////////////////
    function checkPIN(&$pin)
    {
        $pins_db = new SQLite3(SITEINFO::PINDB);
        $pin = isset($_POST['pin']) ? $_POST['pin'] : $pin;
        $query = "SELECT * FROM pins "
            . "WHERE pin = :pin "
            . "AND expires > DATETIME(CURRENT_TIMESTAMP)";
        $statement = $pins_db->prepare($query);
        $statement->bindValue(':pin', $pin, SQLITE3_TEXT);
        $result = $statement->execute();

        $row = $result->fetchArray(SQLITE3_ASSOC);
        if(count($row) > 1) {
            $this->isloggedin = True;
            $this->userrole = 'app';
            $this->setSession();
            $this->authState = new AppState($this);
            return http_response_code(200);
            
        }else http_response_code(403);

        $statement->close();
        $pins_db->close();
        
    }

    function getSession()
    {
        $this->userid = $this->session('userid');
        $this->username = $this->session('username');
        $this->userrole = $this->session('userrole');
        $this->userfullname = $this->session('userfullname');
        $this->userorganization = $this->session('userorganization');
        $this->useremail = $this->session('useremail');
    }

    function setSession()
    {
        $_SESSION['userid'] = $this->userid;
        $_SESSION['username'] = $this->username;
        $_SESSION['userrole'] = $this->userrole;
        $_SESSION['userfullname'] = $this->userfullname;
        $_SESSION['userorganization'] = $this->userorganization;
        $_SESSION['useremail'] = $this->useremail;
    }

    function login()
    {
        if ($this->isAuthorized()) {
            $this->isloggedin = true;
            if ($this->userrole == 'admin') {
                $this->authState = new AdminState($this);
            } else if ($this->userrole == 'app') {
                $this->authState = new AppState($this);
            }
        }
    }

    private function isAuthorized()
    {
        $username = isset($_POST['username']) ? $_POST['username'] : '';
        $password = isset($_POST['password']) ? $_POST['password'] : '';
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $sql = "SELECT * FROM users "
            . "WHERE username = :username AND lockedout = 0";
        $stmt = $this->auth_db->prepare($sql);
        if (!$stmt) {
            print "could not prepare statement";
            print "'" . $sql . "'";
            return;
        }

        $stmt->bindValue(':username', $username, SQLITE3_TEXT);
        $result = $stmt->execute();
        if ($result->numColumns()) {
            while ($row = $result->fetchArray()) {
                $hash = $row['hash'];
                if (!password_verify($password, $hash)) {
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

    function logout()
    {
        $this->authState = new UserState($this);
        $this->isloggedin = false;
        session_unset();
        session_destroy();
        $this->getSession();
        session_start();
    }
    function forgotPass() 
    {
        $useremail = $this->post('email');
        if($this->emailExists()) {
            // $to = $email;
            $subject = "UAFTraffic password change request";
            $txt = "We have a password change request for you.";
            $headers = "From: noreply@uaftraffic.org";

            mail($useremail,$subject,$txt,$headers);
        }
        print("Email sent!");
    }


    function emailExists($useremail) 
    {
        $query = "SELECT * FROM users "
            . "WHERE email = :email";
        $statement = $this->auth_db->prepare($query);
        $statement->bindValue(':email', $useremail);
        $result = $statement->execute();
        $row = $result->fetchArray(SQLITE3_ASSOC);
        return !empty($row);    
    }
}
?> 