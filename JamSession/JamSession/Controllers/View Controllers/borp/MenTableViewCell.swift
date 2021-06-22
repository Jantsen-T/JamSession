//
//  MenTableViewCell.swift
//  BlamConfession
//
//  Created by Gavin Craft on 6/22/21.
//

import UIKit

class MenTableViewCell: UITableViewCell {
    @IBOutlet weak var pfpView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
