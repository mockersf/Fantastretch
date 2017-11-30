//
//  StretchAddController.swift
//  Fantastretch
//
//  Created by François Mockers on 29/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class StretchAddController: UITableViewController {

    var stretch: Exercise?

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var sidesLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up views with existing Stretch.
        if let stretch = stretch {
            navigationItem.title = stretch.name
            targetLabel.text = stretch.muscle.rawValue
            sidesLabel.text = stretch.sides.rawValue
            if let photo = stretch.photo {
                photoImageView.image = photo
            }
            descriptionText.text = stretch.explanation
        }

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
