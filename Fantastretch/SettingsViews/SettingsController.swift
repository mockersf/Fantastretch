//
//  SettingsController.swift
//  Fantastretch
//
//  Created by François Mockers on 27/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    @IBOutlet var alertsVibrationSwitch: UISwitch!
    @IBOutlet var alertsSoundSwitch: UISwitch!
    @IBOutlet var autoAdvancedSwitch: UISwitch!

    @IBOutlet var firstAutoSetUp: UILabel!

    var settings: Settings?

    override func viewDidLoad() {
        super.viewDidLoad()

        settings = Settings.sharedInstance
        alertsVibrationSwitch.isOn = settings!.alertsVibration
        alertsSoundSwitch.isOn = settings!.alertsSound
        autoAdvancedSwitch.isOn = settings!.advancedAuto
        setFirstAutoSetUpLabel()
    }

    private func setFirstAutoSetUpLabel() {
        if settings!.advancedAuto {
            firstAutoSetUp.text = "Stretches"
        } else {
            firstAutoSetUp.text = "All Exercise Types"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        switch segue.identifier ?? "" {
        case "autoSetUpStretches":
            guard let autoSetUpController = segue.destination as? AutoSetUpController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            autoSetUpController.settingsExerciseType = Settings.sharedInstance.autoStretchSettings

        case "autoSetUpExercises":
            guard let autoSetUpController = segue.destination as? AutoSetUpController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            autoSetUpController.settingsExerciseType = Settings.sharedInstance.autoExerciseSettings

        default:
            fatalError("unexpected segue \(segue.identifier ?? "no identifier")")
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: - Table view data source

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            if Settings.sharedInstance.advancedAuto {
                return 3
            } else {
                return 2
            }
        case 2:
            return 2
        case 3:
            return 3
        default:
            return 0
        }
    }

    @IBAction func alertsVibrationSwitched(_ sender: UISwitch) {
        Settings.sharedInstance.alertsVibration = sender.isOn
        Settings.sharedInstance.save()
    }

    @IBAction func alertsSoundSwitched(_ sender: UISwitch) {
        Settings.sharedInstance.alertsSound = sender.isOn
        Settings.sharedInstance.save()
    }

    @IBAction func autoAdvancedSwitched(_ sender: UISwitch) {
        Settings.sharedInstance.advancedAuto = sender.isOn
        Settings.sharedInstance.saveExerciseTypeSettings()
        setFirstAutoSetUpLabel()
        tableView.reloadData()
    }
}
