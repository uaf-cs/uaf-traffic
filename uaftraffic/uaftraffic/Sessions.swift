//
//  Sessions.swift
//  uaftraffic
//
//  Created by Brandon Abbott on 3/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import Foundation

class Crossing{
    var _type = String()
    var _from = String()
    var _to = String()
    var _time = Date()
    
    init(_type: String, _from: String, _to: String, _time: Date) {
        self._type = _type
        self._from = _from
        self._to = _to
        self._time = _time
    }
}

class Sessions{
    var _lat = Float()
    var _long = Float()
    var _id = Int()
    var _name = String()
    var _crossing : [Crossing]
    
    func addCrossing( _type: String, _from: String, _to: String ){
        _crossing.append(contentsOf: _crossing)
    }
    
    func undo() {
        _crossing.removeLast()
    }
    init(_lat: Float, _long: Float, _id: Int, _name: String,_crossing: [Crossing]) {
        self._lat = _lat
        self._long = _long
        self._id = _id
        self._name = _name
        self._crossing = _crossing
        
    }
}

//let colors = ["periwinkle", "rose", "moss"]
//let moreColors: [String?] = ["ochre", "pine"]
//
//let url = NSURL(fileURLWithPath: "names.plist")
//(colors as NSArray).write(to: url, atomically: true)
//// true
//
//(moreColors as NSArray).write(to: url, atomically: true)
//// error: cannot convert value of type '[String?]' to type 'NSArray'
