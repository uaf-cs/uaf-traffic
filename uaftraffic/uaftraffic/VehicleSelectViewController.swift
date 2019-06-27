//
//  VehicleSelectViewController.swift
//  uaftraffic
//
//  Created by Joseph Wolf on 6/26/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class VehicleSelectViewController: UITableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    /*
     func getSessionName(sender: UIAlertAction) {
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
     }
    */
    
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
            cell.textLabel?.text = "Pedestrian"
        case 4:
            cell.textLabel?.text = "Snowmachine"
            // more vehicles can be added, just be sure to address the row count as well
        default:
            assert(false, "too many rows")
        }
        let vehicleSwitch = UISwitch()
        cell.accessoryView = vehicleSwitch
        return cell
    }
}
