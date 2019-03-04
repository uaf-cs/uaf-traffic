//
//  UAFBigFancyButton.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 2/24/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class BigFancyButton: UIButton {
    let normalBackgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
    let highlightedBackgroundColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = normalBackgroundColor
        layer.cornerRadius = 3
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedBackgroundColor : normalBackgroundColor
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
