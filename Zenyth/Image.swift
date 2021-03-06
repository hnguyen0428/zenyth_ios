//
//  Image.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Image: APIObject {
    var id: UInt32
    var filename: String
    var directory: String
    var userId: UInt32
    var imageableId: UInt32
    var imageableType: String
    var url: String
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.filename = json["filename"].stringValue
        self.directory = json["directory"].stringValue
        self.userId = json["user_id"].uInt32Value
        self.imageableId = json["imageable_id"].uInt32Value
        self.imageableType = json["imageable_type"].stringValue
        self.url = json["url"].stringValue
    }
    
    func toJSON() -> JSON {
        return [
            "id": id,
            "filename": filename,
            "directory": directory,
            "user_id": userId,
            "imageable_id": imageableId,
            "imageable_type": imageableType,
            "url": url
        ]
    }
    
    func getURL(size: ImageSize? = nil) -> String {
        if let type = size {
            return "\(url)?size=\(type.name())"
        }
        else {
            return url
        }
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}

enum ImageSize {
    case small
    case medium
    case large
    
    func name() -> String {
        switch self {
        case .small:
            return "small"
        case .medium:
            return "medium"
        case .large:
            return "large"
        }
    }
}
