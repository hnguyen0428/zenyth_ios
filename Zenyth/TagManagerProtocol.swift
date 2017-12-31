//
//  TagManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol TagManagerProtocol {
    /**
     Search for a tag with keyword
     - Parameters:
        - keyword: search query
        - onSuccess: callback function with [Tag] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func searchTag(withKeyword keyword: String,
                   onSuccess: TagsCallback?,
                   onFailure: JSONCallback?,
                   onRequestError: ErrorCallback?)
    
    /**
     Get all pinposts associated with this tag
     - Parameters:
        - tagName: name of tag to be looked up
        - onSuccess: callback function with [Pinpost] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func getTagInfo(forTagName tagName: String,
                    onSuccess: PinpostsCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
}
