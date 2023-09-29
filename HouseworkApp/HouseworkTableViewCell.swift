//
//  HouseworkTableViewCell.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/11.
//

import UIKit

class HouseworkTableViewCell: UITableViewCell {
    
    @IBOutlet var houseworkNameLabel: UILabel!
    @IBOutlet var houseworkPointLabel: UILabel!
    @IBOutlet var houseworkUnitLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
