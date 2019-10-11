//
//  UAFPinEntryViewViewController.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 2/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit
import AVFoundation

class PinEntryViewController: UIViewController {
    @IBOutlet weak var pinField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var errorMessage: UITextField!
    var audioPlayer: AVAudioPlayer!
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        if sender.text!.count == 4 {
            sender.isEnabled = false
            cancelButton.isEnabled = false
            networkManager.pinValid(pin: sender.text!) { (valid) -> () in
                if valid {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    print("invalid pin")
                    self.playError()
                    DispatchQueue.main.async {
                        self.errorMessage.text = "invalid pin"
                        self.pinField.text = ""
                        self.pinField.isEnabled = true
                        self.cancelButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    func playError() {
        let url = Bundle.main.url(forResource: "error", withExtension: "wav")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        audioPlayer.play()
    }
}
