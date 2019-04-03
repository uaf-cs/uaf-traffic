<?php
include_once 'adminstate.php';
include_once 'appstate.php';

//Defines API actions allowed for all users
class UserState {

    protected $api;
    private $traffic_db;

    function __construct(API $api) {
        $this->api = $api;
        $this->traffic_db = new SQLite3(SITEINFO::TRAFFICDB);
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
            $ret[] = $row;
        }
        if(!array_filter($ret)) print "<p style='color: darkred'>Not Found";
        
        if (count($ret) >1) return $ret; //AAAAAAAAAAAAAAHHHHHHHH
        else return $result->fetchArray(SQLITE3_ASSOC);
    }


    ///////////////////////////////////////////////////////////////////
    // API Methods requiring admin return 403 error unless logged in //
    //////////////////////////////////////////////////////////////////
    function upload(&$jsonData) { $this->error(); }
    function delete() { $this->error(); }
    function getUsers() { $this->error(); }
    function createUser() { $this->error(); }
    function getPINS() { $this->error(); }
    function getPIN(&$pin) { $this->error(); }
    function deleteUser(&$username) { $this->error(); }
    function userExists($username) { $this->error(); }
    function createPIN(&$pin) { $this->error(); }
    
    function makePage() {
        ?>
        <body>
        <div class="header">

            <div class="leftbox">
                <h3>UAFTRAFFIC</h3>
                <p>Admin Console <p>
            </div>

            <div class="rightbox">
            </div>
        </div>
        <div class="navbar">
            <form method="post" action="<?php echo SITEINFO::LOGINURL; ?>">
                <button type="submit">Sign In</button>
            </form>
            <form method="post" action="<?php echo SITEINFO::ADMINURL; ?>?register">
                <button type="submit">Register</button>
            </form>
            <form method="post" action="<?php echo FORGOT; ?>">
                <button type="submit"> Forgot Password </button>
            </form>

        </div>

        <div class="main">
            <div class="sidebar">
                <form method="post" action="<?php echo SITEINFO::DATAURL?>">
                    <button type="submit">View Traffic Data</button>
                </form>
            </div>

            <div class="mainbody">
        <?php
    }


    //////////////////////////////
    //   Public API Functions  //
    ////////////////////////////
    public function readData() {
        $statement = $this->traffic_db->prepare("SELECT * FROM session"); //placeholder until traffic data created
        $result = $statement->execute();
        return $this->prepareData($result);
    }
}

?>