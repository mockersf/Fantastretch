//
//  SettingsController.swift
//  Fantastretch
//
//  Created by François Mockers on 27/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    @IBOutlet weak var timersHoldLabel: UILabel!
    @IBOutlet weak var timersRestLabel: UILabel!
    @IBOutlet weak var alertsVibrationSwitch: UISwitch!
    @IBOutlet weak var alertsSoundSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        let settings = Settings()
        timersHoldLabel.text = "\(settings.timerHold) s"
        timersRestLabel.text = "\(settings.timerRest) s"
        alertsVibrationSwitch.isOn = settings.alertsVibration
        alertsSoundSwitch.isOn = settings.alertsSound
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    // MARK: Actions
    @IBAction func unwindToSettings(sender _: UIStoryboardSegue) {
    }
}
