<?php
include_once "api/api.php";
include_once "TrafficSession.php";

include_once "pChart2.1.4/class/pDraw.class.php";
include_once "pChart2.1.4/class/pImage.class.php";

//Size Parameters
$height = 600;
$width = 600;
$padding = 5;
$laneSize = 12; //higher number == more narrow
$laneWidth = 40;
$wigglemax = 15;
$wigglemin = -15;

//Line Settings
$line_settings = [
    "atv" => array("R"=>150,"G"=>150,"B"=>0),
    "bike" => array("R"=>0,"G"=>200,"B"=>0),
    "car" => array("R"=>200,"G"=>50,"B"=>0),
    "pedestrian" => array("R"=>10,"G"=>50,"B"=>200),
    "snowmachine" => array("R"=>100,"G"=>50,"B"=>100),
];

$fromNorth = array('x' => $width/2 - $width/$laneSize, 'y' => $padding);
$toNorth = array('x' => $width/2 + $width/$laneSize, 'y' => $padding);

$fromEast = array('x' => $width-$padding , 'y' => $height/2 - $height/$laneSize);
$toEast = array('x' => $height - $padding , 'y' => $height/2 + $height/$laneSize);

$fromWest = array('x' => $padding , 'y' => $height/2 + $height/$laneSize);
$toWest = array('x' => $padding , 'y' => $height/2 - $height/$laneSize);

$fromSouth = array('x' => $width/2 + $width/$laneSize , 'y' => $height - $padding);
$toSouth = array('x' => $width/2 - $width/$laneSize , 'y' => $height - $padding);

$curveVector = array($height/2, $width/2, $height/2, $width/2);

$api = new API();
$results = $api->readData();

foreach($results as & $row) {

    $sesh = new TrafficSession($row);

    $graph = new pImage($height, $width);

    //Border
    $graph->drawRectangle(0,0,$width-1,$height-1,array("R"=>0,"G"=>0,"B"=>0));
    $graph->setFontProperties(array("FontName"=>"pChart2.1.4/fonts/Silkscreen.ttf","FontSize"=>6));
    $graph->setShadow(TRUE,array("X"=>2,"Y"=>2,"R"=>0,"G"=>0,"B"=>0,"Alpha"=>20));

    //Draw Background
    $graph->drawFromPNG(0,0, "graphs/road.png");
    
    //FROM NORTH//////////////////
    $ns = $sesh->viewByDirection("n", "n");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromNorth['x'] + $wiggle, $fromNorth['y'], 
                                $toNorth['x'] + $wiggle, $toNorth['y'],
                                $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                                $settings);
        }
    }

    $ns = $sesh->viewByDirection("n", "e");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromNorth['x'] + $wiggle, $fromNorth['y'], 
                                $toEast['x'], $toEast['y'] + $wiggle,
                                $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                                $settings);
        }
    }

    $ns = $sesh->viewByDirection("n", "s");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawLine($fromNorth['x'] + $wiggle, $fromNorth['y'], 
                             $toSouth['x'] + $wiggle, $toSouth['y'],
                             $settings);
        }
    }

    $ns = $sesh->viewByDirection("n", "w");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromNorth['x'] + $wiggle, $fromNorth['y'], 
                                $toWest['x'], $toWest['y'] + $wiggle,
                                $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                                $settings);
        }
    }

    //FROM EAST/////////////////////
    $ns = $sesh->viewByDirection("e", "n");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromEast['x'], $fromEast['y'] + $wiggle, 
                             $toNorth['x'] + $wiggle, $toNorth['y'],
                             $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                             $settings);
        }
    }

    $ns = $sesh->viewByDirection("e", "e");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromEast['x'], $fromEast['y'] + $wiggle, 
                                $toEast['x'], $toEast['y'] + $wiggle,
                                $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                                $settings);
        }
    }

    $ns = $sesh->viewByDirection("e", "s");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromEast['x'], $fromEast['y'] + $wiggle, 
                                $toSouth['x'] + $wiggle, $toSouth['y'],
                                $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                                $settings);
        }
    }

    $ns = $sesh->viewByDirection("e", "w");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawLine($fromEast['x'], $fromEast['y'] + $wiggle, 
                                $toWest['x'], $toWest['y'] + $wiggle,
                                $settings);
        }
    }

    //FROM SOUTH///////////////////////////
    $ns = $sesh->viewByDirection("s", "n");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawLine($fromSouth['x'] + $wiggle, $fromSouth['y'], 
                             $toNorth['x'] + $wiggle, $toNorth['y'],
                             $settings);
        }
    }

    $ns = $sesh->viewByDirection("s", "e");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromSouth['x'] + $wiggle, $fromSouth['y'], 
                                $toEast['x'], $toEast['y'] + $wiggle,
                                $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                                $settings);
        }
    }

    $ns = $sesh->viewByDirection("s", "s");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromSouth['x'] + $wiggle, $fromSouth['y'],
                                $toSouth['x'] + $wiggle, $toSouth['y'],
                                $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                                $settings);
        }
    }

    $ns = $sesh->viewByDirection("s", "w");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromSouth['x'] + $wiggle, $fromSouth['y'],
                                $toWest['x'], $toWest['y'] + $wiggle,
                                $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                                $settings);
        }
    }

    //FROM WEST/////////////
    $ns = $sesh->viewByDirection("w", "n");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromWest['x'], $fromWest['y'] + $wiggle, 
                             $toNorth['x'] + $wiggle, $toNorth['y'],
                             $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                             $settings);
        }
    }

    $ns = $sesh->viewByDirection("w", "e");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawLine($fromWest['x'], $fromWest['y'] + $wiggle, 
                                $toEast['x'], $toEast['y'] + $wiggle,
                                $settings);
        }
    }

    $ns = $sesh->viewByDirection("w", "s");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromWest['x'], $fromWest['y'] + $wiggle, 
                                $toSouth['x'] + $wiggle, $toSouth['y'],
                                $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                                $settings);
        }
    }

    $ns = $sesh->viewByDirection("w", "w");
    foreach($ns as $type => $count) {
        $wiggle = random_int($wigglemin, $wigglemax);
        if($count > 0) {
            $settings = $line_settings[$type];
            $graph->drawBezier($fromWest['x'], $fromWest['y'] + $wiggle, 
                                $toWest['x'], $toWest['y'] + $wiggle,
                                $curveVector[0],$curveVector[1],$curveVector[2],$curveVector[3],
                                $settings);
        }
    }
        //Direction Arrows
    $arrowSettings = array("FillR"=>220,"FillG"=>100,"FillB"=>0,"Size"=>$width/($laneSize*1.75), "Ticks"=>60);
    //N -> S
    $graph->drawArrow($width/2 - $width/$laneSize, $height-$padding-2, 
    $width/2 - $width/$laneSize, $height-$padding, 
    $arrowSettings);
    //S -> N
    $graph->drawArrow($width/2 + $width/$laneSize, $padding,
    $width/2 + $width/$laneSize, $padding-2,
    $arrowSettings);  
    //E -> W
    $graph->drawArrow($width-$padding-2, $height/2 + $height/$laneSize,
    $width-$padding, $height/2 + $height/$laneSize,
    $arrowSettings);
    //W -> E
    $graph->drawArrow($padding+2, $height/2 - $height/$laneSize,
    $padding, $height/2 - $height/$laneSize,
    $arrowSettings);


    $graph->Render("graphs/".$sesh->date."map.png");
}
?>