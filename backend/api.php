<?php
include_once 'trafficdb.php';
include_once 'authstate.php';

class API {

    public $traffic_db;
    public $auth_db;
    
    public $authState;

    public function __construct($db){
        $this->traffic_db = $db;
        $this->auth_db = new AuthDB();
        $this->authState = new UserState($this);
    }

    function create() {
        $this->authState->create();
    }

    function read() {
        $this->authState->read();
    }

    function login() {
        if($this->auth_db->isAuthorized()) {
            $this->authState = new AdminState($this);
        } 
    }

    function logout() {
        $this->authState = new UserState($this);
    }
}
?>