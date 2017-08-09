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

class PinpostManager: APIClient, PinpostManagerProtocol {
    func createPinpost(withTitle title: String, description: String,
                       latitude: Double, longitude: Double, privacy: String,
                       tags: String?,
                       onSuccess: PinpostCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func uploadImage(toPinpostId pinpostId: UInt32, imageData: Data,
                     onSuccess: ImageCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func updatePinpost(withPinpostId pinpostId: UInt32, title: String? = nil,
                       description: String? = nil, latitude: Double? = nil,
                       longitude: Double? = nil, privacy: String? = nil,
                       onSuccess: PinpostCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func readPinpostInfo(withPinpostId pinpostId: UInt32,
                         onSuccess: PinpostCallback? = nil,
                         onFailure: JSONCallback? = nil,
                         onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func readPinpostImages(withPinpostId pinpostId: UInt32,
                           onSuccess: ImagesCallback? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func deletePinpost(withPinpostId pinpostId: UInt32,
                       onSuccess: JSONCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func getComments(onPinpostId pinpostId: UInt32,
                     onSuccess: CommentsCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func getLikes(onPinpostId pinpostId: UInt32,
                  onSuccess: LikesCallback? = nil,
                  onFailure: JSONCallback? = nil,
                  onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func fetchPinpostByFrame(withTopLeftLat topLeftLat: Double,
                             topLeftLong: Double, bottomRightLat: Double,
                             bottomRightLong: Double, scope: String,
                             onSuccess: PinpostsCallback? = nil,
                             onFailure: JSONCallback? = nil,
                             onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func fetchPinpostByRadius(withCenterLat centerLat: Double,
                              centerLong: Double, radius: Double, scope: String,
                              unit: String,
                              onSuccess: PinpostsCallback? = nil,
                              onFailure: JSONCallback? = nil,
                              onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
}
