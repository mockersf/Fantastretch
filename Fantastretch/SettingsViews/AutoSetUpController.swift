//
//  AutoSetUpController.swift
//  Fantastretch
//
//  Created by François Mockers on 06/01/2018.
//  Copyright © 2018 Vleue. All rights reserved.
//

import UIKit

class AutoSetUpController: UITableViewController {

    @IBOutlet var stretchNbLabel: UILabel!
    @IBOutlet var stretchNbStepper: UIStepper!
    @IBOutlet var stretchRepetitionsLabel: UILabel!
    @IBOutlet var stretchRepetitionStepper: UIStepper!
    @IBOutlet var exercixesNbLabel: UILabel!
    @IBOutlet var exerciseNbStepper: UIStepper!
    @IBOutlet var exercisesRepetitionsLabel: UILabel!
    @IBOutlet var exerciseRepetitionStepper: UIStepper!
    @IBOutlet var advancedAbsSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        let settings = Settings.sharedInstance
        stretchNbLabel.text = "\(settings.autoStretchNbOfExercises)"
        stretchNbStepper.value = Double(settings.autoStretchNbOfExercises)
        stretchRepetitionsLabel.text = "\(settings.autoStretchNbRepetitions)"
        stretchRepetitionStepper.value = Double(settings.autoStretchNbRepetitions)
        exercixesNbLabel.text = "\(settings.autoExerciseNbOfExercises)"
        exerciseNbStepper.value = Double(settings.autoExerciseNbOfExercises)
        exercisesRepetitionsLabel.text = "\(settings.autoExerciseNbRepetitions)"
        exerciseRepetitionStepper.value = Double(settings.autoExerciseNbRepetitions)
        advancedAbsSwitch.isOn = settings.advancedAbs
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        switch segue.identifier ?? "" {
        case "autoStretchMuscles":
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

        case "autoExerciseMuscles":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let musclePreferenceTableController = navigationController.childViewControllers[0] as? MusclePreferenceTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            let settings = Settings.sharedInstance
            musclePreferenceTableController.getMusclePreference = { settings.autoExerciseMusclePreferences[$0] ?? 1 }
            musclePreferenceTableController.updateMusclePreference = { settings.autoExerciseMusclePreferences[$0] = $1
                settings.save()
            }

        default:
            fatalError("unexpected segue \(segue.identifier ?? "no identifier")")
        }
    }

    @IBAction func advancedAbsSwitched(_: UISwitch) {
        Settings.sharedInstance.advancedAbs = advancedAbsSwitch.isOn
        Settings.sharedInstance.save()
    }

    @IBAction func unwindToAutoSettings(sender _: UIStoryboardSegue) {
    }

    @IBAction func changeNbStretches(_ sender: UIStepper) {
        stretchNbLabel.text = "\(Int(sender.value))"
        Settings.sharedInstance.autoStretchNbOfExercises = Int(sender.value)
        Settings.sharedInstance.save()
    }

    @IBAction func changeRepetitionStretch(_ sender: UIStepper) {
        stretchRepetitionsLabel.text = "\(Int(sender.value))"
        Settings.sharedInstance.autoStretchNbRepetitions = Int(sender.value)
        Settings.sharedInstance.save()
    }

    @IBAction func changeNbExercises(_ sender: UIStepper) {
        exercixesNbLabel.text = "\(Int(sender.value))"
        Settings.sharedInstance.autoExerciseNbOfExercises = Int(sender.value)
        Settings.sharedInstance.save()
    }

    @IBAction func changeRepetitionExercises(_ sender: UIStepper) {
        exercisesRepetitionsLabel.text = "\(Int(sender.value))"
        Settings.sharedInstance.autoExerciseNbRepetitions = Int(sender.value)
        Settings.sharedInstance.save()
    }
}
