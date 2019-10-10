//
//  UAFTrafficCountViewController.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 2/24/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit
import CoreLocation

extension Notification.Name {
    static let addCrossing = Notification.Name("addCrossing")
}

class TrafficCountViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var compassArrow: UIImageView!
    @IBOutlet weak var compassLetters: UIImageView!
    @IBOutlet weak var northBlocker: UIImageView!
    @IBOutlet weak var eastBlocker: UIImageView!
    @IBOutlet weak var southBlocker: UIImageView!
    @IBOutlet weak var westBlocker: UIImageView!
//    @IBOutlet weak var eastGrey: UIImageView!
//    @IBOutlet weak var westGrey: UIImageView!
//    @IBOutlet weak var southGrey: UIImageView!
//    @IBOutlet weak var northGrey: UIImageView!
    @IBOutlet weak var north1: VehicleView!
    @IBOutlet weak var north2: VehicleView!
    @IBOutlet weak var north3: VehicleView!
    @IBOutlet weak var north4: VehicleView!
    @IBOutlet weak var north5: VehicleView!
    @IBOutlet weak var south1: VehicleView!
    @IBOutlet weak var south2: VehicleView!
    @IBOutlet weak var south3: VehicleView!
    @IBOutlet weak var south4: VehicleView!
    @IBOutlet weak var south5: VehicleView!
    @IBOutlet weak var west1: VehicleView!
    @IBOutlet weak var west2: VehicleView!
    @IBOutlet weak var west3: VehicleView!
    @IBOutlet weak var west4: VehicleView!
    @IBOutlet weak var west5: VehicleView!
    @IBOutlet weak var east1: VehicleView!
    @IBOutlet weak var east2: VehicleView!
    @IBOutlet weak var east3: VehicleView!
    @IBOutlet weak var east4: VehicleView!
    @IBOutlet weak var east5: VehicleView!

    let locationManager = CLLocationManager()
    let sessionManager = SessionManager()
    var isResumedSession = true

    private var session_: Session? // Session may not be initialized until after a segue
    func setSession(session: Session?) {
        if let s = session {
            session_ = s
        } else {
            assert(session == nil, "session_ must be initialized before segue!")
        }
    }

    func northCheck() {
        if let session = session_ {
            northBlocker.isHidden = session.hasNorthLink
//            northGrey.isHidden = session.hasNorthLink
            if session.hasNorthLink {
                north5.vehicleType = session.vehicle1Type
                north5.image = UIImage(named: session.vehicle1Type + ".pdf")
                north4.vehicleType = session.vehicle2Type
                north4.image = UIImage(named: session.vehicle2Type + ".pdf")
                north3.vehicleType = session.vehicle3Type
                north3.image = UIImage(named: session.vehicle3Type + ".pdf")
                north2.vehicleType = session.vehicle4Type
                north2.image = UIImage(named: session.vehicle4Type + ".pdf")
                north1.vehicleType = session.vehicle5Type
                north1.image = UIImage(named: session.vehicle5Type + ".pdf")
            }
            else {
                north1.isActive = false
                north2.isActive = false
                north3.isActive = false
                north4.isActive = false
                north5.isActive = false
            }
        } else {
            print("DEBUGGING: session_ is nil!")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            print("DEBUGGER: segue id is " + id)
        } else {
            print("DEBUGGER: segue id is nil!")
        }

        if let session = session_ {
            let vc = segue.destination as! SessionInfoViewController
            vc.setSession(session: session)
            NotificationCenter.default.removeObserver(self)
        }
    }

    func eastCheck() {
        if let session = session_ {
            eastBlocker.isHidden = session.hasEastLink
//        eastGrey.isHidden = session.hasEastLink
            if session.hasEastLink {
                east5.vehicleType = session.vehicle1Type
                east5.image = UIImage(named: session.vehicle1Type + ".pdf")
                east4.vehicleType = session.vehicle2Type
                east4.image = UIImage(named: session.vehicle2Type + ".pdf")
                east3.vehicleType = session.vehicle3Type
                east3.image = UIImage(named: session.vehicle3Type + ".pdf")
                east2.vehicleType = session.vehicle4Type
                east2.image = UIImage(named: session.vehicle4Type + ".pdf")
                east1.vehicleType = session.vehicle5Type
                east1.image = UIImage(named: session.vehicle5Type + ".pdf")

            }
            else {
                east1.isActive = false
                east2.isActive = false
                east3.isActive = false
                east4.isActive = false
                east5.isActive = false
            }
        }
    }

    func southCheck() {
        if let session = session_ {
            southBlocker.isHidden = session.hasSouthLink
//        southGrey.isHidden = session.hasSouthLink
            if session.hasSouthLink {
                south1.vehicleType = session.vehicle1Type
                south1.image = UIImage(named: session.vehicle1Type + ".pdf")
                south2.vehicleType = session.vehicle2Type
                south2.image = UIImage(named: session.vehicle2Type + ".pdf")
                south3.vehicleType = session.vehicle3Type
                south3.image = UIImage(named: session.vehicle3Type + ".pdf")
                south4.vehicleType = session.vehicle4Type
                south4.image = UIImage(named: session.vehicle4Type + ".pdf")
                south5.vehicleType = session.vehicle5Type
                south5.image = UIImage(named: session.vehicle5Type + ".pdf")
            }
            else {
                south1.isActive = false
                south2.isActive = false
                south3.isActive = false
                south4.isActive = false
                south5.isActive = false
            }
        }
    }

    func westCheck() {
        if let session = session_ {
            westBlocker.isHidden = session.hasWestLink
//        westGrey.isHidden = session.hasWestLink
            if session.hasWestLink {
                west1.vehicleType = session.vehicle1Type
                west1.image = UIImage(named: session.vehicle1Type + ".pdf")
                west2.vehicleType = session.vehicle2Type
                west2.image = UIImage(named: session.vehicle2Type + ".pdf")
                west3.vehicleType = session.vehicle3Type
                west3.image = UIImage(named: session.vehicle3Type + ".pdf")
                west4.vehicleType = session.vehicle4Type
                west4.image = UIImage(named: session.vehicle4Type + ".pdf")
                west5.vehicleType = session.vehicle5Type
                west5.image = UIImage(named: session.vehicle5Type + ".pdf")
            }
            else {
                west1.isActive = false
                west2.isActive = false
                west3.isActive = false
                west4.isActive = false
                west5.isActive = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addCrossing(notification:)),
                                               name: .addCrossing,
                                               object: nil)
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        crossingCountChanged()
        northCheck()
        eastCheck()
        southCheck()
        westCheck()
        countLabel.layer.zPosition = 21
    }

    @IBAction func endSessionButtonTapped(_ sender: Any) {
        if let session = session_ {
            //if isResumedSession {
            sessionManager.writeSession(session: session)
            dismiss(animated: true, completion: nil)
            /* } else if session.crossings.count == 0 {
            dismiss(animated: true, completion: nil)
        } else {
            let confirmation = UIAlertController(title: "End Session", message: "Are you sure you want to end this session?", preferredStyle: .alert)
            confirmation.addAction(UIAlertAction(title: "Yes, end session", style: .destructive, handler: getSessionName))
            confirmation.addAction(UIAlertAction(title: "No, continue", style: .cancel, handler: nil))
            present(confirmation, animated: true, completion: nil)
        }*/
        }
    }

    @IBAction func undoButtonTapped(_ sender: Any) {
        if let session = session_ {
            session.undo()
            crossingCountChanged()
        }
    }

    /*func getSessionName(sender: UIAlertAction) {
        let namePrompt = UIAlertController(title: "Session Name", message: "What should this session be called?", preferredStyle: .alert)
        namePrompt.addTextField { textField in
            textField.placeholder = "Intersection of main and 3rd"
        }
        namePrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak namePrompt] _ in
            guard let name = namePrompt!.textFields!.first!.text else { return }
            self.endSession(name: name)
        }))
        namePrompt.addAction(UIAlertAction(title: "Quit without saving", style: .destructive, handler: { _ in
            let confirmation = UIAlertController(title: "Quit without saving", message: "Are you sure you want to quit without saving?", preferredStyle: .alert)
            confirmation.addAction(UIAlertAction(title: "Yes, discard data", style: .destructive, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            confirmation.addAction(UIAlertAction(title: "No, continue", style: .cancel, handler: nil))
            self.present(confirmation, animated: true, completion: nil)
        }))
        namePrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(namePrompt, animated: true, completion: nil)
    }
    
    func endSession(name: String) {
        print("Ending session")
        session.name = name
        sessionManager.writeSession(session: session)
        self.dismiss(animated: true, completion: nil)
    }*/

    @objc func addCrossing(notification: Notification) {
        if let session = session_ {
            let userInfo = notification.userInfo! as! Dictionary<String, String>
            print("got crossing:", userInfo)
            session.addCrossing(type: userInfo["type"]!, from: userInfo["from"]!, to: userInfo["to"]!)
            crossingCountChanged()
        }
    }

    func crossingCountChanged() {
        if let session = session_ {
            undoButton.isEnabled = session.crossings.count != 0
            countLabel.text = "Total Counted: " + String(session.crossings.count)
        }
    }

    /*func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let angle = abs((newHeading.trueHeading * .pi/180) - (2.0 * .pi))
        compassArrow.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        //variable will be necessary here (or in options menu, if that implementation is preferred) to ensure that directions remain accurate
        //It may also need reimplementation to adjust for the engagement/disengagement of roads.
	}*/
}
