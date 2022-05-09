//
//  RecipeDetailsViewController.swift
//  NanoChallenge01
//
//  Created by Stephen Giovanni Saputra on 26/04/22.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeIngredientsTextView: UITextView!
    @IBOutlet weak var recipeDirectionsTextView: UITextView!
    
    var recipeID: Int64 = 0
    var recipeTitle: String = ""
    var recipeImage: UIImage!
    var recipeIngredients: String = ""
    var recipeDirections: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        recipeTitleLabel.text = recipeTitle
        recipeImageView.image = recipeImage
        recipeIngredientsTextView.text = recipeIngredients
        recipeDirectionsTextView.text = recipeDirections
        
        print(recipeID)
        
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toEditRecipeView))
        self.navigationItem.rightBarButtonItem  = editBarButtonItem
    }
    
    @IBAction func unwindToRecipeDetails(_ sender: UIStoryboardSegue) { }
    
    @objc func toEditRecipeView() {
        performSegue(withIdentifier: "toEditRecipe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEditRecipe" {
            if let vc = segue.destination as? EditRecipeViewController {
                vc.recipeID = self.recipeID
                vc.recipeTitle = self.recipeTitle
                vc.recipeImage = self.recipeImage
                vc.ingredients = self.recipeIngredients
                vc.directions = self.recipeDirections
                vc.delegate = self
            }
        }
    }
}

extension RecipeDetailsViewController: ReloadRecipeDetailDelegate {
    
    func reloadData(title: String, ingredients: String, directions: String, image: UIImage) {
        
        self.recipeTitleLabel.text = title
        self.recipeImageView.image = image
        self.recipeIngredientsTextView.text = ingredients
        self.recipeDirectionsTextView.text = directions
    }
}
