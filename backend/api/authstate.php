<?php

//base class for keeping track of user's authentication and allowed actions
abstract class AuthState {

    protected $session;

    protected function __construct(Session $session) {
        $this->session = $session;
    }

    //abstract functions for operations that depend on state
    abstract public function create($data): void;
    abstract public function delete(): void;

    //functions that can be used by all users
    public function read():void {

    }
}

//defines actions taken for normal users
class UserState extends AuthState {
    
    private function error() {
        http_response_code(403);
        echo json_encode(array("message" => "Authentication required"));
    }

    function create($data): void {
        error();
    }

    function delete(): void {
        error();
    }


}

//defines actions allowed to be taken when user is logged in as admin
class AdminState extends AuthState {
    
    function create($data): void {
        //$query = ""
    }

    function delete(): void {

    }
}

?>