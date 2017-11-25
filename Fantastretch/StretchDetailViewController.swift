//
//  StretchDetailTableController.swift
//  Fantastretch
//
//  Created by François Mockers on 25/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class StretchViewController: UITableViewController {

    var stretch: Stretch?

    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var sidesLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoCell: UIStackView!
    @IBOutlet weak var ratingControl: RatingControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up views with existing Stretch.
        if let stretch = stretch {
            navigationItem.title = stretch.name
            targetLabel.text = stretch.target.rawValue
            sidesLabel.text = stretch.sides.rawValue
            if let photo = stretch.photo {
                photoImageView.image = photo
            } else {
                photoCell.isHidden = true
            }
            ratingControl.rating = stretch.rating
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParentViewController {
            stretch?.rating = ratingControl.rating
            let viewControllers = navigationController?.viewControllers
            if let tableController = viewControllers?.first as? StretchTableViewController {
                if let selectedIndexPath = tableController.tableView.indexPathForSelectedRow {
                    // Update an existing stretch.
                    tableController.stretches[selectedIndexPath.row] = stretch!
                    tableController.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    tableController.saveStretches()
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
            stretchEditController.stretch = stretch

        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "missing segue")")
        }
    }
}
