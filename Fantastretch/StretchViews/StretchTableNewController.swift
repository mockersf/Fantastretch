//
//  StretchTableNewController.swift
//  Fantastretch
//
//  Created by François Mockers on 29/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit
import os.log

class StretchTableNewController: UITableViewController {

    var exercises = [Exercise]()
    var knownExercises = [Exercise]()

    override func viewDidLoad() {
        super.viewDidLoad()

        DataLoader.load(exerciseLoaded: { (exercise) -> Void in
            DispatchQueue.main.async {
                if !self.knownExercises.map({ $0.id }).contains(exercise.id) {
                    self.exercises.append(exercise)
                    self.sortExercises()
                    self.tableView.reloadData()
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exercises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "StretchTableNewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StretchTableNewCell else {
            fatalError("The dequeued cell is not an instance of StretchTableNewCell.")
        }

        let stretch = exercises[indexPath.row]

        cell.nameLabel.text = stretch.name
        if let photo = stretch.photo {
            cell.photoView.image = photo
        }
        cell.targetLabel.text = stretch.muscle.rawValue
        cell.sidesLabel.text = stretch.sides.rawValue

        return cell
    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier ?? "" {

        case "ShowNewExercise":
            guard let stretchAddController = segue.destination as? StretchAddController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }

            guard let selectedStretchCell = sender as? StretchTableNewCell else {
                fatalError("Unexpected sender: \(sender ?? "missing sender")")
            }

            guard let indexPath = tableView.indexPath(for: selectedStretchCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedStretch = exercises[indexPath.row]
            stretchAddController.stretch = selectedStretch

        default:
            os_log("Unexpected Segue Identifier")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParentViewController {
            let viewControllers = navigationController?.viewControllers
            if let tableController = viewControllers?.first as? StretchTableViewController {
                tableController.loadNewStretchesAndReload()
            }
        }
    }

    // MARK: Actions
    @IBAction func unwindToNewStretchList(sender _: UIStoryboardSegue) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let newExercise = exercises[selectedIndexPath.row]
            newExercise.save()
            knownExercises.append(newExercise)
            exercises.remove(at: selectedIndexPath.row)
            tableView.reloadData()
        }
    }

    // MARK: private function
    private func sortExercises() {
        exercises = exercises.sorted(by: { (exerciseA, exerciseB) -> Bool in
            if exerciseA.muscle.rawValue == exerciseB.muscle.rawValue {
                return exerciseA.name < exerciseB.name
            } else {
                return exerciseA.muscle.rawValue < exerciseB.muscle.rawValue
            }
        })
    }
}
