<?php

class TrafficDB extends SQLite3 {

    function __construct() {
        $this->open("/var/www/html/uaftraffic/backend/db/uaftraffic.sqlite3");
    }
}
