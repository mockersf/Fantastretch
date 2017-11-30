//
//  StretchTableNewCell.swift
//  Fantastretch
//
//  Created by François Mockers on 29/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class StretchTableNewCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var sidesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
