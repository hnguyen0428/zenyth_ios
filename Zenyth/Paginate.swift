//
//  Paginate.swift
//  Zenyth
//
//  Created by Hoang on 8/23/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Paginate : APIObject {
    var currentPage: UInt32 = 0
    var fromIndex: UInt32 = 0
    var toIndex: UInt32 = 0
    var path: String
    var perPage: UInt32
    var nextPageUrl: String?
    var prevPageUrl: String?
    
    init(json: JSON) {
        self.currentPage = json["current_page"].uInt32Value
        self.fromIndex = json["from"].uInt32Value
        self.toIndex = json["to"].uInt32Value
        self.path = json["path"].stringValue
        self.perPage = UInt32(json["per_page"].stringValue)!
        self.prevPageUrl = json["prev_page_url"].string
        self.nextPageUrl = json["next_page_url"].string
    }
    
    func toJSON() -> JSON {
        return [
            "current_page": currentPage,
            "from": fromIndex,
            "to": toIndex,
            "path": path,
            "per_page": perPage,
            "next_page_url": nextPageUrl,
            "prev_page_url": prevPageUrl
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
