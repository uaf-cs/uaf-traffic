//
//  UAFVehicleView.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 2/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable class VehicleView: UIImageView {
	@IBInspectable var vehicleType: String!
	@IBInspectable var direction: String!
    @IBOutlet weak var northBlock: UIImageView!
    @IBOutlet weak var southBlock: UIImageView!
    @IBOutlet weak var eastBlock: UIImageView!
    @IBOutlet weak var westBlock: UIImageView!
    var startLocation = CGPoint()
    var dragRecognizer = UIGestureRecognizer()
    var audioPlayer = AVAudioPlayer()
    var centerSet = false
    var screenWidth = UIScreen.main.bounds.width
    var isActive: Bool = true
//    var screenHeight = UIScreen.main.bounds.height
//    var orientation = UIDevice.current.orientation
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        //startLocation = center
    }

    override init(image: UIImage?) {
        super.init(image: image)
        //startLocation = center
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        //startLocation = center
    }
    
    required init?(coder aDecoder: NSCoder) {
        dragRecognizer = UIPanGestureRecognizer()
        super.init(coder: aDecoder)
        addGestureRecognizer(dragRecognizer)
        dragRecognizer.addTarget(self, action: #selector(dragAction))
        //startLocation = center
    }

    @objc func dragAction(_ gesture: UIPanGestureRecognizer) {
        if !isActive {return}
        self.layer.zPosition = 20
        if screenWidth != UIScreen.main.bounds.width{
            centerSet = false
            screenWidth = UIScreen.main.bounds.width
        }
        if centerSet == false {
            startLocation = center
            centerSet = true
        }
        if gesture.state == .changed {
            let translation = gesture.translation(in: gesture.view?.superview)
            center = CGPoint(x: startLocation.x + translation.x, y: startLocation.y + translation.y)
        } else if gesture.state == .ended {
            if (center.x > eastBlock.frame.minX || center.x < westBlock.frame.maxX) && (center.y > southBlock.frame.minY || center.y < northBlock.frame.maxY){
                print("not counted:", center.x, center.y)
                playError()
                UIView.animate(withDuration: 0.2) { () -> Void in
                    self.center = self.startLocation
                }
            }else if center.x > eastBlock.frame.minX && eastBlock.isHidden {
                addCrossing(from: direction!, to: "e")
            } else if center.x < westBlock.frame.maxX && westBlock.isHidden {
                addCrossing(from: direction!, to: "w")
            } else if center.y < northBlock.frame.maxY && northBlock.isHidden {
                addCrossing(from: direction!, to: "n")
            } else if center.y > southBlock.frame.minY && southBlock.isHidden {
                addCrossing(from: direction!, to: "s")
            } else {
                print("not counted:", center.x, center.y)
                playError()
                UIView.animate(withDuration: 0.2) { () -> Void in
                    self.center = self.startLocation
                }
            }
        } else if gesture.state == .cancelled {
            center = startLocation
        }
    }
    
    func addCrossing(from: String, to: String) {
        print(from, "->", to)
        let userInfo:[String: String] = ["type": vehicleType, "from": from, "to": to]
        NotificationCenter.default.post(name: .addCrossing, object: nil, userInfo: userInfo)
//        playDing()
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }, completion: { (Bool) -> Void in
            self.center = self.startLocation
            UIView.animate(withDuration: 0.1) { () -> Void in
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        })
    }
    
    /*func playDing() {
        let url = Bundle.main.url(forResource: "ding", withExtension: "mp3")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        audioPlayer.play()
    }*/
    
    func playError() {
        let url = Bundle.main.url(forResource: "error", withExtension: "mp3")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        audioPlayer.play()
    }
}
