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
    var creator: User?
    var commentableId: UInt32
    var commentableType: String
    var createdAt: String
    var updatedAt: String
    var replies: [Reply] = [Reply]()
    var likes: [Like] = [Like]()
    var images: [Image] = [Image]()
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.text = json["text"].stringValue
        self.creator = User(json: json["creator"])
        self.commentableId = json["commentable_id"].uInt32Value
        self.commentableType = json["commentable_type"].stringValue
        self.createdAt = json["created_at"].stringValue
        self.updatedAt = json["updated_at"].stringValue
        
        let repliesJSON = json["replies"].arrayValue
        for replyJSON in repliesJSON {
            self.replies.append(Reply(json: replyJSON))
        }
        
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
        
        var repliesJSON = [JSON]()
        for reply in replies {
            repliesJSON.append(reply.toJSON())
        }

        
        var likesJSON = [JSON]()
        for like in likes {
            likesJSON.append(like.toJSON())
        }

        
        return [
            "id": id,
            "text": text,
            "creator": creator?.toJSON(),
            "commentable_id": commentableId,
            "commentable_type": commentableType,
            "created_at": createdAt,
            "updated_at": updatedAt,
            "images": imagesJSON,
            "replies": repliesJSON,
            "likes": likesJSON
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
