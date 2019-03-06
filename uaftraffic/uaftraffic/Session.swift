//
//  Sessions.swift
//  uaftraffic
//
//  Created by Brandon Abbott on 3/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import Foundation

class Crossing{
    var type: String
    var from: String
    var to: String
    var time: Date
    
    init(type: String, from: String, to: String, time: Date) {
        self.type = type
        self.from = from
        self.to = to
        self.time = time
    }
    init() {
        self.type = "Test Car"
        self.from = "That direction"
        self.to = "This direction"
        self.time = Date()
    }
}

class Session{
    var lat : Float
    var long : Float
    var id : Int
    var name : String
    var crossing : [Crossing]
    
    func addCrossing( type: String, from: String, to: String ){
        crossing.append(contentsOf: crossing)
    }
    
    func undo() {
        crossing.removeLast()
    }
    init(lat: Float, long: Float, id: Int, name: String, crossing: [Crossing]) {
        self.lat = lat
        self.long = long
        self.id = id
        self.name = name
        self.crossing = crossing
    }
    init(){
        self.lat = 4.04
        self.long = 4.04
        self.id = 444
        self.name = "TEST"
        self.crossing = []
    }
}

