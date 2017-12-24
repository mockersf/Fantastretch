//
//  DoExerciseCell.swift
//  Fantastretch
//
//  Created by François Mockers on 28/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class DoExerciseCell: UITableViewCell {

    @IBOutlet var imagePhotoView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var sidesLabel: UILabel!
    @IBOutlet var doItButton: UIButton!
    var exercise: ExerciseWithMetadata?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
