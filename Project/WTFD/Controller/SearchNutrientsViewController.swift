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
    //MARK: IBOutlets
    @IBOutlet weak var dishNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        dishNameTextField.delegate = self
        self.navigationItem.title = "Dish Name"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    //MARK: IBActions
    @IBAction func searchRecipesButtonPressed(_ sender: Any) {
        if isCheckFieldEmpty() == false {
            self.performSegue(withIdentifier: "DishNameRecipes", sender: Any.self)
        }
    }

    @IBAction func searchNutrientValueButtonPressed(_ sender: Any) {
        if !isCheckFieldEmpty() {
            self.performSegue(withIdentifier: "getNutrientData", sender: Any.self)
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    //MARK: Passing data to next view controller
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

    //MARK: Check TextFiled
    func isCheckFieldEmpty() ->Bool {
        if(dishNameTextField.text == ""){
            let alert = UIAlertController(title: "No dish name found", message: "Please enter the name of the dish first.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return true
        }
        return false
    }
}

extension SearchNutrientsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }



    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
