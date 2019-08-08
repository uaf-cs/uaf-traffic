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

    @IBAction func saveInfo(_ sender: Any){
        let name = nameField.text!
        self.session.name = name
        let lat = latField.text!
        self.session.lat = lat
        //        self.session.lat = (testFormatter.number(from: lat)?.stringValue ?? "00.00") + " N"
        let lon = lonField.text!
        self.session.lon = lon
        //        self.session.lon = (testFormatter.number(from: lon)?.stringValue ?? "00.00") + " W"
        let ewRoad = ewField.text!
        self.session.EWRoadName = ewRoad
        let nsRoad = nsField.text!
        self.session.NSRoadName = nsRoad
        let userName = technicianField.text!
        self.session.technician = userName
        
        let sessionManager = SessionManager()
        sessionManager.writeSession(session: session)
        performSegue(withIdentifier: "StartSession", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TrafficCountViewController
        vc.session = session
        vc.isResumedSession = true
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
