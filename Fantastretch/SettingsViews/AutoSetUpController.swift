//
//  AutoSetUpController.swift
//  Fantastretch
//
//  Created by François Mockers on 06/01/2018.
//  Copyright © 2018 Vleue. All rights reserved.
//

import UIKit

class AutoSetUpController: UITableViewController {

    var settingsExerciseType: SettingsExerciseType?

    @IBOutlet var exercixesNbLabel: UILabel!
    @IBOutlet var exerciseNbStepper: UIStepper!
    @IBOutlet var exercisesRepetitionsLabel: UILabel!
    @IBOutlet var exerciseRepetitionStepper: UIStepper!
    @IBOutlet var advancedAbsSwitch: UISwitch!
    @IBOutlet var timersHoldLabel: UILabel!
    @IBOutlet var timersRestLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        exercixesNbLabel.text = "\(settingsExerciseType!.nbOfExercises)"
        exerciseNbStepper.value = Double(settingsExerciseType!.nbOfExercises)
        exercisesRepetitionsLabel.text = "\(settingsExerciseType!.nbRepetitions)"
        exerciseRepetitionStepper.value = Double(settingsExerciseType!.nbRepetitions)
        timersHoldLabel.text = "\(settingsExerciseType!.timerActive) s"
        timersRestLabel.text = "\(settingsExerciseType!.timerRest) s"
        advancedAbsSwitch.isOn = settingsExerciseType!.advancedAbs
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        switch segue.identifier ?? "" {
        case "musclePreferences":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let musclePreferenceTableController = navigationController.childViewControllers[0] as? MusclePreferenceTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            let settings = Settings.sharedInstance
            musclePreferenceTableController.getMusclePreference = { self.settingsExerciseType!.musclePreferences[$0] ?? 1 }
            musclePreferenceTableController.updateMusclePreference = { self.settingsExerciseType!.musclePreferences[$0] = $1
                settings.saveExerciseTypeSettings()
            }
            musclePreferenceTableController.muscles = Muscle.getAllMuscles(settings: settingsExerciseType!)

        case "holdTimerSelection":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let pickerTableController = navigationController.childViewControllers[0] as? PickerTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            pickerTableController.allValues = Settings.activeTimerOptions
            pickerTableController.type = PickTarget.Timer
            pickerTableController.extraInfo = "hold"
            pickerTableController.current = "\(settingsExerciseType!.timerActive) seconds"

        case "restTimerSelection":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let pickerTableController = navigationController.childViewControllers[0] as? PickerTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            pickerTableController.allValues = Settings.restTimerOptions
            pickerTableController.type = PickTarget.Timer
            pickerTableController.extraInfo = "rest"
            pickerTableController.current = "\(settingsExerciseType!.timerRest) seconds"

        default:
            fatalError("unexpected segue \(segue.identifier ?? "no identifier")")
        }
    }

    @IBAction func advancedAbsSwitched(_: UISwitch) {
        settingsExerciseType!.advancedAbs = advancedAbsSwitch.isOn
        Settings.sharedInstance.saveExerciseTypeSettings()
    }

    @IBAction func changeNbExercises(_ sender: UIStepper) {
        exercixesNbLabel.text = "\(Int(sender.value))"
        settingsExerciseType!.nbOfExercises = Int(sender.value)
        Settings.sharedInstance.saveExerciseTypeSettings()
    }

    @IBAction func changeRepetitionExercises(_ sender: UIStepper) {
        exercisesRepetitionsLabel.text = "\(Int(sender.value))"
        settingsExerciseType!.nbRepetitions = Int(sender.value)
        Settings.sharedInstance.saveExerciseTypeSettings()
    }

    @IBAction func unwindToExerciseTypeSettings(sender: UIStoryboardSegue) {
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
                let newValue = Int(selected.split(separator: " ")[0]) ?? 0
                switch from {
                case "hold":
                    timersHoldLabel.text = "\(newValue) s"
                    settingsExerciseType!.timerActive = Int(newValue)
                case "rest":
                    timersRestLabel.text = "\(newValue) s"
                    settingsExerciseType!.timerRest = Int(newValue)
                default:
                    fatalError("invalid timer pick: \(from) -> \(selected)")
                }
                Settings.sharedInstance.saveExerciseTypeSettings()

            case .none:
                fatalError("missing picker type")
            }
        }
    }
}
