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
    var sortedCountFromSouth: [[Int]] = []
    var sortedCountFromNorth: [[Int]] = []
    var sortedCountFromEast: [[Int]] = []
    var sortedCountFromWest: [[Int]] = []
    var vehicleTypes: Int = 0
    //vehicles 1-5 will be the first input, and the directions will be the second input, left = 0, through = 1, right = 2, with the stored values being the total crossings of that direction and vehicle type
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var directionCount: Int = 0
        if session.hasNorthLink {directionCount += 1}
        if session.hasEastLink {directionCount += 1}
        if session.hasWestLink {directionCount += 1}
        if session.hasSouthLink {directionCount += 1}
        return directionCount
    }
    
    override func viewDidLoad() {
        if session.hasNorthLink {boundFor.append("Southbound")}
        if session.hasSouthLink {boundFor.append("Northbound")}
        if session.hasWestLink {boundFor.append("Eastbound")}
        if session.hasEastLink {boundFor.append("Westbound")}
        //Since the vehicle selection appends the empty strings to the back of the array of vehicles, finding the first empty string will determine how many vehicles are present at the crossing
        if session.vehicle1Type == "" {vehicleTypes = 0}
        else if session.vehicle2Type == "" {vehicleTypes = 1}
        else if session.vehicle3Type == "" {vehicleTypes = 2}
        else if session.vehicle4Type == "" {vehicleTypes = 3}
        else if session.vehicle5Type == "" {vehicleTypes = 4}
        else {vehicleTypes = 5}
        let crossingCount = Array(repeating: 0, count: 3)
        let vehicleSeparators = Array(repeating: crossingCount, count: vehicleTypes)
        sortedCountFromEast = vehicleSeparators
        sortedCountFromNorth = vehicleSeparators
        sortedCountFromWest = vehicleSeparators
        sortedCountFromSouth = vehicleSeparators
        for crossing in session.crossings{
            let strFrom = crossing.from
            let strTo = crossing.to
            switch strFrom{
            case "n":
                switch strTo{
                default:
                    assert(false, "unrecognized 'to' direction")
                }
            default:
                assert(false, "unrecognized 'from' direction")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleTypes
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! TrafficSummaryHeaderCell
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
        /*let direction = boundFor[indexPath.section]
        switch direction{
        
        default:
            assert(false, "unrecognized direction")
        }*/
        cell.vehicle.image = UIImage(named: cell.selectLabel + "-black")
        return cell
    }
    
}
