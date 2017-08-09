//
//  TagManager.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class TagManager: APIClient, TagManagerProtocol {
    func searchTag(withKeyword keyword: String,
                   onSuccess: TagsCallback? = nil,
                   onFailure: JSONCallback? = nil,
                   onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func getTagInfo(forTagName tagName: String,
                    onSuccess: PinpostsCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
}
