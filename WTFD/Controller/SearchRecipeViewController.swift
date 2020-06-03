//
//  SearchRecipeViewController.swift
//  WTFD
//
//  Created by Garima Bothra on 03/06/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit
import CoreData

class SearchRecipeViewController: UIViewController {

    var ingredients = [Ingredient]()
    var dataController: DataController!
    @IBOutlet weak var ingredientsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataController)
        // Do any additional setup after loading the view.
    }

    func presentNewIngredientAlert() {
        let alert = UIAlertController(title: "New Ingredient", message: "Enter a name for this ingredient", preferredStyle: .alert)

        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.addIngredient(name: name)
            }
        }
        saveAction.isEnabled = false

        // Add a text field
        alert.addTextField { textField in
            textField.placeholder = "Name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }

    func addIngredient(name: String) {
//        var ingredient = Ingredient()
//        ingredient.name = name
//        ingredients.append(ingredient)
        ingredientsTableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        presentNewIngredientAlert()
    }
    @IBAction func searchRecipeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToRecipe", sender: Any.self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToRecipe"){
            let recipeVC = segue.destination as! RecipeTableViewController
            recipeVC.ingredients = ingredients
        }
    }

}

extension SearchRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         //let ingredient = fetchedResultsController.object(at: indexPath)
               let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
               // Configure cell
        cell.ingredientLabel.text = ingredients[indexPath.row].name
               return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            // remove the item from the data model
            ingredients.remove(at: indexPath.row)

            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
}
