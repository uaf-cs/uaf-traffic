//
//  SessionInfoViewController.swift
//  uaftraffic
//
//  Created by Joseph Wolf on 8/7/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class SessionInfoViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var lonField: UITextField!
    @IBOutlet weak var ewField: UITextField!
    @IBOutlet weak var nsField: UITextField!
    @IBOutlet weak var technicianField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var northToggle: UIButton!
    @IBOutlet weak var southToggle: UIButton!
    @IBOutlet weak var eastToggle: UIButton!
    @IBOutlet weak var westToggle: UIButton!

    var trackDirs = 4
    var toSession = true

    private var session_: Session? // Session may not be initialized until after a segue
    func setSession(session: Session?) {
        if let s = session {
            session_ = s
        } else {
            assert(session == nil, "session_ must be initialized before segue!")
        }
    }

    override func viewDidLoad() {
        if let session = session_ {
            if session.name.trimmingCharacters(in: .whitespaces) != "" {
                nameField.placeholder = session.name
            }
            if session.lat.trimmingCharacters(in: .whitespaces) != "" {
                latField.placeholder = session.lat
            }
            if session.lon.trimmingCharacters(in: .whitespaces) != "" {
                lonField.placeholder = session.lon
            }
            if session.EWRoadName.trimmingCharacters(in: .whitespaces) != "" {
                ewField.placeholder = session.EWRoadName
            }
            if session.NSRoadName.trimmingCharacters(in: .whitespaces) != "" {
                nsField.placeholder = session.NSRoadName
            }
            if session.technician.trimmingCharacters(in: .whitespaces) != "" {
                technicianField.placeholder = session.technician
            }
            if session.city.trimmingCharacters(in: .whitespaces) != "" {
                cityField.placeholder = session.city
            }
            if session.state.trimmingCharacters(in: .whitespaces) != "" {
                stateField.placeholder = session.state
            }
            if session.zipCode.trimmingCharacters(in: .whitespaces) != "" {
                zipField.placeholder = session.zipCode
            }

            if !session.hasNorthLink { trackDirs -= 1 }
            if !session.hasSouthLink { trackDirs -= 1 }
            if !session.hasWestLink { trackDirs -= 1 }
            if !session.hasEastLink { trackDirs -= 1 }

            northToggle.isSelected = session.hasNorthLink
            southToggle.isSelected = session.hasSouthLink
            eastToggle.isSelected = session.hasEastLink
            westToggle.isSelected = session.hasWestLink

            northToggle.addTarget(self, action: #selector(self.toggleNorth), for: .touchUpInside)
            southToggle.addTarget(self, action: #selector(self.toggleSouth), for: .touchUpInside)
            eastToggle.addTarget(self, action: #selector(self.toggleEast), for: .touchUpInside)
            westToggle.addTarget(self, action: #selector(self.toggleWest), for: .touchUpInside)
        } else {
            print("DEBUGGING: session_ not initialized before ViewController loaded!")
        }
    }

    @objc func toggleNorth(sender: Any) {
        if !northToggle.isSelected { trackDirs += 1 }
        if northToggle.isSelected && trackDirs > 2 {
            northToggle.isSelected = false
            trackDirs -= 1
        }
        else {
            northToggle.isSelected = true
        }
    }

    @objc func toggleSouth(sender: Any) {
        if !southToggle.isSelected { trackDirs += 1 }
        if southToggle.isSelected && trackDirs > 2 {
            southToggle.isSelected = false
            trackDirs -= 1
        }
        else {
            southToggle.isSelected = true
        }
    }

    @objc func toggleEast(sender: Any) {
        if !eastToggle.isSelected { trackDirs += 1 }
        if eastToggle.isSelected && trackDirs > 2 {
            eastToggle.isSelected = false
            trackDirs -= 1
        }
        else {
            eastToggle.isSelected = true
        }
    }

    @objc func toggleWest(sender: Any) {
        if !westToggle.isSelected { trackDirs += 1 }
        if westToggle.isSelected && trackDirs > 2 {
            westToggle.isSelected = false
            trackDirs -= 1
        }
        else {
            westToggle.isSelected = true
        }
    }

    @IBAction func saveInfo(_ sender: Any) {
        if let session = self.session_ {
            let name = nameField.text!
            session.name = (name != "") ? name : session.name
            let lat = latField.text!
            session.lat = (lat != "") ? lat : session.lat
            //        self.session.lat = (testFormatter.number(from: lat)?.stringValue ?? "00.00") + " N"
            let lon = lonField.text!
            session.lon = (lon != "") ? lon : session.lon
            //        self.session.lon = (testFormatter.number(from: lon)?.stringValue ?? "00.00") + " W"
            let ewRoad = ewField.text!
            session.EWRoadName = (ewRoad != "") ? ewRoad : session.EWRoadName
            let nsRoad = nsField.text!
            session.NSRoadName = (nsRoad != "") ? nsRoad : session.NSRoadName
            let userName = technicianField.text!
            session.technician = (userName != "") ? userName : session.technician
            let city = cityField.text!
            session.city = (city != "") ? city : session.city
            let state = stateField.text!
            session.state = (state != "") ? state : session.state
            let zip = zipField.text!
            session.zipCode = (zip != "") ? zip : session.zipCode

            session.hasNorthLink = self.northToggle.isSelected
            session.hasSouthLink = self.southToggle.isSelected
            session.hasEastLink = self.eastToggle.isSelected
            session.hasWestLink = self.westToggle.isSelected

            let sessionManager = SessionManager()
            sessionManager.writeSession(session: session)
            if toSession {
                performSegue(withIdentifier: "StartSession", sender: self)
            }
        } else {
            assert(session_ == nil, "session_ must be initialized before segue!")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TrafficCountViewController {
            if let session = session_ {
                vc.session = session
                vc.isResumedSession = true
            } else {
                assert(session_ == nil, "session_ must be initialized before segue!")
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        toSession = false
        saveInfo(self)
    }

}

extension SessionInfoViewController: UITextFieldDelegate {

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
        case technicianField:
            cityField.becomeFirstResponder()
        case cityField:
            stateField.becomeFirstResponder()
        case stateField:
            zipField.becomeFirstResponder()
        default:
            zipField.resignFirstResponder()
        }

        return true
    }

}
