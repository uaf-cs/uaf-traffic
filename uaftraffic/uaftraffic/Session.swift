//
//  Sessions.swift
//  uaftraffic
//
//  Created by Brandon Abbott on 3/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import AVFoundation
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
    
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy, h:mm a"
        return formatter.string(from: time)
    }
}

class Session: Codable, Equatable {
    var lat : String
    var lon : String
    var id : String
    var dateCreated : String = ""
    var name : String
    var hasNorthLink : Bool
    var hasSouthLink : Bool
    var hasWestLink : Bool
    var hasEastLink : Bool
    var vehicle1Type : String
    var vehicle2Type : String
    var vehicle3Type : String
    var vehicle4Type : String
    var vehicle5Type : String
    var NSRoadName : String = ""
    var EWRoadName : String = ""
    var technician : String = ""
    var crossings : [Crossing]
    var audioPlayer = AVAudioPlayer()
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case id
        case name
        case hasNorthLink
        case hasSouthLink
        case hasWestLink
        case hasEastLink
        case vehicle1Type
        case vehicle2Type
        case vehicle3Type
        case vehicle4Type
        case vehicle5Type
        case crossings
    }
    
    init() {
        self.lat = "0.00"
        self.lon = "0.00"
        self.id = ""
        self.name = ""
        self.hasNorthLink = true
        self.hasSouthLink = true
        self.hasWestLink = true
        self.hasEastLink = true
        self.vehicle1Type = "atv"
        self.vehicle2Type = "bike"
        self.vehicle3Type = "plane"
        self.vehicle4Type = "pedestrian"
        self.vehicle5Type = "snowmachine"
        self.crossings = []
        
        self.initID()
    }
    
    init(lat: String, long: String, id: String, name: String, hasNorthLink: Bool, hasSouthLink: Bool, hasWestLink: Bool, hasEastLink: Bool, vehicle1Type: String, vehicle2Type: String, vehicle3Type: String, vehicle4Type: String, vehicle5Type: String, crossings: [Crossing]) {
        self.lat = lat
        self.lon = long
        self.id = id
        self.name = name
        self.hasNorthLink = hasNorthLink
        self.hasSouthLink = hasSouthLink
        self.hasWestLink = hasWestLink
        self.hasEastLink = hasEastLink
        self.vehicle1Type = vehicle1Type
        self.vehicle2Type = vehicle2Type
        self.vehicle3Type = vehicle3Type
        self.vehicle4Type = vehicle4Type
        self.vehicle5Type = vehicle5Type
        self.crossings = crossings
        
        self.initID()
    }
    
    static func ==(lhs: Session, rhs: Session) -> Bool{
        return
            lhs.lat == rhs.lat &&
            lhs.lon == rhs.lon &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.crossings == rhs.crossings &&
            lhs.hasNorthLink == rhs.hasNorthLink &&
            lhs.hasSouthLink == rhs.hasSouthLink &&
            lhs.hasEastLink == rhs.hasEastLink &&
            lhs.hasWestLink == rhs.hasWestLink &&
            lhs.vehicle1Type == rhs.vehicle1Type &&
            lhs.vehicle2Type == rhs.vehicle2Type &&
            lhs.vehicle3Type == rhs.vehicle3Type &&
            lhs.vehicle4Type == rhs.vehicle4Type &&
            lhs.vehicle5Type == rhs.vehicle5Type
    }
    
    func initID() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-d"
        self.dateCreated = formatter.string(from: Date())
        
        self.id = randomString()
    }
    
    func randomString() -> String {
        let length = 10
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }

    func addCrossing( type: String, from: String, to: String ) {
        let newCrossing = Crossing(type: type, from: from, to: to, time: Date())
        crossings.append(newCrossing)
        playDing()
    }

    func undo() {
        if !(crossings.count == 0) {
            crossings.removeLast()
        }
    }
    
    func dateString() -> String {
        if crossings.count == 0 {
            return "Never"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy, h:mm a"
        return formatter.string(from: crossings.first!.time) + " to " + formatter.string(from: crossings.last!.time)
    }
    
    func playDing() {
        let url = Bundle.main.url(forResource: "ding", withExtension: "mp3")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        audioPlayer.play()
    }
    
    func getFilename() -> String {
        
        return self.dateCreated + "-" + self.id;
    }
    
     func fileExport(){
//        let fileName = name + ".csv"
        var csvData = ""// = "vehicle, from, left, right, through\n"
     
     
        csvData += "\nvehicle, from, to, date\n"
     
        for crossing in crossings{
            csvData += "\(crossing.type), \(crossing.from), \(crossing.to), \(crossing.dateString())\n"
        }
        
//        let documentsdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let archiveurl = documentsdirectory.appendingPathComponent("sessions").appendingPathComponent(fileName)
     }
}
