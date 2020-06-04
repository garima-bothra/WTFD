//
//  RecipeStepsTableViewController.swift
//  WTFD
//
//  Created by Garima Bothra on 03/06/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class RecipeStepsViewController: UIViewController {

    //MARK: Variables
    var recipe: Recipe!
    var steps = [Step]()
    //MARK: IBOutlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var stepsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(recipe.name)"
        stepsTableView.delegate = self
        stepsTableView.dataSource = self
        recipeImageView.image = recipe.image
        searchForRecipeSteps()
        self.stepsTableView.reloadData()
    }
    //MARK: Searching for Recipe steps
    func searchForRecipeSteps() {
           let provider = MoyaProvider<SpoonacularAPI>()
           provider.request(.getRecipeInformation(id: recipe.id)) {
                       switch $0 {
                       case .success(let response):
                           do {
                               // Only allow successful HTTP codes
                               _ = try response.filterSuccessfulStatusCodes()

                               // Parse data as JSON
                               let json = try JSON(data: response.data)
                                let recipe = json.arrayValue[0]
                               let steps = recipe["steps"]
                               self.steps = steps.arrayValue.map({ Step(json: $0) })
                            self.stepsTableView.reloadData()
                           } catch {
                            let alert = UIAlertController(title: "Oops! Try again.", message: "There seems be an error with the server. Try again in a while.", preferredStyle: UIAlertController.Style.alert)
                                               alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                                               self.present(alert, animated: true, completion: nil)
                               print(error.localizedDescription)
                           }
                       case .failure(let error):
                        let alert = UIAlertController(title: "Failed to load recipes", message: "Please check your internet connection.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                           print(error.localizedDescription)
                       }
                   }
           self.stepsTableView.reloadData()
       }
}

//MARK:- TableViewDelegate and TableViewDataSource methods
extension RecipeStepsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: "recipeStep", for: indexPath) as! RecipeStepsTableViewCell
               // Configure cell
        cell.stepLabel.text = "\(steps[indexPath.row].stepNo).  \(steps[indexPath.row].name)"
               return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
