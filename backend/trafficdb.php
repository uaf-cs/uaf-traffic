<?php

class TrafficDB extends SQLite3 {

    function __construct() {
        $this->open("db/uaftraffic.sqlite3");
    }
}
