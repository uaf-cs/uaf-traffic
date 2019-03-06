//
//  SessionManager.swift
//  uaftraffic
//
//  Created by Brandon Abbott on 3/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//
// Path to save files: ../documents/sessions

import Foundation

class SessionManager{
    //let fileurl = dir.URLByAppendingPathComponent("sessions.txt")
    //String(contentsOfFile: <LocalFileDirPath>)
    
//    let fileManager = FileManager.default
//    do {
//    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
//    let fileURL = documentDirectory.appendingPathComponent(name)
//    let image = #imageLiteral(resourceName: "Notifications")
//    if let imageData = UIImageJPEGRepresentation(image, 0.5) {
//    try imageData.write(to: fileURL)
//    return true
//    }
//    } catch {
//    print(error)
//    }
//    return false
    
    
    
    func getSessions() -> Sessions {
        
    }
    
    func writeSessions() {
        let fileManager = FileManager.default
        do{
            
        }
    }
    
    func deleteSessions(){
        <#function body#>
        
    }
}
