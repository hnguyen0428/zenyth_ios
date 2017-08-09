//
//  CommentManager.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class CommentManager: APIClient, CommentManagerProtocol {
    func createComment(onPinpostId pinpostId: UInt32, text: String,
                       onSuccess: CommentCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?) {
        <#code#>
    }
    
    func uploadImage(toCommentId commentId: UInt32, imageData: Data,
                     onSuccess: ImageCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?) {
        <#code#>
    }
    
    func updateComment(withCommentId commentId: UInt32, text: String,
                       onSuccess: CommentCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func readCommentInfo(withCommentId commentId: UInt32, text: String,
                         onSuccess: CommentCallback? = nil,
                         onFailure: JSONCallback? = nil,
                         onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func readCommentImages(withCommentId commentId: UInt32,
                           onSuccess: ImagesCallback? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func deleteComment(withCommentId commentId: UInt32,
                       onSuccess: JSONCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func getLikes(onCommentId commentId: UInt32,
                  onSuccess: LikesCallback? = nil,
                  onFailure: JSONCallback? = nil,
                  onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
}
