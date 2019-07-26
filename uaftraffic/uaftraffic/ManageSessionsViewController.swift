//
//  UAFManageSessionsViewController.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 2/24/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class ManageSessionsViewController: UITableViewController {
    let networkManager = NetworkManager()
    let sessionManager = SessionManager()
    var sessions = [Session]()

    override func viewDidLoad() {
        super.viewDidLoad()
        sessions = sessionManager.getSessions()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! ManageSessionCell
        let session = sessions[indexPath.row]
        cell.sessionName?.text = session.name
        cell.sessionTime?.text = session.dateString()
        cell.deleteButton.addTarget(self, action: #selector(self.deleteSession), for: .touchUpInside)
        cell.uploadButton.addTarget(self, action: #selector(self.uploadSession), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteSession(sender: UIButton) {
        let cell = sender.superview!.superview! as! ManageSessionCell
        let indexPath = tableView.indexPath(for: cell)!
        let index = indexPath.row
        let session = sessions[index]
        let confirmationMessage = "Are you sure you want to delete " + session.name + "?"
        
        let confirmation = UIAlertController(title: "Delete session", message: confirmationMessage, preferredStyle: .alert)
        confirmation.addAction(UIAlertAction(title: "Yes, discard data", style: .destructive, handler: { _ in
            self.tableView.beginUpdates()
            self.sessionManager.deleteSession(session: session)
            self.sessions = self.sessionManager.getSessions()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }))
        confirmation.addAction(UIAlertAction(title: "No, keep data", style: .cancel, handler: nil))
        present(confirmation, animated: true, completion: nil)
    }
    
    @objc func uploadSession(sender: UIButton) {
        let cell = sender.superview!.superview! as! ManageSessionCell
        let indexPath = tableView.indexPath(for: cell)!
        let session = sessions[indexPath.row]
        networkManager.uploadSession(session: session) { (success) -> () in
            if success {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.sessionManager.deleteSession(session: session)
                    self.sessions = self.sessionManager.getSessions()
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.endUpdates()
                }
            } else {
                print("upload failed")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "pinEntry", sender: self)
                }
            }
        }
    }
    
    /*
     func fileExport(session: Session){
        let fileName = session.name + ".csv"
        var csvData = "vehicle, from, to, date\n"
     
        for crossing in session.crossings{
            csvData += "\(crossing.type), \(crossing.from), \(crossing.to), \(crossing.dateString())\n"
        }
     }
     */
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sessionDetail" {
            let vc = segue.destination as! SessionDetailsViewController
            vc.session = sessions[tableView.indexPathForSelectedRow!.row]
        }
    }
}
