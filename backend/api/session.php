<?php

class Session extends APIbase{

    private $dbConnection;

    public $id;
    public $date;
    public $manager;
    public $organization;
    public $lat;
    public $long;

    public $data;

    public function __construct($db){
        $this->dbConnection = $db;
    }


    function create(){
        //sql stuff
        return;
    }

    function get(){
        //sql stuff
        return;
    }

    function post() {
        //sql stuff
        return;
    }

    function update() {
        //sql stuff
        return;
    }

    function delete() {
        //sql stuff
        return;
    }
}



?>