//
//  MusclePreferenceTableController.swift
//  Fantastretch
//
//  Created by François Mockers on 28/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class MusclePreferenceTableController: UITableViewController {
    var muscles: [Muscle]?

    var updateMusclePreference: ((Muscle, Int) -> Void)?
    var getMusclePreference: ((Muscle) -> Int)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        muscles = Muscle.getAllMuscles(settings: Settings())
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
        return muscles?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "MusclePreferenceCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MusclePreferenceCell else {
            fatalError("The dequeued cell is not an instance of MusclePreferenceCell.")
        }

        let muscle = muscles![indexPath.row]
        let preference = getMusclePreference!(muscle)

        cell.muscleLabel.text = muscle.rawValue
        cell.scoreLabel.text = "\(preference)"
        cell.scoreStepper.value = Double(preference)
        cell.updateMusclePreference = { (newScore: Int) -> Void in self.updateMusclePreference!(muscle, newScore) }

        return cell
    }

    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

     // Configure the cell...

     return cell
     }
     */

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
