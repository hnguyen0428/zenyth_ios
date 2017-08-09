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
        let route = Endpoint.CreateLikeOnPinpost(pinpostId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let likeJSON = json["data"]["like"]
                onSuccess?(Like(json: likeJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func createLike(onCommentId commentId: UInt32,
                    onSuccess: LikeCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.CreateReplyOnComment(commentId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let likeJSON = json["data"]["like"]
                onSuccess?(Like(json: likeJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func createLike(onReplyId replyId: UInt32,
                    onSuccess: LikeCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.CreateLikeOnReply(replyId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let likeJSON = json["data"]["like"]
                onSuccess?(Like(json: likeJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func readLike(withLikeId likeId: UInt32,
                  onSuccess: LikeCallback? = nil,
                  onFailure: JSONCallback? = nil,
                  onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.ReadLike(likeId).route()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let likeJSON = json["data"]["like"]
                onSuccess?(Like(json: likeJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func deleteLike(withLikeId likeId: UInt32,
                    onSuccess: JSONCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.DeleteLike(likeId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                onSuccess?(json)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
}
