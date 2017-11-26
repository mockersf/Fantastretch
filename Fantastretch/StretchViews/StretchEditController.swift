//
//  StretchDetailTableController.swift
//  Fantastretch
//
//  Created by François Mockers on 25/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit
import os.log

class StretchEditController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    var stretch: Stretch?
    let placeholderGray = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1)

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var sidesLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var descriptionText: UITextView!

    var descriptionTextEmpty = true

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        descriptionText.delegate = self

        // Set up views with existing Stretch.
        if let stretch = stretch {
            navigationItem.title = "Edit Stretch"

            nameTextField.text = stretch.name
            targetLabel.text = stretch.target.rawValue
            sidesLabel.text = stretch.sides.rawValue
            if let photo = stretch.photo {
                photoImageView.image = photo
            }
            descriptionText.text = stretch.stretch_description
            if stretch.stretch_description != "" {
                descriptionTextEmpty = false
            }
        } else {
            navigationItem.title = "New Stretch"
            targetLabel.text = "Choose one"
            targetLabel.textColor = placeholderGray
            sidesLabel.text = "Choose one"
            sidesLabel.textColor = placeholderGray
            setPlaceholderDescription()
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

        switch segue.identifier ?? "" {

        case "PickTarget":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let pickerTableController = navigationController.childViewControllers[0] as? PickerTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            pickerTableController.allValues = Target.allValues.map { $0.rawValue }.sorted()
            pickerTableController.type = "target"

        case "PickSides":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let pickerTableController = navigationController.childViewControllers[0] as? PickerTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            pickerTableController.allValues = Side.allValues.map { $0.rawValue }
            pickerTableController.type = "sides"

        case "SaveItem":
            let name = nameTextField.text ?? ""
            let description = descriptionTextEmpty ? "" : (descriptionText.text ?? "")
            let photo = photoImageView.image != UIImage(named: "noPhoto") ? photoImageView.image : nil
            let sides = Side.allValues.first(where: { (side) -> Bool in side.rawValue == sidesLabel.text }) ?? Side.Center
            let target = Target.allValues.first(where: { (target) -> Bool in target.rawValue == targetLabel.text }) ?? Target.Glutes

            stretch = Stretch(name: name, description: description, photo: photo, rating: stretch?.rating ?? 0, sides: sides, target: target, id: stretch?.id)

        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "missing segue")")
        }
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
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

    // MARK: UITextViewDelegate
    func textViewShouldBeginEditing(_: UITextView) -> Bool {
        if descriptionTextEmpty {
            descriptionText.text = ""
            descriptionText.textColor = UIColor.darkText
        }
        return true
    }

    func textViewDidEndEditing(_: UITextView) {
        if descriptionText.text == "" {
            setPlaceholderDescription()
        } else {
            descriptionTextEmpty = false
        }
    }

    func textViewDidChange(_: UITextView) {
        descriptionTextEmpty = descriptionText.text == ""
    }

    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    // MARK: Actions
    @IBAction func unwindToEdit(sender: UIStoryboardSegue) {
        if let pickerTableController = sender.source as? PickerTableController, let selected = pickerTableController.selected {
            switch pickerTableController.type ?? "" {
            case "sides":
                sidesLabel.text = Side.allValues.first(where: { $0.rawValue == selected })?.rawValue
                sidesLabel.textColor = UIColor.darkText
                updateSaveButtonState()

            case "target":
                targetLabel.text = Target.allValues.first(where: { $0.rawValue == selected })?.rawValue
                targetLabel.textColor = UIColor.darkText
                updateSaveButtonState()

            default:
                fatalError("unknown picker type: \(pickerTableController.type ?? "missing type")")
            }
        }
    }

    // MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        let choseSides = Side.allValues.first(where: { $0.rawValue == sidesLabel.text })
        let choseTarget = Target.allValues.first(where: { $0.rawValue == targetLabel.text })
        saveButton.isEnabled = !text.isEmpty && choseSides != nil && choseTarget != nil
    }

    private func setPlaceholderDescription() {
        descriptionTextEmpty = true
        descriptionText.text = "Set a description for this stretch"
        descriptionText.textColor = placeholderGray
    }
}
