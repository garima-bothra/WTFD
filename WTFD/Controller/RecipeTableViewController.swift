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

    var recipes = [Recipe]()
    var ingredients: [String]!
    var selecedRecipe: Int!
    var recipeByName = false
    var dishName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if recipeByName {
            searchForRecipeByName()
        } else {
            searchForRecipesByIngredients()
        }
    }

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
                           print(error.localizedDescription)
                       }
                   }
       }

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
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "getRecipeSteps"){
            let stepsVC = segue.destination as! RecipeStepsTableViewController
            stepsVC.recipe = recipes[selecedRecipe]
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
