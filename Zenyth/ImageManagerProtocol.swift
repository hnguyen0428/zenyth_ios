//
//  ImageRequestsProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol ImageRequestsProtocol {
    func getImageData(withImageId imageId: UInt32,
                      onSuccess: DataCallback?,
                      onFailure: JSONCallback?,
                      onRequestError: ErrorCallback?)
    
    func deleteImage(withImageId imageId: UInt32,
                     onSuccess: JSONCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
}
