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

class TagManager: TagManagerProtocol {
    func searchTag(withKeyword keyword: String,
                   onSuccess: TagsCallback? = nil,
                   onFailure: JSONCallback? = nil,
                   onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.SearchTag.route()
        APIClient.sharedClient.setAuthorization()
        
        let parameters: Parameters = ["tag" : keyword]
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let tagsJSON = json["data"]["tags"].arrayValue
                var tags = [Tag]()
                for tagJSON in tagsJSON {
                    tags.append(Tag(json: tagJSON))
                }
                onSuccess?(tags)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func getTagInfo(forTagName tagName: String,
                    onSuccess: PinpostsCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetTagInfo.route()
        APIClient.sharedClient.setAuthorization()
        
        let parameters: Parameters = ["tag" : tagName]
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let pinpostsJSON = json["data"]["pinposts"].arrayValue
                var pinposts = [Pinpost]()
                for pinpostJSON in pinpostsJSON {
                    pinposts.append(Pinpost(json: pinpostJSON))
                }
                onSuccess?(pinposts)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
}
