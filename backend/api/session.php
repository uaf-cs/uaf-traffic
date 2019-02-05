<?php
include 'authstate.php';

class Session {

    private $dbConnection;
    private $authState;

    public $id;
    public $date;
    public $manager;
    public $organization;
    public $lat;
    public $long;

    public $data;

    public function __construct($db){
        $this->dbConnection = $db;

        //temp value for testing
        $authenticated = true;

        if($authenticated){
            $this->authState = new AdminState($this);
        } else $this->authState = new UserState($this);
    }

    function create(){
        $this->authState->create();
    }

    function read() {
        
    }
}

?>