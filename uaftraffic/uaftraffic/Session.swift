//
//  Sessions.swift
//  uaftraffic
//
//  Created by Brandon Abbott on 3/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import Foundation

class Crossing: Codable, Equatable {
    var type: String
    var from: String
    var to: String
    var time: Date
    
    static func == (lhs: Crossing, rhs: Crossing) -> Bool {
        return
            lhs.type == rhs.type &&
            lhs.from == rhs.from &&
            lhs.to == rhs.to &&
            lhs.time == rhs.time
    }
    
    init(type: String, from: String, to: String, time: Date) {
        self.type = type
        self.from = from
        self.to = to
        self.time = time
    }
}

class Session: Codable, Equatable {
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
    
    init() {
        self.lat = 0
        self.long = 0
        self.id = ""
        self.name = ""
        self.crossings = []
        
        self.id = randomString()
    }
    
    init(lat: Float, long: Float, id: String, name: String, crossings: [Crossing]) {
        self.lat = lat
        self.long = long
        self.id = id
        self.name = name
        self.crossings = crossings
    }
    
    static func ==(lhs: Session, rhs: Session) -> Bool{
        return
            lhs.lat == rhs.lat &&
            lhs.long == rhs.long &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.crossings == rhs.crossings
    }
    
    func randomString() -> String {
        let length = 10
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }

    func addCrossing( type: String, from: String, to: String ) {
        let newCrossing = Crossing(type: type, from: from, to: to, time: Date())
        crossings.append(newCrossing)
    }

    func undo() {
        crossings.removeLast()
    }
    
    func dateString() -> String {
        if crossings.count == 0 {
            return "Never"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy, h:mm a"
        return formatter.string(from: crossings.first!.time)
    }
}
