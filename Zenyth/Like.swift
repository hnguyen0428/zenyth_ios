//
//  Like.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Like: APIObject {
    var id: UInt32
    var likeableId: UInt32
    var likeableType: String
    var user: User
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.likeableId = json["likeable_id"].uInt32Value
        self.likeableType = json["likeable_type"].stringValue
        self.user = User(json: json["user"])
    }
    
    func toJSON() -> JSON {
        return [
            "id" : id,
            "user" : user.toJSON(),
            "likeable_id" : likeableId,
            "likeable_type" : likeableType
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
