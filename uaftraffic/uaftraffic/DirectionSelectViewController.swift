//
//  DirectionSelectViewController.swift
//  uaftraffic
//
//  Created by Joseph Wolf on 6/24/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class DirectionSelectViewController: UITableViewController {
    
    @IBAction func cancelButtonTapped(_ sender: Any){
    self.dismiss(animated: true, completion: nil)
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
        }
        else{
            cell?.accessoryType = UITableViewCell.AccessoryType.none
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
