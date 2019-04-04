<?php

class SITEINFO {

    const ROOTDIR = "/var/www/html/backend/";

    const AUTHDB = self::ROOTDIR . "db/auth.sqlite3";
    const TRAFFICDB = self::ROOTDIR . "db/session.sqlite3";
    const PINDB = self::ROOTDIR . "db/pins.sqlite3";
    const SITENAME = "UAFTRAFFIC";
    const ADMINURL =  "adminconsole.php";
    const DATAURL =  'trafficdata.php';
    const ACCOUNTURL =  "account.php";
    const LOGINURL = "login.php";
    const FORGOT =  "forgot.php";

}

?>  