//
//  SessionDetailsCell.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 4/1/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class SessionDetailsCrossingCell: UITableViewCell {
    @IBOutlet weak var vehicle: UIImageView!
    @IBOutlet weak var direction: UILabel!
    @IBOutlet weak var time: UILabel!
    var selectLabel: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
