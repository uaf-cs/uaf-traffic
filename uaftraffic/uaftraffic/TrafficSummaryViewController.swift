//
//  TrafficSummaryViewController.swift
//  uaftraffic
//
//  Created by Joseph Wolf on 7/19/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import Foundation
import UIKit

class TrafficSummaryViewController: UITableViewController{
    var session = Session()
    var boundFor: [String] = []
    var sortedCount: [[Int]] = [[]]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var count: Int = 0
        if session.hasNorthLink {count += 1}
        if session.hasEastLink {count += 1}
        if session.hasWestLink {count += 1}
        if session.hasSouthLink {count += 1}
        return count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Since the vehicle selection 
        if session.vehicle1Type == "" {return 0}
        if session.vehicle2Type == "" {return 1}
        if session.vehicle3Type == "" {return 2}
        if session.vehicle4Type == "" {return 3}
        if session.vehicle5Type == "" {return 4}
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! TrafficSummaryHeaderCell
        if session.hasNorthLink {boundFor.append("Southbound")}
        if session.hasSouthLink {boundFor.append("Northbound")}
        if session.hasWestLink {boundFor.append("Eastbound")}
        if session.hasEastLink {boundFor.append("Westbound")}
        cell.directionLabel.text = boundFor[section]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "crossingCell", for: indexPath) as! TrafficSummaryViewCell
        let counter = indexPath.row
        switch counter{
        case 0:
            cell.selectLabel = session.vehicle1Type
        case 1:
            cell.selectLabel = session.vehicle2Type
        case 2:
            cell.selectLabel = session.vehicle3Type
        case 3:
            cell.selectLabel = session.vehicle4Type
        case 4:
            cell.selectLabel = session.vehicle5Type
        default:
            assert(false, "too many rows")
        }
        //var test = sortedCount[indexPath.section][indexPath.row]
        let direction = boundFor[indexPath.section]
        switch direction{
        
        default:
            assert(false, "unrecognized direction")
        }
        cell.vehicle.image = UIImage(named: cell.selectLabel + "-black")
        return cell
    }
    
}
