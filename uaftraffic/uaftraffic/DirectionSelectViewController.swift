//
//  DirectionSelectViewController.swift
//  uaftraffic
//
//  Created by Joseph Wolf on 6/24/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class DirectionSelectViewController: UITableViewController {
    var session = Session()
    var directionCount = 4
    
    @IBAction func cancelButtonTapped(_ sender: Any){
    self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! VehicleSelectViewController
        vc.session = session
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none{
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            switch cell?.textLabel?.text{
            case "North":
                session.hasNorthLink = true
            case "South":
                session.hasSouthLink = true
            case "East":
                session.hasEastLink = true
            case "West":
                session.hasWestLink = true
            default:
                assert(false, "unrecognized direction")
            }
            directionCount += 1
        }
        else{
            if directionCount > 2{
                cell?.accessoryType = UITableViewCell.AccessoryType.none
                switch cell?.textLabel?.text{
                case "North":
                    session.hasNorthLink = false
                case "South":
                    session.hasSouthLink = false
                case "East":
                    session.hasEastLink = false
                case "West":
                    session.hasWestLink = false
                default:
                    assert(false, "unrecognized direction")
                }
                directionCount -= 1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let counter = indexPath.row
        switch counter{
        case 0:
            cell.textLabel?.text = "North"
        case 1:
            cell.textLabel?.text = "East"
        case 2:
            cell.textLabel?.text = "South"
        case 3:
            cell.textLabel?.text = "West"
        default:
            assert(false, "too many rows")
        }
        cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        return cell
    }
}
