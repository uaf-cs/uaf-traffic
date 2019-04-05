<?php
class TrafficSession {
    const vehicleArray = ['atv'=> 0,'bike'=> 0, 'car'=> 0, 'pedestrian'=> 0, 'snowmachine'=> 0];

    public $date;
    public $lat;
    public $lon;
    public $id;
    
    public $vehicleCount = self::vehicleArray;

    //first letter is from
    //second letter is to
    //example "NS" == from North to South
    public $directionalCount = [
        'nn' => self::vehicleArray,
        'ne' => self::vehicleArray,
        'ns' => self::vehicleArray,
        'nw' => self::vehicleArray,
    
        'en' => self::vehicleArray,
        'ee' => self::vehicleArray,
        'es' => self::vehicleArray,
        'ew' => self::vehicleArray,
    
        'sn' => self::vehicleArray,
        'se' => self::vehicleArray,
        'ss' => self::vehicleArray,
        'sw' => self::vehicleArray,
    
        'wn' => self::vehicleArray,
        'we' => self::vehicleArray,
        'ws' => self::vehicleArray,
        'ww' => self::vehicleArray,
    ];

    public function __construct($data) {
        $this->date = $data['date'];
        $this->lat = $data['lat'];
        $this->lon = $data['lon'];
        $this->id = $data['id'];

        $crossings = json_decode($data['crossing'], TRUE);

        foreach($crossings as $row) {
            $this->addEvent($row['type'], $row['from'], $row['to'], $row['time']);
        }
    }

    public function addEvent($type, $from, $to, $time) {
        $this->vehicleCount[$type]++;

        $direction = $from . $to;
        $this->directionalCount[$direction][$type]++;

        //print "total: ". $this->vehicleCount[$type] . "<br>";
        //print $this->directionalCount[$direction][$type] . "<br>";
    }

    //returns vehicleArray for given direction
    public function viewByDirection($from, $to) {
        $direction = $from . $to;
        return $this->directionalCount[$direction];
    }

    public function getData() {

    }
}
?>