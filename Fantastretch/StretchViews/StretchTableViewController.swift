//
//  StretchTableViewController.swift
//  Fantastretch
//
//  Created by François Mockers on 19/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import CoreData
import os.log
import UIKit

class StretchTableViewController: UITableViewController {

    // MARK: Properties

    var exercises = [ExerciseType: [Exercise]]()
    var fixedSet = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if !fixedSet {
            // Use the edit button item provided by the table view controller.
            navigationItem.leftBarButtonItem = editButtonItem
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !fixedSet {
            loadNewExercisesAndReload()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return exercises.keys.count
    }

    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return exerciseTypeForSection(section).rawValue
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises[exerciseTypeForSection(section)]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "StretchTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StretchTableViewCell else {
            fatalError("The dequeued cell is not an instance of StretchTableViewCell.")
        }

        let exercise = exercises[exerciseTypeForSection(indexPath.section)]![indexPath.row]

        cell.nameLabel.text = exercise.name
        cell.photoImageView.image = exercise.photo
        cell.ratingControl.rating = exercise.rating
        cell.targetLabel.text = exercise.muscle.rawValue
        cell.sidesLabel.text = exercise.sides.rawValue
        cell.ratingControl.onUpdate = { (rating: Int) -> Void in
            exercise.rating = rating
            exercise.update()
        }

        return cell
    }

    override func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return !fixedSet
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            exercises[exerciseTypeForSection(indexPath.section)]![indexPath.row].delete()
            exercises[exerciseTypeForSection(indexPath.section)]!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier ?? "" {

        case "AddItem":
            os_log("Adding a new stretch.", log: OSLog.default, type: .debug)

        case "ListNewExercises":
            guard let stretchTableNewController = segue.destination as? StretchTableNewController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }

            stretchTableNewController.knownExercises = exercises.flatMap({ $1 })

        case "ShowItem":
            guard let stretchDetailViewController = segue.destination as? StretchViewController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }

            guard let selectedStretchCell = sender as? StretchTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "missing sender")")
            }

            guard let indexPath = tableView.indexPath(for: selectedStretchCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedExercise = exercises[exerciseTypeForSection(indexPath.section)]![indexPath.row]
            stretchDetailViewController.stretch = selectedExercise

        case "unwind":
            ()

        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "missing segue")")
        }
    }

    // MARK: Actions

    @IBAction func unwindToStretchList(sender: UIStoryboardSegue) {
        if let sourceEditController = sender.source as? StretchEditController, let exercise = sourceEditController.stretch {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing stretch.
                exercises[exerciseTypeForSection(selectedIndexPath.section)]![selectedIndexPath.row] = exercise
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                exercise.update()
            } else {
                // Add a new stretch.
                let newIndexPath = IndexPath(row: exercises.count, section: Array(exercises.keys).index(of: exercise.type) ?? Array(exercises.keys).count)
                exercises.merge([exercise.type: [exercise]], uniquingKeysWith: { $0 + $1 })
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                exercise.save()
            }
            sortExercises()
            tableView.reloadData()
        }
    }

    // MARK: private functions

    private func exerciseTypeForSection(_ section: Int) -> ExerciseType {
        return Array(exercises.keys).sorted(by: { $0.rawValue < $1.rawValue })[section]
    }

    private func sortExercises() {
        for (exerciseType, exercisesOfType) in exercises {
            exercises[exerciseType] = exercisesOfType.sorted(by: { (stretchA, stretchB) -> Bool in
                if stretchA.muscle.rawValue == stretchB.muscle.rawValue {
                    return stretchA.name < stretchB.name
                } else {
                    return stretchA.muscle.rawValue < stretchB.muscle.rawValue
                }
            })
        }
    }

    public func loadNewExercisesAndReload() {
        exercises = Exercise.load()?.reduce([:], { acc, exercise in
            acc?.merging([exercise.type: [exercise]], uniquingKeysWith: { $0 + $1 })
        }) ?? [:]
        sortExercises()

        tableView.reloadData()
    }
}
