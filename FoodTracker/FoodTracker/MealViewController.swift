//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log
import Parse

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
         This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
         or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            
            var pfImage = meal["pfFile"] as? PFFile
            
            pfImage?.getDataInBackground( { (result, error) in
                OperationQueue.main.addOperation {
                    self.photoImageView.image = UIImage(data: result!)
                }
            })
            
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let pfFile = PFFile(data: UIImageJPEGRepresentation(photoImageView.image!, 0.8)!)
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        
        meal = Meal(name: name, pfFile: pfFile, rating: rating)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
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
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        saveMeals()
        print("save button tapped")
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func saveMeals() {
        
        
        
        
        
//        meal.name = nameTextField.text!
//        meal.rating = ratingControl.rating
//        meal.pfFile = photoImageView.image
        let pfFile = PFFile(data: UIImageJPEGRepresentation(photoImageView.image!, 0.8)!)
//        meal["Photo"] = pfFile
        let meal = Meal(name: nameTextField.text!, pfFile: pfFile, rating: ratingControl.rating)
        meals.append(meal!)
        meal?.saveInBackground()
        
        
        
//        guard let name = meal?.name,
//            let rating = meal?.rating,
//            let photo = meal?.photo,
//            let pfFile = meal?.pfFile else { return }
//
//        do {
//            guard let image = meal?.photo else { return }
//            guard let data = UIImageJPEGRepresentation(image, 0.8) else { return }
//            //let path = Bundle.main.path(forResource: data, ofType: "jpg")
//            let file = PFFile(data: data)
//            var mealAttributes = Meal(name: nameTextField.text ?? "",
//                                      photo: photoImageView.image,
//                                      pfFile: file, //PFFile(data: UIImageJPEGRepresentation(photoImageView.image!, 0.8)!),
//                                      rating: ratingControl.rating)
//
//            mealAttributes?.saveInBackground {
//                (success: Bool, error: Error?) in
//                if success {
//                    print(#line, success)
//                } else {
//                    print(#line, error!)
//                    return
//                }
//            }
//        } catch {
//            print(#line, error.localizedDescription)
//        }
    }
}

