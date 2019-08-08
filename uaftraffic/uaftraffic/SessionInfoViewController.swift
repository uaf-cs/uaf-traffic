//
//  SessionInfoViewController.swift
//  uaftraffic
//
//  Created by Joseph Wolf on 8/7/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class SessionInfoViewController: UIViewController{
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var lonField: UITextField!
    @IBOutlet weak var ewField: UITextField!
    @IBOutlet weak var nsField: UITextField!
    @IBOutlet weak var technicianField: UITextField!
    var session = Session()
    var toSession = true

    override func viewDidLoad() {
        if session.name.trimmingCharacters(in: .whitespaces) != ""{
            nameField.placeholder = session.name
        }
        if session.lat.trimmingCharacters(in: .whitespaces) != ""{
            latField.placeholder = session.lat
        }
        if session.lon.trimmingCharacters(in: .whitespaces) != ""{
            lonField.placeholder = session.lon
        }
        if session.EWRoadName.trimmingCharacters(in: .whitespaces) != ""{
            ewField.placeholder = session.EWRoadName
        }
        if session.NSRoadName.trimmingCharacters(in: .whitespaces) != ""{
            nsField.placeholder = session.NSRoadName
        }
        if session.technician.trimmingCharacters(in: .whitespaces) != ""{
            technicianField.placeholder = session.technician
        }
    }
    
    @IBAction func saveInfo(_ sender: Any){
        let name = nameField.text!
        self.session.name = (name != "") ? name : session.name
        let lat = latField.text!
        self.session.lat = (lat != "") ? lat : session.lat
//        self.session.lat = (testFormatter.number(from: lat)?.stringValue ?? "00.00") + " N"
        let lon = lonField.text!
        self.session.lon = (lon != "") ? lon : session.lon
//        self.session.lon = (testFormatter.number(from: lon)?.stringValue ?? "00.00") + " W"
        let ewRoad = ewField.text!
        self.session.EWRoadName = (ewRoad != "") ? ewRoad : session.EWRoadName
        let nsRoad = nsField.text!
        self.session.NSRoadName = (nsRoad != "") ? nsRoad : session.NSRoadName
        let userName = technicianField.text!
        self.session.technician = (userName != "") ? userName : session.technician
        
        let sessionManager = SessionManager()
        sessionManager.writeSession(session: session)
        if toSession{
            performSegue(withIdentifier: "StartSession", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TrafficCountViewController
        vc.session = session
        vc.isResumedSession = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        toSession = false
        saveInfo(self)
    }
    
}

extension SessionInfoViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            latField.becomeFirstResponder()
        case latField:
            lonField.becomeFirstResponder()
        case lonField:
            ewField.becomeFirstResponder()
        case ewField:
            nsField.becomeFirstResponder()
        case nsField:
            technicianField.becomeFirstResponder()
        default:
            technicianField.resignFirstResponder()
        }
        
        return true
    }
    
}
