//
//  ResumeSessionCell.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 3/31/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class ResumeSessionCell: UITableViewCell {
    @IBOutlet var sessionName: UILabel?
    @IBOutlet var sessionTime: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
