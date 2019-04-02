//
//  UAFManageSessionsViewController.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 2/24/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class ManageSessionsViewController: UITableViewController {
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SessionDetailsViewController
        vc.session = sessions[tableView.indexPathForSelectedRow!.row]
    }

}
