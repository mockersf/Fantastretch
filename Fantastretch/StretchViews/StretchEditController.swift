//
//  StretchDetailTableController.swift
//  Fantastretch
//
//  Created by François Mockers on 25/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import os.log
import UIKit

class StretchEditController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    var exercise: Exercise?
    let placeholderGray = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1)

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var sidesLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var descriptionText: UITextView!

    var descriptionTextEmpty = true

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        descriptionText.delegate = self

        // Set up views with existing Exercise.
        if let exercise = exercise {
            navigationItem.title = "Edit Exercise"

            nameTextField.text = exercise.name
            targetLabel.text = exercise.muscle.rawValue
            targetLabel.textColor = UIColor.gray
            sidesLabel.text = exercise.sides.rawValue
            sidesLabel.textColor = UIColor.gray
            typeLabel.text = exercise.type.rawValue
            typeLabel.textColor = UIColor.gray
            if let photo = exercise.photo {
                photoImageView.image = photo
            }
            descriptionText.text = exercise.explanation
            if exercise.explanation != "" {
                descriptionTextEmpty = false
            }
        } else {
            navigationItem.title = "New Exercise"
            targetLabel.text = "Choose one"
            targetLabel.textColor = placeholderGray
            sidesLabel.text = "Choose one"
            sidesLabel.textColor = placeholderGray
            typeLabel.text = "Choose one"
            typeLabel.textColor = placeholderGray
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
            pickerTableController.allValues = Muscle.allCases.map { $0.rawValue }
            pickerTableController.type = PickTarget.Muscle
            pickerTableController.current = targetLabel.text

        case "PickSides":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let pickerTableController = navigationController.childViewControllers[0] as? PickerTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            pickerTableController.allValues = Repeat.allCases.map { $0.rawValue }
            pickerTableController.type = PickTarget.Repeat
            pickerTableController.current = sidesLabel.text

        case "PickType":
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            guard let pickerTableController = navigationController.childViewControllers[0] as? PickerTableController else {
                fatalError("Unexpected controller: \(segue.destination)")
            }
            pickerTableController.allValues = ExerciseType.allCases.map { $0.rawValue }
            pickerTableController.type = PickTarget.ExerciseType
            pickerTableController.current = typeLabel.text

        case "SaveItem":
            let name = nameTextField.text ?? ""
            let description = descriptionTextEmpty ? "" : (descriptionText.text ?? "")
            let photo = photoImageView.image != UIImage(named: "noPhoto") ? photoImageView.image : nil
            let sides = Repeat.allCases.first(where: { (side) -> Bool in side.rawValue == sidesLabel.text }) ?? Repeat.defaultCase
            let muscle = Muscle.allCases.first(where: { (muscle) -> Bool in muscle.rawValue == targetLabel.text }) ?? Muscle.defaultCase
            let type = ExerciseType(rawValue: typeLabel.text ?? "") ?? ExerciseType.defaultCase

            exercise = Exercise(name: name, explanation: description, photo: photo, rating: exercise?.rating ?? 0, sides: sides, muscle: muscle, type: type, id: exercise?.id)

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
            switch pickerTableController.type {
            case .some(PickTarget.Repeat):
                sidesLabel.text = Repeat.allCases.first(where: { $0.rawValue == selected })?.rawValue
                sidesLabel.textColor = UIColor.gray
                updateSaveButtonState()

            case .some(PickTarget.Muscle):
                targetLabel.text = Muscle.allCases.first(where: { $0.rawValue == selected })?.rawValue
                targetLabel.textColor = UIColor.gray
                updateSaveButtonState()

            case .some(PickTarget.ExerciseType):
                typeLabel.text = ExerciseType.allCases.first(where: { $0.rawValue == selected })?.rawValue
                typeLabel.textColor = UIColor.gray
                updateSaveButtonState()

            case .some(PickTarget.Timer):
                fatalError("PickTarget.Timer should not happen here")

            case .none:
                fatalError("missing picker type")
            }
        }
    }

    // MARK: Private Methods

    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        let choseSides = Repeat.allCases.first(where: { $0.rawValue == sidesLabel.text })
        let choseTarget = Muscle.allCases.first(where: { $0.rawValue == targetLabel.text })
        saveButton.isEnabled = !text.isEmpty && choseSides != nil && choseTarget != nil
    }

    private func setPlaceholderDescription() {
        descriptionTextEmpty = true
        descriptionText.text = "Set a description for this stretch"
        descriptionText.textColor = placeholderGray
    }
}
