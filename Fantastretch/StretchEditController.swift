//
//  StretchDetailTableController.swift
//  Fantastretch
//
//  Created by François Mockers on 25/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit
import os.log

class StretchEditController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var stretch: Stretch?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var sidesLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var choseImage: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up views with existing Stretch.
        if let stretch = stretch {
            navigationItem.title = "Edit Stretch"

            nameTextField.text = stretch.name
            targetLabel.text = stretch.target.rawValue
            sidesLabel.text = stretch.sides.rawValue
            if let photo = stretch.photo {
                photoImageView.image = photo
            }
        } else {
            navigationItem.title = "New Stretch"

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }

        let name = nameTextField.text ?? ""
        let description = ""
        let photo = photoImageView.image
        let sides = Side.allValues.first(where: { (side) -> Bool in side.rawValue == sidesLabel.text }) ?? Side.Center
        let target = Target.allValues.first(where: { (target) -> Bool in target.rawValue == targetLabel.text }) ?? Target.Legs

        stretch = Stretch(name: name, description: description, photo: choseImage ? photo : nil, rating: stretch?.rating ?? 0, sides: sides, target: target)
    }

    @IBAction func cancel(_: UIBarButtonItem) {
        if let owningNavigationController = navigationController {
            owningNavigationController.popToRootViewController(animated: true)
        } else {
            fatalError("The StretchViewController is not inside a navigation controller.")
        }
    }

    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        photoImageView.image = selectedImage
        choseImage = true

        dismiss(animated: true, completion: nil)
    }

    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}
