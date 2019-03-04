//
//  UAFTrafficCountViewController.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 2/24/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class TrafficCountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func endSessionButtonTapped(_ sender: Any) {
        let confirmation = UIAlertController(title: "End Session", message: "Are you sure you want to end this session?", preferredStyle: .alert)
        confirmation.addAction(UIAlertAction(title: "Yes, end session", style: .destructive, handler: getSessionName))
        confirmation.addAction(UIAlertAction(title: "No, continue", style: .cancel, handler: nil))
        present(confirmation, animated: true, completion: nil)
    }
    
    func getSessionName(sender: UIAlertAction) {
        let namePrompt = UIAlertController(title: "Session Name", message: "What should this session be called?", preferredStyle: .alert)
        namePrompt.addTextField { textField in
            textField.placeholder = "Intersection of main and 3rd"
        }
        namePrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak namePrompt] _ in
            guard let name = namePrompt!.textFields!.first!.text else { return }
            self.endSession(name: name)
        }))
        namePrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(namePrompt, animated: true, completion: nil)
    }
    
    func endSession(name: String) {
        print("Ending session")
        print(name)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
