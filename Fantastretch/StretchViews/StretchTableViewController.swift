//
//  StretchTableViewController.swift
//  Fantastretch
//
//  Created by François Mockers on 19/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit
import os.log
import CoreData

class StretchTableViewController: UITableViewController {

    // MARK: Properties
    var stretches = [Stretch]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

        stretches = Stretch.load() ?? []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return stretches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "StretchTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StretchTableViewCell else {
            fatalError("The dequeued cell is not an instance of StretchTableViewCell.")
        }

        let stretch = stretches[indexPath.row]

        cell.nameLabel.text = stretch.name
        cell.photoImageView.image = stretch.photo
        cell.ratingControl.rating = stretch.rating
        cell.targetLabel.text = stretch.target.rawValue
        cell.sidesLabel.text = stretch.sides.rawValue

        return cell
    }

    override func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stretches[indexPath.row].delete()
            stretches.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier ?? "" {

        case "AddItem":
            os_log("Adding a new stretch.", log: OSLog.default, type: .debug)

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

            let selectedStretch = stretches[indexPath.row]
            stretchDetailViewController.stretch = selectedStretch

        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "missing segue")")
        }
    }

    // MARK: Actions
    @IBAction func unwindToStretchList(sender: UIStoryboardSegue) {
        if let sourceEditController = sender.source as? StretchEditController, let stretch = sourceEditController.stretch {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing stretch.
                stretches[selectedIndexPath.row] = stretch
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                stretch.update()
            } else {
                // Add a new stretch.
                let newIndexPath = IndexPath(row: stretches.count, section: 0)
                stretches.append(stretch)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                stretch.save()
            }
        }
    }
}