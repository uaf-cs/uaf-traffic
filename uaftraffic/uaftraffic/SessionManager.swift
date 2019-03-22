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
    
    func writeSessions (session: Session) {
        let documentsdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveurl = documentsdirectory.appendingPathComponent("sessions").appendingPathExtension("plist")
        
        let plistencod = PropertyListEncoder()
        plistencod.outputFormat = .xml
        
        let encodeSession = try? plistencod.encode(session)
        try? encodeSession?.write(to : archiveurl , options : .noFileProtection)
    }
    
    func getSessions() -> [Session] {
        let documentsdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveurl = documentsdirectory.appendingPathComponent("sessions").appendingPathExtension("plist")
        
        let plistdecode = PropertyListDecoder()
        if let retriveData = try? Data(contentsOf: archiveurl),
            let decodeSession = try? plistdecode.decode(Array<Session>.self, from: retriveData) {
            return decodeSession
        }
        return [Session]()
    }
    
    init() {
        let fileMan = FileManager.default
        let documentsdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveurl = documentsdirectory.appendingPathComponent("sessions").appendingPathExtension("plist")
        if !(fileMan.fileExists(atPath: archiveurl.absoluteString)) {
            do {
                try fileMan.createDirectory(at: archiveurl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Can't create directory for some reason")
            }
        }
    }
//    func getSessionFiles() -> [URL] {
//        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let sessionsPath = documentsPath.appendingPathComponent("sessions")
//        let sessionFiles: [URL]
//        do {
//            try sessionFiles = fileManager.contentsOfDirectory(at: sessionsPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//        } catch {
//            print("Can't list directory for some reason")
//            sessionFiles = []
//        }
//        return sessionFiles
//    }
//
//    func getSessions() -> [Session] {
//        let sessionFiles = getSessionFiles()
//        var sessions = [Session]()
//        for sessionPath in sessionFiles {
//            let unarchivedSession = NSKeyedUnarchiver.unarchiveObject(withFile: sessionPath.path)
//            guard unarchivedSession != nil else {return []}
//            sessions.append(unarchivedSession as! Session)
//        }
//
//        return sessions
//    }
//
//    func writeSession(session: Session) {
//        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let sessionPath = documentsPath.appendingPathComponent("sessions").appendingPathComponent(session.id).appendingPathExtension("plist")
//        let success = NSKeyedArchiver.archiveRootObject(session, toFile: sessionPath.absoluteString)
//        print(success ? "Successful save" : "Save Failed")
//    }
//
//    func deleteSession(session: Session){
//
}


