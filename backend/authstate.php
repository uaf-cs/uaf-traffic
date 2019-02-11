<?php
include_once 'api.php';

//base class for keeping track of user's authentication and allowed actions
abstract class AuthState {

    public $api;

    function __construct(API $api) {
        $this->api = $api;
    }

    //abstract functions for operations that depend on state
    abstract public function create($data);
    abstract public function delete();

    //functions that can be used by all users
    public function read() {
        $db = $this->api->db;

        $sql = $db->prepare('SELECT * from users;');
        $result = $sql->execute();
        var_dump($result->fetchArray());
        return $result;
    }
}

//defines actions taken for normal users
class UserState extends AuthState {
    
    private function error() {
        http_response_code(403);
        echo json_encode(array("message" => "Authentication required"));
    }

    function create($data){
        error();
    }

    function delete(){
        error();
    }


}

//defines actions allowed to be taken when user is logged in as admin
class AdminState extends AuthState {
    
    function create($data){
        //$query = ""
    }

    function delete() {

    }
}

?>