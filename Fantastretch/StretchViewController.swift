//
//  ViewController.swift
//  Fantastretch
//
//  Created by François Mockers on 19/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit
import os.log

class StretchViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate /* ,  UIPickerViewDataSource, UIPickerViewDelegate */ {

    /*    // MARK: UIPickerViewDataSource, UIPickerViewDelegate
     func numberOfComponents(in _: UIPickerView) -> Int {
     return 1
     }

     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
     if pickerView == sidePicker {
     return Side.allValues.count
     } else if pickerView == targetPicker {
     return Target.allValues.count
     }
     return 0
     }

     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
     if pickerView == sidePicker {
     return Side.allValues.map { (side) -> String in side.rawValue }[row]
     } else if pickerView == targetPicker {
     return Target.allValues.map { (target) -> String in target.rawValue }[row]
     }
     return ""
     }*/

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    /*    @IBOutlet weak var targetLabel: UILabel!
     @IBOutlet weak var sidesLabel: UILabel!*/
    /*
     This value is either passed by `StretchTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new stretch.
     */
    var stretch: Stretch?
    var choseImage = false

    override func viewDidLoad() {
        super.viewDidLoad()

        /*        sidePicker.dataSource = self
         sidePicker.delegate = self
         targetPicker.dataSource = self
         targetPicker.delegate = self*/

        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        // sidePicker.dataSource = Side.allValues.map { (side) -> String in side.rawValue }

        /*        targetLabel.text = "please choose one"
         targetLabel.textColor = UIColor.darkGray
         sidesLabel.text = "please choose one"
         sidesLabel.textColor = UIColor.gray*/

        // Set up views if editing an existing Stretch.
        if let stretch = stretch {
            navigationItem.title = stretch.name
            nameTextField.text = stretch.name
            photoImageView.image = stretch.photo
            /*            targetLabel.text = stretch.target.rawValue
             targetLabel.textColor = UIColor.darkText
             sidesLabel.text = stretch.sides.rawValue
             sidesLabel.textColor = UIColor.darkText*/

            /*            sidePicker.selectRow(Side.allValues.index(of: stretch.sides)!, inComponent: 0, animated: false)
             targetPicker.selectRow(Target.allValues.index(of: stretch.target)!, inComponent: 0, animated: false)*/
        }

        // Enable the Save button only if the text field has a valid Stretch name.
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    func textFieldDidBeginEditing(_: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }

    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        choseImage = true

        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    // MARK: Navigation
    // This method lets you configure a view controller before it's presented.
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
        let rating = 0
        let sides = Side.Center // Side.allValues[sidePicker.selectedRow(inComponent: 0)]
        let target = Target.Legs // Target.allValues[targetPicker.selectedRow(inComponent: 0)]

        // Set the stretch to be passed to StretchTableViewController after the unwind segue.
        stretch = Stretch(name: name, description: description, photo: choseImage ? photo : nil, rating: rating, sides: sides, target: target)
    }

    @IBAction func cancel(_: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddStretchMode = presentingViewController is UITabBarController

        if isPresentingInAddStretchMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popToRootViewController(animated: true)
        } else {
            fatalError("The StretchViewController is not inside a navigation controller.")
        }
    }

    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_: UITapGestureRecognizer) {

        // Hide the keyboard.
        nameTextField.resignFirstResponder()

        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()

        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary

        // Make sure ViewController is notified when the user picks an image.
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
