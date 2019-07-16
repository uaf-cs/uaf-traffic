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
    var name : String
    var hasNorthLink : Bool = true
    var hasSouthLink : Bool = true
    var hasWestLink : Bool = true
    var hasEastLink : Bool = true
    var vehicle1Type : String = "atv"
    var vehicle2Type : String = "bike"
    var vehicle3Type : String = "car"
    var vehicle4Type : String = "pedestrian"
    var vehicle5Type : String = "snowmachine"
    var NSRoadName : String = ""
    var EWRoadName : String = ""
    var crossings : [Crossing]
    var audioPlayer = AVAudioPlayer()
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case id
        case name
        case crossings
    }
    
    init() {
        self.lat = "0.00"
        self.lon = "0.00"
        self.id = ""
        self.name = ""
        self.crossings = []
        
        self.id = randomString()
    }
    
    init(lat: String, long: String, id: String, name: String, crossings: [Crossing]) {
        self.lat = lat
        self.lon = long
        self.id = id
        self.name = name
        self.crossings = crossings
    }
    
    static func ==(lhs: Session, rhs: Session) -> Bool{
        return
            lhs.lat == rhs.lat &&
            lhs.lon == rhs.lon &&
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
        if (from == "n" || to == "n") && !hasNorthLink {
            playError()
            return
        }
        else if (from == "e" || to == "e") && !hasEastLink {
            playError()
            return
        }
        else if (from == "s" || to == "s") && !hasSouthLink {
            playError()
            return
        }
        else if (from == "w" || to == "w") && !hasWestLink {
            playError()
            return
        }
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
        return formatter.string(from: crossings.first!.time)
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
    
    func playError() {
        let url = Bundle.main.url(forResource: "error", withExtension: "mp3")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        audioPlayer.play()
    }
}
