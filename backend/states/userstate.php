<?php
include_once 'adminstate.php';
include_once 'appstate.php';

//Defines API actions allowed for all users
class UserState {

    protected $api;
    private $traffic_db;

    function __construct(API $api) {
        $this->api = $api;
        $this->traffic_db = new SQLite3(TRAFFICDB);
    }

    /////////////////////////////
    //Private Utility Functions//
    /////////////////////////////
    private function error() {
        http_response_code(403);
        echo json_encode(array("message" => "Authentication required"));
    }

    protected function prepareData(&$result) {
        $ret = array();

        while($row = $result->fetchArray(SQLITE3_ASSOC)) {
            array_push($ret, $row);
        }
        if(!array_filter($ret)) print "<p style='color: darkred'>Not Found";
        return $ret;
    }


    ///////////////////////////////////////////////////////////////////
    // API Methods requiring admin return 403 error unless logged in //
    //////////////////////////////////////////////////////////////////
    function upload() { $this->error(); }
    function delete() { $this->error(); }
    function getUsers() { $this->error(); }
    function addUser() { $this->error(); }
    function userExists($username) { $this->error(); }
    function createPIN(&$pin) { $this->error(); }


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

    public function readData() {
        $statement = $this->traffic_db->prepare("SELECT * FROM users"); //placeholder until traffic data created
        $result = $statement->execute();
        return $this->prepareData($result);
    }
}

?>