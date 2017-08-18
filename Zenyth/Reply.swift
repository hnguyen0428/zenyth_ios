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
    var creator: User
    var onCommentId: UInt32
    var createdAt: String
    var updatedAt: String
    var likes: UInt32
    var images: [Image] = [Image]()
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.text = json["text"].stringValue
        self.creator = User(json: json["creator"])
        self.onCommentId = json["comment_id"].uInt32Value
        self.createdAt = json["created_at"].stringValue
        self.updatedAt = json["updated_at"].stringValue
        self.likes = json["likes"].uInt32Value
        
        let imagesJSON = json["images"].arrayValue
        for imageJSON in imagesJSON {
            self.images.append(Image(json: imageJSON))
        }
    }
    
    func toJSON() -> JSON {
        var imagesJSON = [JSON]()
        for image in images {
            imagesJSON.append(image.toJSON())
        }
        
        return [
            "id": id,
            "text": text,
            "creator": creator.toJSON(),
            "comment_id": onCommentId,
            "created_at": createdAt,
            "updated_at": updatedAt,
            "images": imagesJSON
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
