//
//  Tag.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Tag: APIObject {
    var id: UInt32
    var name: String
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.name = json["name"].stringValue
    }
    
    func toJSON() -> JSON {
        return [
            "id": id,
            "name": name
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
