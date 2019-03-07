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
    let fileManager: FileManager
    
    init() {
        fileManager = FileManager()
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sessionsPath = documentsPath.appendingPathComponent("sessions")
        if !(fileManager.fileExists(atPath: sessionsPath.absoluteString)) {
            do {
                try fileManager.createDirectory(at: sessionsPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Can't create directory for some reason")
            }
        }
    }
    
    func getSessionFiles() -> [URL] {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sessionsPath = documentsPath.appendingPathComponent("sessions")
        let sessionFiles: [URL]
        do {
            try sessionFiles = fileManager.contentsOfDirectory(at: sessionsPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        } catch {
            print("Can't list directory for some reason")
            sessionFiles = []
        }
        return sessionFiles
    }
    
    func getSessions() -> [Session] {
        let sessionFiles = getSessionFiles()
        var sessions = [Session]()
        for sessionPath in sessionFiles {
            var unarchivedSession = NSKeyedUnarchiver.unarchiveObject(withFile: sessionPath.path)
            guard unarchivedSession != nil else {return []}
            sessions.append(unarchivedSession as! Session)
        }
        
        return sessions
    }
    
    func writeSession(session: Session) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sessionPath = documentsPath.appendingPathComponent("sessions").appendingPathComponent(session.id).appendingPathExtension("plist")
        let success = NSKeyedArchiver.archiveRootObject(session, toFile: sessionPath.absoluteString)
        print(success ? "Successful save" : "Save Failed")
    }
    
    func deleteSession(session: Session){
        
    }
}

//////////////////////////////////////////////////////////////////////////////////
//class SessionManager: NSObject, NSCoding {
//    let randomFilename = "TEST.txt"
//    let somethingToSave = "ttteeeessstttt"
//
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//
//    func getSessions() -> String {
//        do {
//            if let loadedStrings = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(randomFilename) as? [Data] {
//                savedArray = loadedStrings
//            }
//        } catch {
//            print("Couldn't read file.")
//        }
//    }
//
//    func writeSessions() {
//        let fullPath = getDocumentsDirectory().appendingPathComponent(randomFilename)
//
//        do {
//            let data = try NSKeyedArchiver.archivedData(withRootObject: somethingToSave, requiringSecureCoding: false)
//            try data.write(to: fullPath)
//            } catch {
//                print("Couldn't write file")
//            }
//
//        }
//
//   func deleteSessions(){
//
//   }
//}
/////////////////////////////////////////////////////////////////////////////////////
//Write
//let file = "file.txt"
//
//let text = "some text" //just a text
//
//if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//    let fileURL = dir.appendingPathComponent(file)
//
//    //writing
//    do {
//        try text.write(to: fileURL, atomically: false, encoding: .utf8)
//    }
//    catch {/* error handling here */}

//get
//var text2: Session?
//let file = "file.txt"
//
//if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//    let fileURL = dir.appendingPathComponent(file)
//    //reading
//    do {
//        text2 = try String?(contentsOf: fileURL, encoding: .utf8)
//    }
//    catch {return error.localizedDescription}
//}
//return text2!

//
//    override init() {
//        super.init()
//    }

