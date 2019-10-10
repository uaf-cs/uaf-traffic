//
//  ResumeSessionViewController.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 2/25/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class ResumeSessionViewController: UITableViewController {
    let sessionManager = SessionManager()
    var sessions = [Session]()

    override func viewDidLoad() {
        super.viewDidLoad()
        sessions = sessionManager.getSessions()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(sessions.count)
        return sessions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! ResumeSessionCell
        let session = sessions[indexPath.row]
        cell.sessionName?.text = session.name
        cell.sessionTime?.text = session.dateString()
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TrafficCountViewController
        vc.setSession(session: sessions[tableView.indexPathForSelectedRow!.row])
        vc.isResumedSession = true
    }
}
