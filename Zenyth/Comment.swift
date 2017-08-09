//
//  Comment.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Comment: APIObject {
    var id: UInt32
    var text: String
    var userId: UInt32
    var commentableId: UInt32
    var commentableType: String
    var createdAt: String
    var updatedAt: String
    var images: [Image] = [Image]()
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.text = json["text"].stringValue
        self.userId = json["user_id"].uInt32Value
        self.commentableId = json["commentable_id"].uInt32Value
        self.commentableType = json["commentable_type"].stringValue
        self.createdAt = json["created_at"].stringValue
        self.updatedAt = json["updated_at"].stringValue
        
        let imagesJSON = json["images"].arrayValue
        for imageJSON in imagesJSON {
            self.images.append(Image(json: imageJSON))
        }
    }
    
    func toJSON() -> JSON {
        return [
            "id" : id,
            "text" : text,
            "user_id" : userId,
            "commentable_id" : commentableId,
            "commentable_type" : commentableType,
            "created_at" : createdAt,
            "updated_at" : updatedAt,
            "images" : images
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
