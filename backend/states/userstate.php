<?php
include_once 'adminstate.php';
include_once 'appstate.php';

//Defines API actions allowed for all users
class UserState {

    private $api;

    function __construct(API $api) {
        $this->api = $api;
    }

    /////////////////////////////
    //Private Utility Functions//
    /////////////////////////////
    private function error() {
        http_response_code(403);
        echo json_encode(array("message" => "Authentication required"));
    }


    ///////////////////////////////////////////////////////////////////
    // API Methods requiring admin return 403 error unless logged in //
    //////////////////////////////////////////////////////////////////
    function upload() { $this->error(); }
    function delete() { $this->error(); }
    function getUsers() { $this->error(); }
    function addUser() { $this->error(); }
    function userExists($username) { $this->error(); }


    //////////////////////////////
    //   Public API Functions  //
    ////////////////////////////
    public function readAll() {
        $db = $this->api->traffic_db;

        $sql = $db->prepare('SELECT * from users;');
        $result = $sql->execute();
        echo "<pre>";
        print_r($result->fetchArray());
        echo "</pre>";
    }
}

?>