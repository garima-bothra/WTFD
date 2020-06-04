//
//  RecipeTableViewController.swift
//  WTFD
//
//  Created by Garima Bothra on 03/06/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class RecipeTableViewController: UITableViewController {
//MARK: Variables
    var recipes = [Recipe]()
    var ingredients: [Ingredient]!
    var selecedRecipe: Int!
    var recipeByName = false
    var dishName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Recipes"
        if recipeByName {
            searchForRecipeByName()
        } else {
            searchForRecipesByIngredients()
        }
    }
//MARK: Search Recipe by name
    func searchForRecipesByIngredients() {
           let provider = MoyaProvider<SpoonacularAPI>()
        provider.request(.findRecipesByIngredients(ingredients: ingredients)) {
                       switch $0 {
                       case .success(let response):
                           do {
                               // Only allow successful HTTP codes
                               _ = try response.filterSuccessfulStatusCodes()

                               // Parse data as JSON
                               let json = try JSON(data: response.data)
                               // Parse each recipe's JSON
                                self.recipes = json.arrayValue.map({ Recipe(json: $0) })
                                self.tableView.reloadData()
                           } catch {
                               print(error.localizedDescription)
                           }
                       case .failure(let error):
                        let alert = UIAlertController(title: "Failure", message: "Please check your internet connection. Could not load your fav recipes :(", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                           print(error.localizedDescription)
                       }
                   }
       }
//MARK: Search Recipe by name
    func searchForRecipeByName() {
        let provider = MoyaProvider<SpoonacularAPI>()
        provider.request(.getRecipesByName(dishName: dishName)) {
            switch $0 {
            case .success(let response):
                do {
                    // Only allow successful HTTP codes
                    _ = try response.filterSuccessfulStatusCodes()

                    // Parse data as JSON
                    let total = try JSON(data: response.data)
                    let json = total["results"]
                    // Parse each recipe's JSON
                     self.recipes = json.arrayValue.map({ Recipe(json: $0) })
                     self.tableView.reloadData()
                } catch {
                    let alert = UIAlertController(title: "Oops! Try again.", message: "There seems be an error with the server. Try again in a while.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(error.localizedDescription)
                    print(error.localizedDescription)
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Failed to load recipes", message: "Please check your internet connection.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipe", for: indexPath) as! RecipeTableViewCell
        cell.recipeImage.image = recipes[indexPath.row].image
        cell.recipeNameLabel.text = recipes[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selecedRecipe = indexPath.row
        self.performSegue(withIdentifier: "getRecipeSteps", sender: Any.self)
    }
//MARK: Pass data to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "getRecipeSteps"){
            let stepsVC = segue.destination as! RecipeStepsViewController
            stepsVC.recipe = recipes[selecedRecipe]
        }
    }

}
