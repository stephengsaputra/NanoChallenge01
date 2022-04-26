//
//  FormTableViewController.swift
//  NanoChallenge01
//
//  Created by Stephen Giovanni Saputra on 26/04/22.
//

import UIKit

class FormTableViewController: UITableViewController {
    
    @IBOutlet weak var recipeFormTableView: UITableView!
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    @IBOutlet weak var recipeIngredientsTextView: UITextView!
    @IBOutlet weak var recipeIngredientsTextViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var recipeDirectionsTextView: UITextView!
    
    var recipeTitle = ""
    var image: UIImage?
    var ingredients = ""
    var directions = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        recipeNameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        recipeNameTextField.delegate = self
        
        recipeImageView.layer.borderWidth = 1
        recipeImageView.layer.borderColor = UIColor(named: "TF")?.cgColor
        recipeImageView.layer.cornerRadius = 5
        recipeImageView.image = UIImage(named: "emptyState")
        
        recipeIngredientsTextView.layer.borderWidth = 1
        recipeIngredientsTextView.layer.borderColor = UIColor(named: "TF")?.cgColor
        recipeIngredientsTextView.layer.cornerRadius = 5
        self.recipeIngredientsTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone1(sender:)))
        
        recipeDirectionsTextView.layer.borderWidth = 1
        recipeDirectionsTextView.layer.borderColor = UIColor(named: "TF")?.cgColor
        recipeDirectionsTextView.layer.cornerRadius = 5
        self.recipeDirectionsTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone2(sender:)))
    }
    
    @objc func tapDone1(sender: Any) {
        
        self.view.endEditing(true)
        
        ingredients = recipeIngredientsTextView.text ?? ""
        print(ingredients)
    }
    
    @objc func tapDone2(sender: Any) {
        
        self.view.endEditing(true)
        print("directions")
    }
    
    // MARK: - Source Image
    @IBAction func changeImageTapped(_ sender: Any) {
        showAlert()
    }
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Select Image", message: "Where do you want to choose your recipe photo?", preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { action in
            self.showImagePicker(selectedSource: .camera)
        }
        
        let galleryButton = UIAlertAction(title: "Photo Gallery", style: .default) { action in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cameraButton)
        alert.addAction(galleryButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension FormTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            print("Error")
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            recipeImageView.image = selectedImage
            image = recipeImageView.image
        } else {
            print("Image not found")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension FormTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recipeNameTextField.resignFirstResponder()
        
        recipeTitle = recipeNameTextField.text ?? ""
        print(recipeTitle)
        
        return true
    }
}