//
//  LikeManager.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class LikeManager: LikeManagerProtocol {
    func createLike(onPinpostId pinpostId: UInt32,
                    onSuccess: LikeCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func createLike(onCommentId commentId: UInt32,
                    onSuccess: LikeCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func createLike(onReplyId replyId: UInt32,
                    onSuccess: LikeCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func readLike(withLikeId likeId: UInt32,
                  onSuccess: LikeCallback? = nil,
                  onFailure: JSONCallback? = nil,
                  onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func deleteLike(withLikeId likeId: UInt32,
                    onSuccess: JSONCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
}
