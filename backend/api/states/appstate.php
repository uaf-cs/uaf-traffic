<?php
//state for ipads that have entered the correct pin
//allows data upload from the app
include_once "api/constants.php";

class AppState extends UserState {
    private $traffic_db;

    function __construct(API $api) {
        parent::__construct($api);
        $this->traffic_db = new SQLite3(TRAFFICDB);
    }


    function upload(&$jsonData) {
        $sql = "INSERT INTO session (date, lat, long, crossing) "
                . "VALUES (DATETIME(CURRENT_TIMESTAMP), :lat, :long, :crossing)";
        $stmt = $this->traffic_db->prepare($sql);
        
        $data = json_decode($jsonData);

        $stmt->bindValue(':lat', $data->lat);
        $stmt->bindValue(':long', $data->long);
        $stmt->bindValue(':crossing', $data->crossings);
        
        $result = $stmt->execute();
        if($result) {
            return http_response_code(200);
        } else return http_response_code(403);
    }

}
?>

