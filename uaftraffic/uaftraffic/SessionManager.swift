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
        let archiveurl = documentsdirectory.appendingPathComponent("sessions").appendingPathComponent(session.id).appendingPathExtension("plist")
        
        let plistencod = PropertyListEncoder()
        //plistencod.outputFormat = .xml
        
        let encodeSession = try? plistencod.encode(session)
        try? encodeSession?.write(to : archiveurl , options : .noFileProtection)
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
            if let retriveData = try? Data(contentsOf: file),
                let decodeSession = try? plistdecode.decode(Session.self, from: retriveData) {
                sessionData.append(decodeSession)
            }
        }
        return sessionData
        
    }
    
    func deleteSession(session: Session) {
        let documentsdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sessionURL = documentsdirectory.appendingPathComponent("sessions").appendingPathComponent(session.id).appendingPathExtension("plist")
        do {
            try FileManager.default.removeItem(at: sessionURL)
        } catch {
            print("Failed to delete file %s", sessionURL.relativeString)
        }
    }
}
