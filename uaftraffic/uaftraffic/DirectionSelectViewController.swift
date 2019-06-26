//
//  DirectionSelectController.swift
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
}
