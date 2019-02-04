-- Exported from QuickDBD: https://www.quickdatatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE `Session` (
    `id` int  NOT NULL ,
    `date` datetime  NOT NULL ,
    `manager` varchar(32)  NOT NULL ,
    `organization` varchar(32)  NOT NULL ,
    `lat` float(10,6)  NOT NULL ,
    `long` float(10,6)  NOT NULL ,
    `crossing` JSON[{type,from,to,time}]  NOT NULL ,
    PRIMARY KEY (
        `id`
    )
);

