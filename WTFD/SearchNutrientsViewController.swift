//
//  SearchNutrientsViewController.swift
//  WTFD
//
//  Created by Garima Bothra on 03/06/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit

class SearchNutrientsViewController: UIViewController {

    var ingredientsWithQuantities = ["3 apples"]

    @IBOutlet weak var ingredientWithQuantity: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        presentNewIngredientAlert()
    }

    func presentNewIngredientAlert() {
        let alert = UIAlertController(title: "New Ingredient", message: "Enter a name and quantity for this ingredient", preferredStyle: .alert)

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
        ingredientsWithQuantities.append(name)
        ingredientWithQuantity.reloadData()
    }
}

extension SearchNutrientsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsWithQuantities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         //let ingredient = fetchedResultsController.object(at: indexPath)
               let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientQuantityCell", for: indexPath) as! IngredientTableViewCell
               // Configure cell
        cell.ingredientLabel.text = ingredientsWithQuantities[indexPath.row]
               return cell
    }
}
