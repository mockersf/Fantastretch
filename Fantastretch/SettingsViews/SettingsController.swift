//
//  SettingsController.swift
//  Fantastretch
//
//  Created by François Mockers on 27/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    @IBOutlet var timersHoldLabel: UILabel!
    @IBOutlet var timersRestLabel: UILabel!
    @IBOutlet var alertsVibrationSwitch: UISwitch!
    @IBOutlet var alertsSoundSwitch: UISwitch!

    var settings: Settings?

    override func viewDidLoad() {
        super.viewDidLoad()

        settings = Settings.sharedInstance
        timersHoldLabel.text = "\(settings!.timerHold) s"
        timersRestLabel.text = "\(settings!.timerRest) s"
        alertsVibrationSwitch.isOn = settings!.alertsVibration
        alertsSoundSwitch.isOn = settings!.alertsSound
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        switch segue.identifier ?? "" {
        case "holdTimerSelection":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let pickerTableController = navigationController.childViewControllers[0] as? PickerTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            pickerTableController.allValues = Array(1 ... 12).flatMap({ "\($0 * 15) seconds" })
            pickerTableController.type = PickTarget.Timer
            pickerTableController.extraInfo = "hold"
            let settings = Settings.sharedInstance
            pickerTableController.current = "\(settings.timerHold) seconds"

        case "restTimerSelection":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let pickerTableController = navigationController.childViewControllers[0] as? PickerTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            pickerTableController.allValues = Array(5 ... 15).flatMap({ "\($0) seconds" })
            pickerTableController.type = PickTarget.Timer
            pickerTableController.extraInfo = "rest"
            let settings = Settings.sharedInstance
            pickerTableController.current = "\(settings.timerRest) seconds"

        case "autoSetUp":
            ()

        case "autoStretchModeSetUp":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let musclePreferenceTableController = navigationController.childViewControllers[0] as? MusclePreferenceTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            let settings = Settings.sharedInstance
            musclePreferenceTableController.getMusclePreference = { settings.autoStretchMusclePreferences[$0] ?? 1 }
            musclePreferenceTableController.updateMusclePreference = { settings.autoStretchMusclePreferences[$0] = $1
                settings.save()
            }

        default:
            fatalError("unexpected segue \(segue.identifier ?? "no identifier")")
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: Actions

    @IBAction func unwindToSettings(sender: UIStoryboardSegue) {
        if let pickerTableController = sender.source as? PickerTableController, let selected = pickerTableController.selected {
            switch pickerTableController.type {
            case .some(PickTarget.Repeat):
                fatalError("PickTarget.Repeat should not happen here")

            case .some(PickTarget.Muscle):
                fatalError("PickTarget.Muscle should not happen here")

            case .some(PickTarget.ExerciseType):
                fatalError("PickTarget.ExerciseType should not happen here")

            case .some(PickTarget.Timer):
                guard let from = pickerTableController.extraInfo else {
                    fatalError("missing info from wich timer we are choosing a value")
                }
                let settings = Settings.sharedInstance
                let newValue = Int(selected.split(separator: " ")[0]) ?? 0
                switch from {
                case "hold":
                    timersHoldLabel.text = "\(newValue) s"
                    settings.timerHold = Int(newValue)
                case "rest":
                    timersRestLabel.text = "\(newValue) s"
                    settings.timerRest = Int(newValue)
                default:
                    fatalError("invalid timer pick: \(from) -> \(selected)")
                }
                settings.save()

            case .none:
                fatalError("missing picker type")
            }
        }
    }
}
