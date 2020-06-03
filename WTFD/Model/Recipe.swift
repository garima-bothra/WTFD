//
//  Recipe.swift
//  WTFD
//
//  Created by Garima Bothra on 03/06/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import Foundation
import SwiftyJSON

class Recipe {
    var id: Int
    var name: String
    var image: UIImage?

    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["title"].stringValue
        setImage(from: json["image"].stringValue)
    }

    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            self.image = image
        }
    }
}
