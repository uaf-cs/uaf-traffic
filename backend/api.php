<?php
include_once 'trafficdb.php';
include_once 'authstate.php';

class API {

    private $db;
    private $authState;

    public function __construct($db){
        $this->db = $db;

        //temp value until authentication is implemented
        $authenticated = true;

        if($authenticated){
            $this->authState = new AdminState($this);
        } else $this->authState = new UserState($this);
    }

    function create(){
        $this->authState->create();
    }

    function read() {
        $this->authState->read();
    }
}

?>