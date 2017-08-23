//
//  PinpostManager.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class PinpostManager: PinpostManagerProtocol {
    func createPinpost(withTitle title: String, description: String,
                       latitude: Double, longitude: Double, privacy: String,
                       tags: String? = nil,
                       onSuccess: PinpostCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.CreatePinpost.route()
        APIClient.sharedClient.setAuthorization()
        var parameters: Parameters = [
            "title" : title,
            "description" : description,
            "latitude" : latitude,
            "longitude" : longitude,
            "privacy" : privacy
        ]
        if tags != nil {
            parameters.updateValue(tags!, forKey: "tags")
        }
        
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let pinpostJSON = json["data"]["pinpost"]
                onSuccess?(Pinpost(json: pinpostJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func uploadImage(toPinpostId pinpostId: UInt32, imageData: Data,
                     onSuccess: ImageCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.UploadImageToPinpost(pinpostId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeUpload(route: route, data: imageData,
                                             fileKey: "image",
                                             onSuccess:
            { json in
                let imageJSON = json["data"]["image"]
                onSuccess?(Image(json: imageJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func uploadImages(toPinpostId pinpostId: UInt32, imagesData: [Data],
                      onSuccess: ImagesCallback? = nil,
                      onFailure: JSONCallback? = nil,
                      onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.UploadImageToPinpost(pinpostId).route()
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
    
    func updatePinpost(withPinpostId pinpostId: UInt32, title: String? = nil,
                       description: String? = nil, latitude: Double? = nil,
                       longitude: Double? = nil, privacy: String? = nil,
                       onSuccess: PinpostCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.UpdatePinpost(pinpostId).route()
        APIClient.sharedClient.setAuthorization()
        
        var parameters: Parameters = Parameters.init()
        if title != nil {
            parameters.updateValue(title!, forKey: "title")
        }
        if description != nil {
            parameters.updateValue(description!, forKey: "description")
        }
        if latitude != nil {
            parameters.updateValue(latitude!, forKey: "latitude")
        }
        if longitude != nil {
            parameters.updateValue(longitude!, forKey: "longitude")
        }
        if privacy != nil {
            parameters.updateValue(privacy!, forKey: "privacy")
        }
        
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let pinpostJSON = json["data"]["pinpost"]
                onSuccess?(Pinpost(json: pinpostJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func readPinpostInfo(withPinpostId pinpostId: UInt32,
                         onSuccess: PinpostCallback? = nil,
                         onFailure: JSONCallback? = nil,
                         onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.ReadPinpostInfo(pinpostId).route()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let pinpostJSON = json["data"]["pinpost"]
                onSuccess?(Pinpost(json: pinpostJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func readPinpostImages(withPinpostId pinpostId: UInt32,
                           onSuccess: ImagesCallback? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.ReadPinpostImages(pinpostId).route()
        
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
    
    func deletePinpost(withPinpostId pinpostId: UInt32,
                       onSuccess: JSONCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.DeletePinpost(pinpostId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                onSuccess?(json)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func getComments(onPinpostId pinpostId: UInt32,
                     onSuccess: CommentsCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetCommentsOnPinpost(pinpostId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let commentsJSON = json["data"]["comments"].arrayValue
                var comments = [Comment]()
                for commentJSON in commentsJSON {
                    comments.append(Comment(json: commentJSON))
                }
                onSuccess?(comments)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func getLikes(onPinpostId pinpostId: UInt32,
                  onSuccess: LikesCallback? = nil,
                  onFailure: JSONCallback? = nil,
                  onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetLikesOnPinpost(pinpostId).route()
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
    
    func fetchPinpostByFrame(withTopLeftLat topLeftLat: Double,
                             topLeftLong: Double, bottomRightLat: Double,
                             bottomRightLong: Double, scope: String = "public",
                             onSuccess: PinpostsCallback? = nil,
                             onFailure: JSONCallback? = nil,
                             onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.FetchPinposts.route()
        APIClient.sharedClient.setAuthorization()
        
        let parameters: Parameters = [
            "type" : "frame",
            "top_left" : "\(topLeftLat),\(topLeftLong)",
            "bottom_right" : "\(bottomRightLat),\(bottomRightLong)",
            "scope" : scope
        ]
        
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
    
    func fetchPinpostByRadius(withCenterLat centerLat: Double,
                              centerLong: Double, radius: Double,
                              scope: String = "public", unit: String = "mi",
                              onSuccess: PinpostsCallback? = nil,
                              onFailure: JSONCallback? = nil,
                              onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.FetchPinposts.route()
        APIClient.sharedClient.setAuthorization()
        
        let parameters: Parameters = [
            "type" : "radius",
            "center" : "\(centerLat),\(centerLong)",
            "radius" : radius,
            "scope" : scope,
            "unit" : unit
        ]
        
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
    
    func fetchPinpostsFeed(paginate: UInt32? = nil, scope: String? = nil,
                           onSuccess: PinpostsCallbackWithPaginate? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.FetchFeed.route()
        APIClient.sharedClient.setAuthorization()
        
        var parameters: Parameters = Parameters.init()
        if paginate != nil {
            parameters.updateValue(paginate!, forKey: "paginate")
        }
        if scope != nil {
            parameters.updateValue(scope!, forKey: "scope")
        }
        
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let pinpostsJSON = json["data"]["pinposts"].arrayValue
                var pinposts = [Pinpost]()
                for pinpostJSON in pinpostsJSON {
                    pinposts.append(Pinpost(json: pinpostJSON))
                }
                
                let paginate = Paginate(json: json["data"])
                onSuccess?(pinposts, paginate)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func fetchPinposts(fromURL url: String,
                       onSuccess: PinpostsCallbackWithPaginate? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetRequest(url).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let pinpostsJSON = json["data"]["pinposts"].arrayValue
                var pinposts = [Pinpost]()
                for pinpostJSON in pinpostsJSON {
                    pinposts.append(Pinpost(json: pinpostJSON))
                }
                
                let paginate = Paginate(json: json["data"])
                onSuccess?(pinposts, paginate)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
}
