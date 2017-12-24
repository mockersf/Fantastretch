//
//  PickerTableController.swift
//  Fantastretch
//
//  Created by François Mockers on 25/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

enum PickTarget: String {
    case Muscle
    case Repeat
    case Timer
}

class PickerTableController: UITableViewController {
    var allValues: [String]?
    var selected: String?
    var type: PickTarget?
    var extraInfo: String?
    var current: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Choose " + (type?.rawValue.capitalized ?? "")
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
        return (allValues ?? []).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "PickerTableCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PickerTableCell else {
            fatalError("The dequeued cell is not an instance of PickerTableCell.")
        }

        let value = allValues?[indexPath.row]

        if value == current {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        cell.label.text = value

        return cell
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        selected = (sender as? PickerTableCell)?.textLabel?.text
    }
}
