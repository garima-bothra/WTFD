//
//  SearchNutrientsViewController.swift
//  WTFD
//
//  Created by Garima Bothra on 03/06/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class SearchNutrientsViewController: UIViewController {

    @IBOutlet weak var dishNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func searchRecipesButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "DishNameRecipes", sender: Any.self)
    }

    @IBAction func searchNutrientValueButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "getNutrientData", sender: Any.self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "getNutrientData"){
            let nutri = segue.destination as! NutrientsViewController
            nutri.dishName = self.dishNameTextField.text
        }
        if(segue.identifier == "DishNameRecipes") {
            let recipesVC = segue.destination as! RecipeTableViewController
            recipesVC.recipeByName = true
            recipesVC.dishName = self.dishNameTextField.text
        }
    }
}
