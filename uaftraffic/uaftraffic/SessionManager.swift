//
//  SessionManager.swift
//  uaftraffic
//
//  Created by Brandon Abbott on 3/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//
// Path to save files: ../documents/sessions

import Foundation

class SessionManager {
    init() {
        let fileMan = FileManager.default
        let documentsdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveurl = documentsdirectory.appendingPathComponent("sessions")
        if !(fileMan.fileExists(atPath: archiveurl.absoluteString)) {
            do {
                try fileMan.createDirectory(at: archiveurl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Can't create directory for some reason")
            }
        }
    }
    
    func writeSession(session: Session) {
        let documentsdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveurl = documentsdirectory.appendingPathComponent("sessions").appendingPathComponent(session.getFilename())
//        let plistencod = PropertyListEncoder()
//        
//        let encodeSession = try? plistencod.encode(session)
//        try? encodeSession?.write(to : archiveurl , options : .noFileProtection)
        
        let encodeSession = try? PropertyListEncoder().encode(session)
        if let encodeSession = encodeSession {
            try? encodeSession.write(to : archiveurl, options : .noFileProtection)
        } else {
            print("unable to encode or write session")
        }
    }
    
    func getSessions() -> [Session] {
        let fileMan = FileManager.default
        let documentsdirectory = fileMan.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveurl = documentsdirectory.appendingPathComponent("sessions")
        var fileURLs = [URL]()
        do {
            fileURLs = try FileManager.default.contentsOfDirectory(at: archiveurl, includingPropertiesForKeys: nil)
        } catch {
            print("error getting sessions")
        }
        var sessionData = [Session]()
        
        for file in fileURLs {
            let plistdecode = PropertyListDecoder()
            if let retrieveData = try? Data(contentsOf: file),
                let decodeSession = try? plistdecode.decode(Session.self, from: retrieveData) {
                decodeSession.setFilename(name: file.lastPathComponent)
                print(file.lastPathComponent)
                sessionData.append(decodeSession)
            }
        }
        sessionData.sort {(session1,session2) -> Bool in
            if session1.crossings.count == 0{
                return false;
            }
            else if session2.crossings.count == 0{
                return true;
            }
            else{
            return session1.crossings.first!.time.compare(session2.crossings.first!.time) == ComparisonResult.orderedDescending
            }
        }
        return sessionData
    }
    
//    for dat in testArray {
//    let date = dateFormatter.date(from: dat)
//    if let date = date {
//    convertedArray.append(date)
//    }
//    }
//
//    var ready = convertedArray.sorted(by: { $0.compare($1) == .orderedDescending })

    
    
    func deleteSession(session: Session){
        let documentsdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sessionURL = documentsdirectory.appendingPathComponent("sessions").appendingPathComponent(session.getFilename())
        print("trying to delete " + sessionURL.lastPathComponent)
        do {
            try FileManager.default.removeItem(at: sessionURL)
        } catch {
            print("Failed to delete file " + sessionURL.lastPathComponent)
        }
    }
}
