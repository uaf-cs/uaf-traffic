//
//  SessionDetailsViewController.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 3/31/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class SessionDetailsViewController: UITableViewController {
    let sessionManager = SessionManager()
    var session = Session()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crossings for " + session.name
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return session.crossings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "crossingCell", for: indexPath) as! SessionDetailsCrossingCell
        let crossing = session.crossings[indexPath.row]
        cell.vehicle.image = UIImage(named: crossing.type + "-black")
        cell.direction.text = directionName(crossing.from) + " → " + directionName(crossing.to)
        cell.time.text = crossing.dateString()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TrafficSummaryViewController {
            vc.session = session
        } else {
            print("TrafficSummaryViewController could not be upcast")
        }
    }
    
    func directionName(_ abbreviation: String) -> String {
        switch abbreviation {
        case "n":
            return "North"
        case "e":
            return "East"
        case "s":
            return "South"
        case "w":
            return "West"
        default:
            assert(false, "Unrecognized direction")
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            session.crossings.remove(at: indexPath.row)
            sessionManager.writeSession(session: session)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
