//
//  TrafficSummaryViewController.swift
//  uaftraffic
//
//  Created by Joseph Wolf on 7/19/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import Foundation
import UIKit

class TrafficSummaryViewController: UITableViewController {
    var boundFor: [String] = []
    var sortedCountFromSouth: [[Int]] = []
    var sortedCountFromNorth: [[Int]] = []
    var sortedCountFromEast: [[Int]] = []
    var sortedCountFromWest: [[Int]] = []
    var vehicleTypes: Int = 0
    //vehicles 1-5 will be the first input, and the directions will be the second input, left = 0, through = 1, right = 2, with the stored values being the total crossings of that direction and vehicle type
    @IBOutlet weak var dateItem: UIBarButtonItem!

    private var session_: Session? // Session may not be initialized until after a segue
    func setSession(session: Session?) {
        if let s = session {
            session_ = s
        } else {
            assert(session == nil, "session_ must be initialized before segue!")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let session = session_ {
            var directionCount: Int = 0
            if session.hasNorthLink { directionCount += 1 }
            if session.hasEastLink { directionCount += 1 }
            if session.hasWestLink { directionCount += 1 }
            if session.hasSouthLink { directionCount += 1 }
            return directionCount
        }
        return 0
    }

    override func viewDidLoad() {
        if let session = session_ {
            title = "Traffic Summary for " + session.name
            dateItem.title = session.dateString()
            if session.hasNorthLink { boundFor.append("Southbound") }
            if session.hasSouthLink { boundFor.append("Northbound") }
            if session.hasWestLink { boundFor.append("Eastbound") }
            if session.hasEastLink { boundFor.append("Westbound") }
            //Since the vehicle selection appends the empty strings to the back of the array of vehicles, finding the first empty string will determine how many vehicles are present at the crossing
            if session.vehicle1Type == "" { vehicleTypes = 0 }
            else if session.vehicle2Type == "" { vehicleTypes = 1 }
            else if session.vehicle3Type == "" { vehicleTypes = 2 }
            else if session.vehicle4Type == "" { vehicleTypes = 3 }
            else if session.vehicle5Type == "" { vehicleTypes = 4 }
            else { vehicleTypes = 5 }
            let crossingCount = Array(repeating: 0, count: 3)
            let vehicleSeparators = Array(repeating: crossingCount, count: vehicleTypes)
            sortedCountFromEast = vehicleSeparators
            sortedCountFromNorth = vehicleSeparators
            sortedCountFromWest = vehicleSeparators
            sortedCountFromSouth = vehicleSeparators
            var vehicleTypeNum: Int = 0
            for crossing in session.crossings {
                if crossing.type == session.vehicle1Type { vehicleTypeNum = 0 }
                else if crossing.type == session.vehicle2Type { vehicleTypeNum = 1 }
                else if crossing.type == session.vehicle3Type { vehicleTypeNum = 2 }
                else if crossing.type == session.vehicle4Type { vehicleTypeNum = 3 }
                else if crossing.type == session.vehicle5Type { vehicleTypeNum = 4 }
                let strFrom = crossing.from
                let strTo = crossing.to
                switch strFrom {
                case "n":
                    switch strTo {
                    case "n":
                        continue
                    case "s":
                        sortedCountFromNorth [vehicleTypeNum][1] += 1
                    case "e":
                        sortedCountFromNorth [vehicleTypeNum][0] += 1
                    case "w":
                        sortedCountFromNorth [vehicleTypeNum][2] += 1
                    default:
                        assert(false, "unrecognized 'to' direction")
                    }
                case "s":
                    switch strTo {
                    case "s":
                        continue
                    case "n":
                        sortedCountFromSouth [vehicleTypeNum][1] += 1
                    case "w":
                        sortedCountFromSouth [vehicleTypeNum][0] += 1
                    case "e":
                        sortedCountFromSouth [vehicleTypeNum][2] += 1
                    default:
                        assert(false, "unrecognized 'to' direction")
                    }
                case "w":
                    switch strTo {
                    case "w":
                        continue
                    case "e":
                        sortedCountFromWest [vehicleTypeNum][1] += 1
                    case "n":
                        sortedCountFromWest [vehicleTypeNum][0] += 1
                    case "s":
                        sortedCountFromWest [vehicleTypeNum][2] += 1
                    default:
                        assert(false, "unrecognized 'to' direction")
                    }
                case "e":
                    switch strTo {
                    case "e":
                        continue
                    case "w":
                        sortedCountFromEast [vehicleTypeNum][1] += 1
                    case "s":
                        sortedCountFromEast [vehicleTypeNum][0] += 1
                    case "n":
                        sortedCountFromEast [vehicleTypeNum][2] += 1
                    default:
                        assert(false, "unrecognized 'to' direction")
                    }
                default:
                    assert(false, "unrecognized 'from' direction")
                }
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
        if let session = session_ {
            let cell = tableView.dequeueReusableCell(withIdentifier: "crossingCell", for: indexPath) as! TrafficSummaryViewCell
            let counter = indexPath.row
            switch counter {
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
            switch direction {
            case "Southbound":
                cell.leftCount.text = String(sortedCountFromNorth [counter][0])
                cell.rightCount.text = String(sortedCountFromNorth [counter][2])
                cell.throughCount.text = String(sortedCountFromNorth [counter][1])
            case "Northbound":
                cell.leftCount.text = String(sortedCountFromSouth [counter][0])
                cell.rightCount.text = String(sortedCountFromSouth [counter][2])
                cell.throughCount.text = String(sortedCountFromSouth [counter][1])
            case "Eastbound":
                cell.leftCount.text = String(sortedCountFromWest [counter][0])
                cell.rightCount.text = String(sortedCountFromWest [counter][2])
                cell.throughCount.text = String(sortedCountFromWest [counter][1])
            case "Westbound":
                cell.leftCount.text = String(sortedCountFromEast [counter][0])
                cell.rightCount.text = String(sortedCountFromEast [counter][2])
                cell.throughCount.text = String(sortedCountFromEast [counter][1])
            default:
                assert(false, "unrecognized direction")
            }
            cell.vehicle.image = UIImage(named: cell.selectLabel + "-black")
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
