//
//  UAFVehicleView.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 2/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

@IBDesignable class VehicleView: UIImageView {
	@IBInspectable var vehicleType: String!
	@IBInspectable var direction: String!
    var startLocation = CGPoint()
    var dragRecognizer = UIGestureRecognizer()
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override init(image: UIImage?) {
        super.init(image: image)
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        dragRecognizer = UIPanGestureRecognizer()
        super.init(coder: aDecoder)
        addGestureRecognizer(dragRecognizer)
        dragRecognizer.addTarget(self, action: #selector(dragAction))
    }

    @objc func dragAction(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            startLocation = center
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: gesture.view?.superview)
            center = CGPoint(x: startLocation.x + translation.x, y: startLocation.y + translation.y)
        } else if gesture.state == .ended {
            let screenSize = UIScreen.main.bounds.size
            let widthBoundSize = CGFloat(120.0)
            let heightBoundSize = CGFloat(230.0)
            
            if center.x > screenSize.width - widthBoundSize {
                print(direction!, "-> e")
            } else if center.x < widthBoundSize {
                print(direction!, "-> w")
            } else if center.y < heightBoundSize {
                print(direction!, "-> n")
            } else if center.y > screenSize.height - heightBoundSize {
                print(direction!, "-> s")
            } else {
                print("not counted")
                print(center.x)
                print(center.y)
            }
            center = startLocation
        }
    }
}
