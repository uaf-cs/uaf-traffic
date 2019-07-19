//
//  TrafficSummaryViewCell.swift
//  uaftraffic
//
//  Created by Joseph Wolf on 7/19/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import Foundation
import UIKit

class TrafficSummaryViewCell: UITableViewCell{
    
    @IBOutlet weak var vehicle: UIImageView!
    @IBOutlet weak var throughCount: UILabel!
    @IBOutlet weak var leftCount: UILabel!
    @IBOutlet weak var rightCount: UILabel!
    
    var selectLabel: String = ""
    
}

class TrafficSummaryHeaderCell: UITableViewCell{

    @IBOutlet weak var directionLabel: UILabel!
    
}
