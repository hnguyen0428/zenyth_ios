//
//  TagRequestsProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol TagRequestsProtocol {
    func requestSearchTag(keyword: String,
                          onSuccess: TagsCallback?,
                          onFailure: JSONCallback?,
                          onRequestError: ErrorCallback?)
    
    func requestGetTagInfo(tagName: String,
                           onSuccess: PinpostsCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
}
