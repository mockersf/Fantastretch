//
//  StretchTableNewCell.swift
//  Fantastretch
//
//  Created by François Mockers on 29/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class StretchTableNewCell: UITableViewCell {

    @IBOutlet var photoView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var sidesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
