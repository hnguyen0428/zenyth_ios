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

class CommentManager: CommentManagerProtocol {
    func createComment(onPinpostId pinpostId: UInt32, text: String,
                       onSuccess: CommentCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.CreateCommentOnPinpost(pinpostId).route()
        APIClient.sharedClient.setAuthorization()
        
        let parameters: Parameters = ["text" : text]
        
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let commentJSON = json["data"]["comment"]
                onSuccess?(Comment(json: commentJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func uploadImage(toCommentId commentId: UInt32, imageData: Data,
                     onSuccess: ImageCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?) {
        let route = Endpoint.UploadImageToComment(commentId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeUpload(route: route, data: imageData,
                                             fileKey: "image",
                                             onSuccess:
            { json in
                let imageJSON = json["data"]["image"]
                onSuccess?(Image(json: imageJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func uploadImages(toCommentId commentId: UInt32, imagesData: [Data],
                      onSuccess: ImagesCallback? = nil,
                      onFailure: JSONCallback? = nil,
                      onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.UploadImageToComment(commentId).route()
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
    
    func updateComment(withCommentId commentId: UInt32, text: String,
                       onSuccess: CommentCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.UpdateComment(commentId).route()
        APIClient.sharedClient.setAuthorization()
        
        let parameters: Parameters = ["text" : text]
        
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let commentJSON = json["data"]["comment"]
                onSuccess?(Comment(json: commentJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func readCommentInfo(withCommentId commentId: UInt32,
                         onSuccess: CommentCallback? = nil,
                         onFailure: JSONCallback? = nil,
                         onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.ReadCommentInfo(commentId).route()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let commentJSON = json["data"]["comment"]
                onSuccess?(Comment(json: commentJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func readCommentImages(withCommentId commentId: UInt32,
                           onSuccess: ImagesCallback? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.ReadCommentImages(commentId).route()
        
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
    
    func deleteComment(withCommentId commentId: UInt32,
                       onSuccess: JSONCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.DeleteComment(commentId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                onSuccess?(json)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func getLikes(onCommentId commentId: UInt32,
                  onSuccess: LikesCallback? = nil,
                  onFailure: JSONCallback? = nil,
                  onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetLikesOnComment(commentId).route()
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
    
    func getReplies(onCommentId commentId: UInt32,
                    onSuccess: RepliesCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetRepliesOnComment(commentId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let repliesJSON = json["data"]["replies"].arrayValue
                var replies = [Reply]()
                for replyJSON in repliesJSON {
                    replies.append(Reply(json: replyJSON))
                }
                onSuccess?(replies)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
}
