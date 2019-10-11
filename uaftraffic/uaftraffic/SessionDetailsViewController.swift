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

    private var session_: Session? // Session may not be initialized until after a segue
    func setSession(session: Session?) {
        if let s = session {
            session_ = s
        } else {
            assert(session == nil, "session_ must be initialized before segue!")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let session = session_ {
            title = "Crossings for " + session.name
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let session = session_ {
            return session.crossings.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "crossingCell", for: indexPath) as! SessionDetailsCrossingCell
        if let session = session_ {
            let crossing = session.crossings[indexPath.row]
            cell.vehicle.image = UIImage(named: crossing.type + "-black")
            cell.direction.text = directionName(crossing.from) + " → " + directionName(crossing.to)
            cell.time.text = crossing.dateString()
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            print("DEBUGGER: segue id is " + id)
        } else {
            print("DEBUGGER: segue id is nil!")
        }

        if let session = session_ {
            let vc = segue.destination as! TrafficSummaryViewController
            vc.setSession(session: session)
        } else {
            print(#function + ": DEBUGGER: session_ must not be nil!")
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

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if let session = session_ {
            if editingStyle == .delete {
                session.crossings.remove(at: indexPath.row)
                sessionManager.writeSession(session: session)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
    }
}
