//
//  VehicleSelectViewController.swift
//  uaftraffic
//
//  Created by Joseph Wolf on 6/26/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class VehicleSelectViewController: UITableViewController {
    
    var session = Session()
    var vehicleArray: [String] = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
     @IBAction func getSessionName(sender: Any) {
     let namePrompt = UIAlertController(title: "Session Name", message: "What should this session be called?", preferredStyle: .alert)
     namePrompt.addTextField { textField in
     textField.placeholder = "Intersection of main and 3rd"
     }
     namePrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak namePrompt] _ in
     guard let name = namePrompt!.textFields!.first!.text else { return }
     self.session.name = name
        self.getSessionLat()
       // self.saveSession(name: name)
     }))
     namePrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
     present(namePrompt, animated: true, completion: nil)
     }
    
    func getSessionLat(){
        let latPrompt = UIAlertController(title: "Session Latitude", message: "What is the latitude of the session?", preferredStyle: .alert)
        latPrompt.addTextField { textField in
            textField.placeholder = "00.00 N"
        }
        latPrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak latPrompt] _ in
            guard let latitude = latPrompt!.textFields!.first!.text else { return }
            self.session.lat = latitude
            self.getSessionLon()
        }))
        latPrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(latPrompt, animated: true, completion: nil)
    }
    
    func getSessionLon(){
        let lonPrompt = UIAlertController(title: "Session Longitude", message: "What is the longitude of the session?", preferredStyle: .alert)
        lonPrompt.addTextField { textField in
            textField.placeholder = "00.00 W"
        }
        lonPrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak lonPrompt] _ in
            guard let longitutde = lonPrompt!.textFields!.first!.text else { return }
            self.session.lon = longitutde
            self.getEWRoad()
        }))
        lonPrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(lonPrompt, animated: true, completion: nil)
    }
    
    func getEWRoad(){
        let roadPrompt = UIAlertController(title: "East-West Road Name", message: "What is the name of the road running east-west?", preferredStyle: .alert)
        roadPrompt.addTextField{ textField in
            textField.placeholder = "Third Avenue"
        }
        roadPrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak roadPrompt] _ in
            guard let roadName = roadPrompt!.textFields!.first!.text else { return }
            self.session.EWRoadName = roadName
            self.getNSRoad()
        }))
        roadPrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(roadPrompt, animated: true, completion: nil)
    }
    
    func getNSRoad(){
        let roadPrompt = UIAlertController(title: "North-South Road Name", message: "What is the name of the road running North-South?", preferredStyle: .alert)
        roadPrompt.addTextField{ textField in
            textField.placeholder = "Main Street"
        }
        roadPrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak roadPrompt] _ in
            guard let roadName = roadPrompt!.textFields!.first!.text else { return }
            self.session.NSRoadName = roadName
            self.getUserName()
        }))
        roadPrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(roadPrompt, animated: true, completion: nil)
    }
    
    func getUserName(){
        let namePrompt = UIAlertController(title: "User Name", message: "What is your name?", preferredStyle: .alert)
        namePrompt.addTextField { textField in
            textField.placeholder = "Joe Smith"
        }
        namePrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak namePrompt] _ in
            guard let name = namePrompt!.textFields!.first!.text else { return }
            self.session.technician = name
            self.saveSession()
        }))
        namePrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(namePrompt, animated: true, completion: nil)
    }
     
     func cancel(sender: UIAlertAction){
        self.dismiss(animated: true, completion: nil)
     }
     
     func saveSession() {
//     session.name = name
        if vehicleArray.count < 5{
            let blankArray = Array(repeating: "", count: 5 - vehicleArray.count)
            vehicleArray.append(contentsOf: blankArray)
        }
        session.vehicle1Type = vehicleArray[0]
        session.vehicle2Type = vehicleArray[1]
        session.vehicle3Type = vehicleArray[2]
        session.vehicle4Type = vehicleArray[3]
        session.vehicle5Type = vehicleArray[4]
     let sessionManager = SessionManager()
     sessionManager.writeSession(session: session)
     performSegue(withIdentifier: "StartSession", sender: self)

     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TrafficCountViewController
        vc.session = session
        vc.isResumedSession = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as! SessionDetailsCrossingCell
        if cell.accessoryType == UITableViewCell.AccessoryType.none{
            if vehicleArray.count != 5 {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                vehicleArray.append((cell.selectLabel))
            }
        }
        else{
            cell.accessoryType = UITableViewCell.AccessoryType.none
            let i = vehicleArray.firstIndex(of: (cell.selectLabel))
            vehicleArray.remove(at: i!)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "crossingCell", for: indexPath) as! SessionDetailsCrossingCell
        let counter = indexPath.row
        switch counter{
        case 0:
            cell.selectLabel = "atv"
        case 1:
            cell.selectLabel = "bike"
        case 2:
            cell.selectLabel = "car"
        case 3:
            cell.selectLabel = "mush"
        case 4:
            cell.selectLabel = "pedestrian"
        case 5:
            cell.selectLabel = "snowmachine"
            // more vehicles can be added, just be sure to address the row count as well
        default:
            assert(false, "too many rows")
        }
        cell.direction.text = ""
        cell.time.text = ""
        cell.selectionStyle = UITableViewCell.SelectionStyle.gray
        cell.vehicle.image = UIImage(named: cell.selectLabel + "-black")
        cell.accessoryType = UITableViewCell.AccessoryType.none
        return cell
    }
}
