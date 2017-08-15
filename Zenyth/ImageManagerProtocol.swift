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
        - imageId: ID of image to get data of
        - onSuccess: callback function with Data parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func getImageData(withImageId imageId: UInt32,
                      onSuccess: DataCallback?,
                      onFailure: JSONCallback?,
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
