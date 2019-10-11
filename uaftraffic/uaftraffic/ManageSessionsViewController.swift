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
    var sessions_: [Session] = []
    private var infoSession = Session()
    var usingNetwork: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        replaceSessions(replacementSessions: sessionManager.getSessions())
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func replaceSessions(replacementSessions: [Session]) {
        sessions_.removeAll()
        sessions_.append(contentsOf: replacementSessions)
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(sessions_.count)
        return sessions_.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! ManageSessionCell
        let session = sessions_[indexPath.row]
        cell.sessionName?.text = session.name
        cell.sessionTime?.text = session.dateString()
        cell.deleteButton.addTarget(self, action: #selector(deleteSession), for: .touchUpInside)
        if usingNetwork {
            cell.uploadButton.addTarget(self, action: #selector(uploadSession), for: .touchUpInside)
        }
        cell.saveCSVButton.addTarget(self, action: #selector(saveCSV), for: .touchUpInside)
        cell.editInfoButton.addTarget(self, action: #selector(editInfo), for: .touchUpInside)
        return cell
    }

    @objc func deleteSession(sender: UIButton) {
        let cell = sender.superview!.superview! as! ManageSessionCell
        let indexPath = tableView.indexPath(for: cell)!
        let index = indexPath.row
        let session = sessions_[index]
        let confirmationMessage = "Are you sure you want to delete " + session.name + "?"

        let confirmation = UIAlertController(title: "Delete session", message: confirmationMessage, preferredStyle: .alert)
        confirmation.addAction(UIAlertAction(title: "Yes, discard data", style: .destructive, handler: { _ in
            self.tableView.beginUpdates()
            self.sessionManager.deleteSession(session: session)
            let refreshedSessionList: [Session] = self.sessionManager.getSessions()
            self.replaceSessions(replacementSessions: refreshedSessionList)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }))
        confirmation.addAction(UIAlertAction(title: "No, keep data", style: .cancel, handler: nil))
        present(confirmation, animated: true, completion: nil)
    }

    @objc func uploadSession(sender: UIButton) {
        if !usingNetwork {
            return
        }
        let cell = sender.superview!.superview! as! ManageSessionCell
        let indexPath = tableView.indexPath(for: cell)!
        let session = sessions_[indexPath.row]
        networkManager.uploadSession(session: session) { (success) -> Void in
            if success {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.sessionManager.deleteSession(session: session)
                    self.replaceSessions(replacementSessions: self.sessionManager.getSessions())
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

    @objc func saveCSV(sender: UIButton) {
        let cell = sender.superview!.superview! as! ManageSessionCell
        let indexPath = tableView.indexPath(for: cell)!
        let session = sessions_[indexPath.row]
        session.saveCSV()
        let okAlert = UIAlertController(title: "Saved CSV", message: "CSV saved successfully", preferredStyle: .alert)
        okAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(okAlert, animated: true, completion: nil)
    }

    @objc func editInfo(sender: UIButton) {
        let cell = sender.superview!.superview! as! ManageSessionCell
        let indexPath = tableView.indexPath(for: cell)!
        infoSession = sessions_[indexPath.row]
        performSegue(withIdentifier: "EditInfo", sender: self)
        /* let cell = sender.superview!.superview! as! ManageSessionCell
         let indexPath = tableView.indexPath(for: cell)!
         let session = sessions[indexPath.row]

         let namePrompt = UIAlertController(title: "Session Form", message: "Please Input Session Information", preferredStyle: .alert)
         namePrompt.addTextField { textField in
             textField.placeholder = (session.name != "") ? session.name : "Session Title"
         }
         namePrompt.addTextField(configurationHandler: { textField in
             textField.placeholder = (session.lat != "") ? session.lat : "Latitude"
         })
         namePrompt.addTextField(configurationHandler: { textField in
             textField.placeholder = (session.lon != "") ? session.lon : "Longitude"
         })
         namePrompt.addTextField { textField in
             textField.placeholder = (session.EWRoadName != "") ? session.EWRoadName : "East-West Road Name"
         }
         namePrompt.addTextField(configurationHandler: { textField in
             textField.placeholder = (session.NSRoadName != "") ? session.NSRoadName : "North-South Road Name"
         })
         namePrompt.addTextField(configurationHandler: { textField in
             textField.placeholder = (session.technician != "") ? session.technician : "Technician Name"
         })

         namePrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak namePrompt] _ in
             let name = namePrompt!.textFields![0].text!
             session.name = (name != "") ? name : session.name
             let lat = namePrompt!.textFields![1].text!
             session.lat = (lat != "") ? lat : session.lat
             let lon = namePrompt!.textFields![2].text!
             session.lon = (lon != "") ? lon : session.lon
             let ewRoad = namePrompt!.textFields![3].text!
             session.EWRoadName = (ewRoad != "") ? ewRoad : session.EWRoadName
             let nsRoad = namePrompt!.textFields![4].text!
             session.NSRoadName = (nsRoad != "") ? nsRoad : session.NSRoadName
             let technician = namePrompt!.textFields![5].text!
             session.technician = (technician != "") ? technician : session.technician
         }))

         namePrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

         present(namePrompt, animated: true, completion: nil) */
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            print(#function + ": DEBUGGER: segue id is " + id)
        } else {
            print(#function + ": DEBUGGER: segue id is nil!")
        }

        if segue.identifier == "sessionDetail" {
            let vc = segue.destination as! SessionDetailsViewController
            vc.setSession(session: sessions_[tableView.indexPathForSelectedRow!.row])
        } else if segue.identifier == "EditInfo" {
            let vc = segue.destination as! SessionInfoViewController
            vc.setSession(session: infoSession)
        }
    }
}
