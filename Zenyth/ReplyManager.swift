//
//  ReplyManager.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ReplyManager: APIClient, ReplyManagerProtocol {
    func createReply(onCommentId commentId: UInt32, text: String,
                     onSuccess: ReplyCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func uploadImage(toReplyId replyId: UInt32,imageData: Data,
                     onSuccess: ImageCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func updateReply(withReplyId replyId: UInt32, text: String,
                     onSuccess: ReplyCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func readReplyInfo(withReplyId replyId: UInt32, text: String,
                       onSuccess: ReplyCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func readReplyImages(withReplyId replyId: UInt32,
                         onSuccess: ImagesCallback? = nil,
                         onFailure: JSONCallback? = nil,
                         onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func deleteReply(withReplyId replyId: UInt32,
                     onSuccess: JSONCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func getLikes(onReplyId replyId: UInt32,
                  onSuccess: LikesCallback? = nil,
                  onFailure: JSONCallback? = nil,
                  onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
}
