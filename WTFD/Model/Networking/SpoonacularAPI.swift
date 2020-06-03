//
//  SpoonacularAPI.swift
//  WTFD
//
//  Created by Garima Bothra on 03/06/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import Foundation
import Moya

enum SpoonacularAPI {

    case findRecipesByIngredients(ingredients: [String])
    case getIngredientInformation(ingredient: String)
    case getRecipeInformation(id:Int)
}

extension SpoonacularAPI: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.spoonacular.com/")!
    }

    var path: String {
        switch self {
        case .findRecipesByIngredients(_):
            return "recipes/findByIngredients"
        case .getIngredientInformation(let ingredient):
            return "food/ingredients/\(ingredient)/information"
        case .getRecipeInformation(let id):
            return "recipes/\(id)/analyzedInstructions"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return "".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case .findRecipesByIngredients(let ingredients):
            return .requestParameters(parameters:
                [
                    "ingredients": ((ingredients.map({ $0 })).joined(separator: ",+")),
                    "apiKey": Spoonacular.apiKey
                ], encoding: URLEncoding.default)
        default:
            return .requestParameters(parameters: [ "apiKey": Spoonacular.apiKey ], encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        return nil
    }

}
