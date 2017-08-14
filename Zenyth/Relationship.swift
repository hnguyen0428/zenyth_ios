//
//  Relationship.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Relationship: APIObject {
    var id: UInt32
    var requester: User
    var requestee: User
    var status: Bool
    var blocked: Bool
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.requester = User(json: json["requester"])
        self.requestee = User(json: json["requestee"])
        self.status = json["status"].boolValue
        self.blocked = json["blocked"].boolValue
    }
    
    func toJSON() -> JSON {
        return [
            "id" : id,
            "requester_id" : requester.toJSON(),
            "requestee_id" : requestee.toJSON(),
            "status" : status,
            "blocked" : blocked
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
