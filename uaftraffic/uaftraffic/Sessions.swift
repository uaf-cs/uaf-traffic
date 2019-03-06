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

class Sessions: Crosssing{
    var date = Date()
    var lat = Float()
    var long = Float()
    var crossing = [[String()]]
    var id = Int()
    var name = String()
    
    func addCrossing( _type: String, _to: String, _from: String){
        
    }
    func undo() {
        
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
