//
//  ManageSessionCell.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 3/26/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class ManageSessionCell: UITableViewCell {
    @IBOutlet var sessionName: UILabel?
    @IBOutlet var sessionTime: UILabel?
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var saveCSVButton: UIButton!
    @IBOutlet weak var editInfoButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
