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

class ReplyManager: ReplyManagerProtocol {
    func createReply(onCommentId commentId: UInt32, text: String,
                     onSuccess: ReplyCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.CreateReplyOnComment(commentId).route()
        APIClient.sharedClient.setAuthorization()
        
        let parameters: Parameters = ["text" : text]
        
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let replyJSON = json["data"]["reply"]
                onSuccess?(Reply(json: replyJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func uploadImage(toReplyId replyId: UInt32,imageData: Data,
                     onSuccess: ImageCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.UploadImageToReply(replyId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeUpload(route: route, data: imageData,
                                             fileKey: "image",
                                             onSuccess:
            { json in
                let imageJSON = json["data"]["image"]
                onSuccess?(Image(json: imageJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func uploadImages(toReplyId replyId: UInt32, imagesData: [Data],
                      onSuccess: ImagesCallback? = nil,
                      onFailure: JSONCallback? = nil,
                      onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.UploadImageToReply(replyId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeUpload(route: route, data: imagesData,
                                             fileKey: "images[]",
                                             onSuccess:
            { json in
                var images = [Image]()
                let imagesJSON = json["data"]["images"].arrayValue
                for imageJSON in imagesJSON {
                    images.append(Image(json: imageJSON))
                }
                onSuccess?(images)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func updateReply(withReplyId replyId: UInt32, text: String,
                     onSuccess: ReplyCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.UpdateReply(replyId).route()
        APIClient.sharedClient.setAuthorization()
        
        let parameters: Parameters = ["text" : text]
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let replyJSON = json["data"]["reply"]
                onSuccess?(Reply(json: replyJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func readReplyInfo(withReplyId replyId: UInt32,
                       onSuccess: ReplyCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.ReadReplyInfo(replyId).route()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let replyJSON = json["data"]["reply"]
                onSuccess?(Reply(json: replyJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func readReplyImages(withReplyId replyId: UInt32,
                         onSuccess: ImagesCallback? = nil,
                         onFailure: JSONCallback? = nil,
                         onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.ReadReplyImages(replyId).route()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let imagesJSON = json["data"]["images"].arrayValue
                var images = [Image]()
                for imageJSON in imagesJSON {
                    images.append(Image(json: imageJSON))
                }
                onSuccess?(images)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func deleteReply(withReplyId replyId: UInt32,
                     onSuccess: JSONCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.DeleteReply(replyId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                onSuccess?(json)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func getLikes(onReplyId replyId: UInt32,
                  onSuccess: LikesCallback? = nil,
                  onFailure: JSONCallback? = nil,
                  onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetLikesOnReply(replyId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let likesJSON = json["data"]["likes"].arrayValue
                var likes = [Like]()
                for likeJSON in likesJSON {
                    likes.append(Like(json: likeJSON))
                }
                onSuccess?(likes)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
}
