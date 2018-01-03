//
//  StretchDetailTableController.swift
//  Fantastretch
//
//  Created by François Mockers on 25/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class StretchViewController: UITableViewController {

    var exercise: Exercise?
    var exerciseSettings: ExerciseSettings?
    var settings: Settings?

    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var sidesLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoCell: UIStackView!
    @IBOutlet var ratingControl: RatingControl!
    @IBOutlet var DescriptionText: UITextView!
    @IBOutlet var statsLastRunLabel: UILabel!
    @IBOutlet var statsTotalRunLabel: UILabel!
    @IBOutlet var currentHoldTImer: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        settings = Settings.sharedInstance
        // Set up views with existing Stretch.
        if let exercise = exercise {
            exerciseSettings = exercise.getSettings()
            navigationItem.title = exercise.name
            targetLabel.text = exercise.muscle.rawValue
            sidesLabel.text = exercise.sides.rawValue
            if let photo = exercise.photo {
                photoImageView.image = photo
            }
            DescriptionText.text = exercise.explanation
            ratingControl.rating = exercise.rating
            statsLastRunLabel.text = (ExerciseHistory.loadLatest(exercise: exercise)?.date)
                .map({ DateFormatter.localizedString(from: $0, dateStyle: .short, timeStyle: .short) }) ?? "Never"
            statsTotalRunLabel.text = "\(ExerciseHistory.loadAll(exercise: exercise).count)"
            currentHoldTImer.text = currentHold()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParentViewController {
            exercise?.rating = ratingControl.rating
            let viewControllers = navigationController?.viewControllers
            if let tableController = viewControllers?.first as? StretchTableViewController {
                if let selectedIndexPath = tableController.tableView.indexPathForSelectedRow {
                    // Update an existing stretch.
                    tableController.exercises[exercise!.type]![selectedIndexPath.row] = exercise!
                    tableController.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    exercise?.update()
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier ?? "" {

        case "EditItem":
            guard let stretchEditController = segue.destination as? StretchEditController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            stretchEditController.exercise = exercise

        case "PickTimer":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let pickerTableController = navigationController.childViewControllers[0] as? PickerTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            pickerTableController.allValues = ["Default (\(settings?.timerHold ?? 15) seconds)"] + Array(1 ... 12).flatMap({ "\($0 * 15) seconds" })
            pickerTableController.type = PickTarget.Timer
            pickerTableController.extraInfo = "hold"
            pickerTableController.current = currentHold()

        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "missing segue")")
        }
    }

    // MARK: private functions

    private func currentHold() -> String {
        return exerciseSettings?.duration.map({ "\($0) seconds" }) ?? "Default (\(settings?.timerHold ?? 15) seconds)"
    }

    // MARK: Actions

    @IBAction func unwindToViewExercise(sender: UIStoryboardSegue) {
        if let pickerTableController = sender.source as? PickerTableController, let selected = pickerTableController.selected {
            switch pickerTableController.type {
            case .some(PickTarget.Repeat):
                fatalError("PickTarget.Repeat should not happen here")

            case .some(PickTarget.Muscle):
                fatalError("PickTarget.Muscle should not happen here")

            case .some(PickTarget.ExerciseType):
                fatalError("PickTarget.ExerciseType should not happen here")

            case .some(PickTarget.Timer):
                guard let _ = pickerTableController.extraInfo else {
                    fatalError("missing info from wich timer we are choosing a value")
                }
                if let newValue = Int(selected.split(separator: " ")[0]) {
                    exerciseSettings?.duration = newValue
                } else {
                    exerciseSettings?.duration = nil
                }
                exerciseSettings?.save()
                currentHoldTImer.text = currentHold()

            case .none:
                fatalError("missing picker type")
            }
        }
    }
}
