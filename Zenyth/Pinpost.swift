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
    var pinpostDescription: String
    var latitude: Double
    var longitude: Double
    var userId: UInt32
    var creator: User?
    var privacy: String
    var createdAt: String
    var updatedAt: String
    
    var comments: [Comment]?
    var likes: [Like]?
    var commentsCount: UInt32?
    var likesCount: UInt32?
    var images: [Image] = [Image]()
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.title = json["title"].stringValue
        self.pinpostDescription = json["description"].stringValue
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.userId = json["user_id"].uInt32Value
        
        if json["creator"] != JSON.null {
            self.creator = User(json: json["creator"])
        }
        self.privacy = json["privacy"].stringValue
        self.createdAt = json["created_at"].stringValue
        self.updatedAt = json["updated_at"].stringValue
        self.commentsCount = json["comments_count"].uInt32
        self.likesCount = json["likes_count"].uInt32
        
        if json["comments"] != JSON.null {
            self.comments = [Comment]()
            let commentsJSON = json["comments"].arrayValue
            for commentJSON in commentsJSON {
                self.comments!.append(Comment(json: commentJSON))
            }
        }
        
        if json["likes"] != JSON.null {
            self.likes = [Like]()
            let likesJSON = json["likes"].arrayValue
            for likeJSON in likesJSON {
                self.likes!.append(Like(json: likeJSON))
            }
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
        
        var commentsJSON = [JSON]()
        if let commentsArr = comments {
            for comment in commentsArr {
                commentsJSON.append(comment.toJSON())
            }
        }
        
        var likesJSON = [JSON]()
        if let likesArr = likes {
            for like in likesArr {
                likesJSON.append(like.toJSON())
            }
        }
        
        return [
            "id": id,
            "title": title,
            "description": pinpostDescription,
            "latitude": latitude,
            "longitude": longitude,
            "creator": creator?.toJSON(),
            "privacy": privacy,
            "created_at": createdAt,
            "updated_at": updatedAt,
            "images": imagesJSON,
            "comments": commentsJSON,
            "likes": likesJSON
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
