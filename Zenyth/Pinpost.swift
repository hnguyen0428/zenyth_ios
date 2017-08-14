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
    var creator: User
    var privacy: String
    var createdAt: String
    var updatedAt: String
    var comments: UInt32
    var likes: UInt32
    var images: [Image] = [Image]()
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.title = json["title"].stringValue
        self.pinpostDescription = json["description"].stringValue
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.creator = User(json: json["creator"])
        self.privacy = json["privacy"].stringValue
        self.createdAt = json["created_at"].stringValue
        self.updatedAt = json["updated_at"].stringValue
        self.comments = json["comments"].uInt32Value
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
            "id" : id,
            "title" : title,
            "description" : pinpostDescription,
            "latitude" : latitude,
            "longitude" : longitude,
            "creator" : creator.toJSON(),
            "privacy" : privacy,
            "created_at" : createdAt,
            "updated_at" : updatedAt,
            "images" : imagesJSON
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
