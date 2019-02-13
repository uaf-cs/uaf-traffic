<?php    

session_start();

class AuthDB extends SQLite3
{
    function __construct() {
        parent::__construct("/var/www/html/uaftraffic/backend/db/uaftraffic.sqlite3");
        if(!$this->exists()) {
            print "Database error";
        }
    }
    function isAuthorized() {
        $username = isset($_POST['username'])? $_POST['username'] : '';
        $password = isset($_POST['password'])? $_POST['password'] : '';
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $sql = "SELECT * FROM users "
            . "WHERE username = :username AND lockedout = 0";
        $stment = $this->prepare($sql);
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
                if(password_verify($password, $hash)) {
                    return true;
                } else return false;
            }
            print "<br>Account locked or does not exist\n";
            return false;
        } else {
            print "<br>Account locked or does not exist\n";
            return false;
        }
    }
}
?>