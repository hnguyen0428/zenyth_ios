//
//  Reply.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Reply: APIObject {
    var id: UInt32
    var text: String
    var userId: UInt32
    var onCommentId: UInt32
    var createdAt: String
    var updatedAt: String
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.text = json["text"].stringValue
        self.userId = json["user_id"].uInt32Value
        self.onCommentId = json["comment_id"].uInt32Value
        self.createdAt = json["created_at"].stringValue
        self.updatedAt = json["updated_at"].stringValue
    }
    
    func toJSON() -> JSON {
        return [
            "id" : id,
            "text" : text,
            "user_id" : userId,
            "comment_id" : onCommentId,
            "created_at" : createdAt,
            "updated_at" : updatedAt
        ]
    }
}
