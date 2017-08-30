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
    var likes: [Like] = [Like]()
    var images: [Image] = [Image]()
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.text = json["text"].stringValue
        self.creator = User(json: json["creator"])
        self.onCommentId = json["comment_id"].uInt32Value
        self.createdAt = json["created_at"].stringValue
        self.updatedAt = json["updated_at"].stringValue
        
        let likesJSON = json["likes"].arrayValue
        for likeJSON in likesJSON {
            self.likes.append(Like(json: likeJSON))
        }
        
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
        
        var likesJSON = [JSON]()
        for like in likes {
            likesJSON.append(like.toJSON())
        }
        
        return [
            "id": id,
            "text": text,
            "creator": creator.toJSON(),
            "comment_id": onCommentId,
            "created_at": createdAt,
            "updated_at": updatedAt,
            "images": imagesJSON,
            "likes": likesJSON
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
