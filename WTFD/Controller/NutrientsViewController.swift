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

    var dishName: String!

    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchNutrientData()
        // Do any additional setup after loading the view.
    }

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
                            print(error.localizedDescription)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
    }

}
