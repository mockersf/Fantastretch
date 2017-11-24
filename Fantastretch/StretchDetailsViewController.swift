//
//  StretchDetailsViewController.swift
//  Fantastretch
//
//  Created by François Mockers on 22/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class StretchDetailsViewController: UIViewController {

    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var sidesLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    /*
     This value is passed by `StretchTableViewController` in `prepare(for:sender:)`
     */
    var stretch: Stretch?

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
                photoImageView.isHidden = true
            }
            ratingControl.rating = stretch.rating
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier ?? "" {

        case "EditItem":
            guard let stretchDetailViewController = segue.destination as? StretchViewController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }

            stretchDetailViewController.stretch = stretch

        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "missing segue")")
        }
    }

    @IBAction func backToList(_: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
