<?php
//Overrides API actions for users logged in as Admin
class AdminState extends UserState {
    
    function upload(){}
    function delete() {}

    function getUsers() {
        $db = $this->api->auth_db;

        $sql = $db->prepare('SELECT * from users;');
        $result = $sql->execute();
        echo "<pre>";
        print_r($result->fetchArray());
        echo "</pre>";
        return $result;
    }

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

    function userExists($username) {
        $sql = "SELECT username FROM users WHERE username = :username";
        $stmt = $this->prepare($sql);
        $stmt->bindValue(':username', $username);
        $result = $stmt->execute();
        if ($result->numColumns()) {
            while ($row = $result->fetchArray()) {
                return true;
            }
        }
        return false;
    }

}
?>