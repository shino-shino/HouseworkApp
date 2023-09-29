//
//  PostDataDetailTableViewCell.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/28.
//

import UIKit

class PostDataDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var houseworkNameLabel: UILabel!
    @IBOutlet var houseworkPointLabel: UILabel!
    @IBOutlet var pointUnitLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
