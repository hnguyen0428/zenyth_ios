//
//  TagManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol TagManagerProtocol {
    func searchTag(withKeyword keyword: String,
                   onSuccess: TagsCallback?,
                   onFailure: JSONCallback?,
                   onRequestError: ErrorCallback?)
    
    func getTagInfo(forTagName tagName: String,
                    onSuccess: PinpostsCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
}
