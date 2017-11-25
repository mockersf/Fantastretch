//
//  StretchDetailTableController.swift
//  Fantastretch
//
//  Created by François Mockers on 25/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit
import os.log

class StretchEditController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var stretch: Stretch?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var sidesLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self

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
            targetLabel.text = "Choose one"
            targetLabel.textColor = UIColor.gray
            sidesLabel.text = "Choose one"
            sidesLabel.textColor = UIColor.gray
            updateSaveButtonState()
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
        let photo = photoImageView.image != UIImage(named: "noPhoto") ? photoImageView.image : nil
        let sides = Side.allValues.first(where: { (side) -> Bool in side.rawValue == sidesLabel.text }) ?? Side.Center
        let target = Target.allValues.first(where: { (target) -> Bool in target.rawValue == targetLabel.text }) ?? Target.Legs

        stretch = Stretch(name: name, description: description, photo: photo, rating: stretch?.rating ?? 0, sides: sides, target: target)
    }

    @IBAction func cancel(_: UIBarButtonItem) {
        let isPresentingInAddStretchMode = presentingViewController is UITabBarController

        if isPresentingInAddStretchMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
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

        dismiss(animated: true, completion: nil)
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_: UITextField) {
        updateSaveButtonState()
    }

    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    // MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
