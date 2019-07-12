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
        return 7;
    }
    
     @IBAction func getSessionName(sender: Any) {
     let namePrompt = UIAlertController(title: "Session Name", message: "What should this session be called?", preferredStyle: .alert)
     namePrompt.addTextField { textField in
     textField.placeholder = "Intersection of main and 3rd"
     }
     namePrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak namePrompt] _ in
     guard let name = namePrompt!.textFields!.first!.text else { return }
     self.saveSession(name: name)
     }))
     namePrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancel))
     present(namePrompt, animated: true, completion: nil)
     }
     
     func cancel(sender: UIAlertAction){
        self.dismiss(animated: true, completion: nil)
     }
     
     func saveSession(name: String) {
     session.name = name
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
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none{
            if vehicleArray.count != 5 {
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
                vehicleArray.append((cell?.textLabel?.text)!)
            }
        }
        else{
            cell?.accessoryType = UITableViewCell.AccessoryType.none
            let i = vehicleArray.firstIndex(of: (cell?.textLabel?.text)!)
            vehicleArray.remove(at: i!)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let counter = indexPath.row
        switch counter{
        case 0:
            cell.textLabel?.text = "ATV"
        case 1:
            cell.textLabel?.text = "Bicycle"
        case 2:
            cell.textLabel?.text = "Car"
        case 3:
            cell.textLabel?.text = "Mush"
        case 4:
            cell.textLabel?.text = "Pedestrian"
        case 5:
            cell.textLabel?.text = "Plane"
        case 6:
            cell.textLabel?.text = "Snowmachine"
            // more vehicles can be added, just be sure to address the row count as well
        default:
            assert(false, "too many rows")
        }
        cell.accessoryType = UITableViewCell.AccessoryType.none
        return cell
    }
}
