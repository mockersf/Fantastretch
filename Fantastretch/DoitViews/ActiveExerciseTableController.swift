//
//  ActiveExerciseController.swift
//  Fantastretch
//
//  Created by François Mockers on 28/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class ActiveExerciseTableController: UITableViewController {

    var exercises: [ExerciseWithMetadata]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return exercises?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "DoExerciseCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DoExerciseCell else {
            fatalError("The dequeued cell is not an instance of DoExerciseCell.")
        }

        let exercise = exercises?[indexPath.row]

        if let photo = exercise?.exercise.photo {
            cell.imagePhotoView.image = photo
        }
        cell.nameLabel.text = exercise?.exercise.name
        cell.targetLabel.text = exercise?.exercise.muscle.rawValue
        cell.sidesLabel.text = exercise?.exercise.sides.rawValue
        cell.exercise = exercise

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard let doingController = segue.destination as? DoingController else {
            fatalError("zut")
        }

        doingController.exercises = exercises ?? []
    }
}
