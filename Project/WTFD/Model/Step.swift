//
//  Step.swift
//  WTFD
//
//  Created by Garima Bothra on 03/06/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import Foundation
import SwiftyJSON

class Step {
    var stepNo: Int
    var name: String

    init(json: JSON) {
        self.stepNo = json["number"].intValue
        self.name = json["step"].stringValue
    }
}
