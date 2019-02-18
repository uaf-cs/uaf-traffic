<!DOCTYPE html>
    <head>

    </head>
    <body>
        <?php
            (isset($_POST['expiration']) && $_POST['expiration'] != "") ? $expirationTime = $_POST['expiration'] : $expirationTime = 30;
            echo($expirationTime);

            class pinsDB extends SQLite3 {
                function __construct() {
                    $this -> open('../db/pins.sqlite3');
                }
            }
            $pinsDB = new pinsDB();
            if (!$pinsDB) {
                echo $pinsDB -> lastErrorMsg();
            } else {
                echo "database opened" . "<br />";
            }

            $createTable = <<<EOF
            CREATE TABLE IF NOT EXISTS pins 
            (
                pin VARCHAR(4) UNIQUE,
                expires DATETIME NOT NULL DEFAULT (DATETIME(CURRENT_TIMESTAMP, '+30 minutes'))
            );
EOF;
            
            $ret = $pinsDB->exec($createTable);
            if (!$ret) {
                echo $pinsDB -> lastErrorMsg();
            } else {
                echo "table is good to go " . "<br />";
            }
                $pin = sprintf("%04d",random_int(0000,9999));
                $insert = <<<EOF
                    INSERT INTO pins(pin, expires)
                    VALUES( $pin, DATETIME(CURRENT_TIMESTAMP, '+$expirationTime minutes'));
EOF;

            $ret = $pinsDB->exec($insert);
            if (!$ret) {
                echo $pinsDB -> lastErrorMsg();
            } else {
                echo "values inserted" . "<br />";
            }
            
            $select = <<<EOF
            SELECT * FROM pins;
EOF;
            
            $ret = $pinsDB->query($select);
            echo ("Active pins:" . "<br />");
            while($row = $ret->fetchArray(SQLITE3_ASSOC) ) {
                echo "pin = ". $row['pin'] . "<br />";
                echo "expires = ". $row['expires'] . "<br />";
             }
            
            $pinsDB -> close();
        ?>
    </body>
</html>