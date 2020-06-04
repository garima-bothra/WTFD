//
//  NutrientsViewController.swift
//  WTFD
//
//  Created by Garima Bothra on 03/06/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class NutrientsViewController: UIViewController {

    let activityView = UIActivityIndicatorView(style: .large)
    var dishName: String!

    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!

    fileprivate func initialSetup() {
        super.viewDidLoad()
        navigationItem.title = ""
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
        searchNutrientData()
    }

    override func viewDidLoad() {
        initialSetup()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initialSetup()
    }
//MARK: Get all nutrient data
    func searchNutrientData(){
        let provider = MoyaProvider<SpoonacularAPI>()
                provider.request(.getNutritionInformation(dishName: dishName)) {
                    switch $0 {
                    case .success(let response):
                        do {
                            // Only allow successful HTTP codes
                            _ = try response.filterSuccessfulStatusCodes()

                            // Parse data as JSON
                            let json = try JSON(data: response.data)
                            // Parse each recipe's JSON
                            self.caloriesLabel.text = "CALORIES: \(json["calories"]["value"])\(json["calories"]["unit"])"
                            self.carbLabel.text = "CARBS: \(json["carbs"]["value"])\(json["carbs"]["unit"])"
                            self.fatLabel.text = "FAT: \(json["fat"]["value"])\(json["fat"]["unit"])"
                            self.proteinLabel.text = "PROTEIN: \(json["protein"]["value"])\(json["protein"]["unit"])"
                        } catch {
                            let alert = UIAlertController(title: "Oops! Try again.", message: "There seems be an error with the server. Try again in a while.", preferredStyle: UIAlertController.Style.alert)
                                               alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                                               self.present(alert, animated: true, completion: nil)
                            print(error.localizedDescription)
                        }
                    case .failure(let error):
                        let alert = UIAlertController(title: "Failed to load data", message: "Please check your internet connection.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print(error.localizedDescription)
                    }
                }
        self.activityView.stopAnimating()
    }

}
