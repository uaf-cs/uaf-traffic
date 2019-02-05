<?php

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
        $this->authState = new UserState($this);
    }

    function changeState(AuthState $newState) {
        $this->authState = $newState;
    }

    function create(){
        $this->authState->create();
    }
}

abstract class AuthState {

    protected $session;

    protected function __construct(Session $session) {
        $this->session = $session;
    }
    abstract public function login(): void;
    abstract public function logout(): void;
    abstract public function create(): void;
    abstract public function read(): void;
    abstract public function update(): void;
    abstract public function delete(): void;
}

class UserState extends AuthState {

    function login() {
        //if successful
        $this->session->changeState(new AdminState());
    }

    function logout() {
        return;
    }

    function create() {
        //echo not allowed
        //return 400 error
    }
}

class AdminState extends AuthState {
    
    function login() {
        return;
    }
    function logout() {
        $this->session->changeState(new UserState());
    }
    function create() {
        //do sql stuff
    }
}

?>