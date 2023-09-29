//
//  PostDataTableViewCell.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/20.
//

import UIKit

class PostDataTableViewCell: UITableViewCell {
    
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var PointLabel: UILabel!
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
