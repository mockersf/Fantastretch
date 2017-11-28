//
//  MusclePreferenceCell.swift
//  Fantastretch
//
//  Created by François Mockers on 28/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class MusclePreferenceCell: UITableViewCell {

    @IBOutlet weak var muscleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreStepper: UIStepper!
    var muscle: Muscle?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func scoreStepperChanged(_ sender: UIStepper) {
        scoreLabel.text = "\(Int(sender.value))"
        let settings = Settings()
        settings.musclePreferences[muscle!] = Int(sender.value)
        settings.save()
    }
}
