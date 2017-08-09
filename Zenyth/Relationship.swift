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
    var requesterId: UInt32
    var requesteeId: UInt32
    var status: Bool
    var blocked: Bool
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.requesterId = json["requester_id"].uInt32Value
        self.requesteeId = json["requestee_id"].uInt32Value
        self.status = json["status"].boolValue
        self.blocked = json["blocked"].boolValue
    }
    
    func toJSON() -> JSON {
        return [
            "id" : id,
            "requester_id" : requesterId,
            "requestee_id" : requesteeId,
            "status" : status,
            "blocked" : blocked
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
