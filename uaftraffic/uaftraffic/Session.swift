//
//  Sessions.swift
//  uaftraffic
//
//  Created by Brandon Abbott on 3/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import Foundation

class Crossing: Codable{
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
        type = "Test Car"
        from = "That direction"
        to = "This direction"
        time = Date()
    }
}

class Session: Codable{
    var lat : Float
    var long : Float
    var id : String
    var name : String
    var crossings : [Crossing]
    
    enum CodingKeys:String,CodingKey {
        case lat
        case long
        case id
        case name
        case crossings
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lat, forKey: .lat)
        try container.encode(long, forKey: .long)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(crossings, forKey: .crossings)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decode(Float.self, forKey: .lat)
        long = try values.decode(Float.self, forKey: .long)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        crossings = [try values.decode(Crossing.self, forKey: .crossings)]
    }
    
    init(lat: Float, long: Float, id: String, name: String, crossings: [Crossing]) {
        self.lat = lat
        self.long = long
        self.id = id
        self.name = name
        self.crossings = crossings
    }
    
        func randomString() -> String {
            let length = 10
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0...length-1).map{ _ in letters.randomElement()! })
        }
    
        func setLat(lat:Float){
            self.lat = lat
        }
        func getLat()->Float{
            return self.lat
        }
    
        func setLong(long:Float){
            self.long = long
        }
        func getLong()->Float{
            return self.long
        }
    
        func setId(id:String){
            self.id = id
        }
        func getId()->String{
            return self.id
        }
    
        func setName(name:String){
            self.name = name
        }
        func getName()->String{
            return self.name
        }
    
    
        func addCrossing( type: String, from: String, to: String ){
            let newCrossing = Crossing(type: type, from: from, to: to, time: Date())
            crossings.append(newCrossing)
        }
    
        func getCrossings()-> [Crossing]{
            return self.crossings
        }
    
        func undo() {
            crossings.removeLast()
        }
    
}



//    func encode(with aCoder: NSCoder){
//        aCoder.encode(lat, forKey: Key.lat.rawValue)
//        aCoder.encode(long, forKey: Key.long.rawValue)
//        aCoder.encode(id, forKey: Key.id.rawValue)
//        aCoder.encode(name, forKey: Key.name.rawValue)
//        aCoder.encode(crossings, forKey: Key.crossings.rawValue)
//    }
//
//    convenience required init?(coder aDecoder: NSCoder) {
//        let lat = aDecoder.decodeFloat(forKey: Key.lat.rawValue)
//        let long = aDecoder.decodeFloat(forKey: Key.long.rawValue)
//        guard let id = aDecoder.decodeObject(forKey: Key.id.rawValue)as? String
//            else {return nil}
//        guard let name = aDecoder.decodeObject(forKey: Key.name.rawValue)as? String
//        else {return nil}
//        guard let crossings = aDecoder.decodeObject(forKey: Key.crossings.rawValue)as?[Crossing]
//        else {return nil}
//
//        self.init(lat: lat, long: long, id: id, name: name, crossings: crossings)
//    }


