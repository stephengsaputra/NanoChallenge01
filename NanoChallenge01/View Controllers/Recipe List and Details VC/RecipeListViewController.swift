//
//  ViewController.swift
//  NanoChallenge01
//
//  Created by Stephen Giovanni Saputra on 26/04/22.
//

import UIKit

class RecipeListViewController: UIViewController {
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    
    var rowSelected: Int?
    
    // Data Model
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recipes: [Recipes]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let height = self.view.frame.size.height * 0.2773
        let width = self.view.frame.size.width  * 0.4359
        let layout = recipeCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.recipeCollectionView.refreshControl = refreshControl
        
        fetchData()
    }
    
    @objc func refresh(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            self.recipeCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func unwindToRecipeListView(_ sender: UIStoryboardSegue) { }
    
    func fetchData() {
        
        do {
            self.recipes = try context.fetch(Recipes.fetchRequest())
            DispatchQueue.main.async {
                self.recipeCollectionView.reloadData()
            }
        } catch {
            print(error)
        }
        
        self.recipes?.sort { $0.title ?? "" < $1.title ?? "" }
    }
}

extension RecipeListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = recipeCollectionView.dequeueReusableCell(
            withReuseIdentifier: "recipeViewCell",
            for: indexPath) as! recipeViewCell
        cell.recipeImage.image = UIImage(data: recipes?[indexPath.row].image ?? Data())
        cell.recipeTitle.text = recipes?[indexPath.row].title
        
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor(
            red: 0.11,
            green: 0.11,
            blue: 0.11,
            alpha: 0.15).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        rowSelected = indexPath.row
        performSegue(withIdentifier: "toRecipeDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let selectedRow = rowSelected {
            if let destination = segue.destination as? RecipeDetailsViewController {
                destination.recipeID = recipes?[selectedRow].id ?? 0
                destination.recipeTitle = recipes?[selectedRow].title ?? ""
                destination.recipeImage = UIImage(data: recipes?[selectedRow].image ?? Data())
                destination.recipeIngredients = recipes?[selectedRow].ingredients ?? ""
                destination.recipeDirections = recipes?[selectedRow].directions ?? ""
            }
        }
        
        if segue.identifier == "toFormSegue" {
            if let vc = segue.destination as? AddRecipeViewController {
                vc.delegate = self
            }
        }
    }
}

extension RecipeListViewController: ReloadCoreDataDelegate {
    
    func reloadData() {
        fetchData()
        self.recipeCollectionView.reloadData()
    }
}
