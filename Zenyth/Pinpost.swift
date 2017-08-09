//
//  Pinpost.swift
//  Zenyth
//
//  Created by Hoang on 7/20/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Pinpost: APIObject {
    var id: UInt32
    var title: String
    var description: String
    var latitude: Double
    var longitude: Double
    var userId: UInt32
    var privacy: String
    var createdAt: String
    var updatedAt: String
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.userId = json["user_id"].uInt32Value
        self.privacy = json["privacy"].stringValue
        self.createdAt = json["created_at"].stringValue
        self.updatedAt = json["updated_at"].stringValue
    }
    
    func toJSON() -> JSON {
        return [
            "id" : id,
            "title" : title,
            "description" : description,
            "latitude" : latitude,
            "longitude" : longitude,
            "user_id" : userId,
            "privacy" : privacy,
            "created_at" : createdAt,
            "updated_at" : updatedAt
        ]
    }
}
