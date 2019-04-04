<?php
include_once "pChart2.1.4/class/pDraw.class.php";
include_once "pChart2.1.4/class/pImage.class.php";

//Size Parameters
$height = 600;
$width = 600;
$padding = 5;
$laneSize = 12; //higher number == more narrow
$laneWidth = 40;

$graph = new pImage($height, $width);

//Border
$graph->drawRectangle(0,0,$width-1,$height-1,array("R"=>0,"G"=>0,"B"=>0));
$graph->setFontProperties(array("FontName"=>"pChart2.1.4/fonts/Silkscreen.ttf","FontSize"=>6));
$graph->setShadow(TRUE,array("X"=>2,"Y"=>2,"R"=>0,"G"=>0,"B"=>0,"Alpha"=>20));

//Line Settings
$lineSettings = array("R"=>50,"G"=>50,"B"=>50, "Weight" => 0.2);
$middleLine = array("R"=>220,"G"=>220,"B"=>0, "Weight" => 2, "Ticks"=>45);


    //Draw Road- Vertical
//Left
$graph->drawLine($width/2 - $width/$laneSize - $laneWidth, $padding, 
                  $width/2 - $width/$laneSize -$laneWidth, $height-$padding, 
                  $lineSettings);
//Middle
$graph->drawLine($width/2, $padding, 
                  $width/2, $height-$padding, 
                  $middleLine);  
//Right
$graph->drawLine($width/2 + $width/$laneSize + $laneWidth, $padding, 
                  $width/2 + $width/$laneSize + $laneWidth, $height-$padding, 
                  $lineSettings);

    //Draw Road- Horizontal
//Bottom
$graph->drawLine($padding,            $height/2 - $height/$laneSize - $laneWidth, 
                  $width -$padding,   $height/2 - $height/$laneSize - $laneWidth, 
                  $lineSettings);
//Middle
$graph->drawLine($padding,            $height/2, 
                  $width -$padding,   $height/2, 
                  $middleLine);
//Top
$graph->drawLine($padding,            $height/2 + $height/$laneSize + $laneWidth, 
                  $width -$padding,   $height/2 + $height/$laneSize + $laneWidth, 
                  $lineSettings);


//Intersection overlay
$GradientSettings = array("StartR"=>255,"StartG"=>255,"StartB"=>255,"Alpha"=>85,"Levels"=>50);
$graph->drawGradientArea($width/2 + $width/$laneSize + $laneWidth, $height/2 - $height/$laneSize - $laneWidth,
                          $width/2 - $width/$laneSize - $laneWidth, $height/2 + $height/$laneSize + $laneWidth,
                          DIRECTION_VERTICAL, $GradientSettings);



$graph->Render("graphs/road.png");

?>