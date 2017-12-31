//
//  ImageManager.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ImageManager: ImageManagerProtocol {
    func getImageData(withImageName imageName: String,
                      onSuccess: DataCallback? = nil,
                      onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetImageData(imageName).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeDownload(route: route,
                                               onSuccess:
            { data in
                onSuccess?(data)
        }, onRequestError: onRequestError)
    }
    
    func getImageData(withUrl url: String, onSuccess: DataCallback? = nil,
                      onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetImageDataWithUrl(url).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeDownload(route: route,
                                               onSuccess:
            { data in
                onSuccess?(data)
        }, onRequestError: onRequestError)
    }
    
    func deleteImage(withImageId imageId: UInt32,
                     onSuccess: JSONCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.DeleteImage(imageId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                onSuccess?(json)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
}
