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
    var startLocation = CGPoint()
    var dragRecognizer = UIGestureRecognizer()
    var audioPlayer = AVAudioPlayer()
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        startLocation = center
    }

    override init(image: UIImage?) {
        super.init(image: image)
        startLocation = center
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        startLocation = center
    }
    
    required init?(coder aDecoder: NSCoder) {
        dragRecognizer = UIPanGestureRecognizer()
        super.init(coder: aDecoder)
        addGestureRecognizer(dragRecognizer)
        dragRecognizer.addTarget(self, action: #selector(dragAction))
        startLocation = center
    }

    @objc func dragAction(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: gesture.view?.superview)
            center = CGPoint(x: startLocation.x + translation.x, y: startLocation.y + translation.y)
        } else if gesture.state == .ended {
            let screenSize = UIScreen.main.bounds.size
            let widthBoundSize = CGFloat(120.0)
            let heightBoundSize = CGFloat(230.0)
            
            if center.x > screenSize.width - widthBoundSize {
                addCrossing(from: direction!, to: "e")
            } else if center.x < widthBoundSize {
                addCrossing(from: direction!, to: "w")
            } else if center.y < heightBoundSize {
                addCrossing(from: direction!, to: "n")
            } else if center.y > screenSize.height - heightBoundSize {
                addCrossing(from: direction!, to: "s")
            } else {
                print("not counted:", center.x, center.y)
                playError()
            }
            center = startLocation
        } else if gesture.state == .cancelled {
            center = startLocation
        }
    }
    
    func addCrossing(from: String, to: String) {
        print(from, "->", to)
        let userInfo:[String: String] = ["type": vehicleType, "from": from, "to": to]
        NotificationCenter.default.post(name: .addCrossing, object: nil, userInfo: userInfo)
        playDing()
    }
    
    func playDing() {
        print("ding!")
        let url = Bundle.main.url(forResource: "ding", withExtension: "mp3")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        audioPlayer.play()
    }
    
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
