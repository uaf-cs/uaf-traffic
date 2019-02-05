//
//  UAFVehicleView.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 2/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

@IBDesignable class UAFVehicleView: UIImageView {
	@IBInspectable var vehicleType: String!
	@IBInspectable var direction: String!
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let message = String(format: "Touched %@ on %@ side", self.vehicleType, self.direction);
		print(message)
	}

}
