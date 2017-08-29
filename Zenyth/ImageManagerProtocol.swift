//
//  ImageManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol ImageManagerProtocol {
    /**
     Get image data
     - Parameters:
        - imageName: name of image to download
        - onSuccess: callback function with Data parameter
        - onRequestError: callback function with NSError parameter
     */
    func getImageData(withImageName imageName: String,
                      onSuccess: DataCallback?,
                      onRequestError: ErrorCallback?)
    
    /**
     Get image data
     - Parameters:
        - url: url of image
        - onSuccess: callback function with Data parameter
        - onRequestError: callback function with NSError parameter
     */
    func getImageData(withUrl url: String,
                      onSuccess: DataCallback?,
                      onRequestError: ErrorCallback?)
    
    /**
     Delete an image
     - Parameters:
        - imageId: ID of image to delete
        - onSuccess: callback function with JSON parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func deleteImage(withImageId imageId: UInt32,
                     onSuccess: JSONCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
}
