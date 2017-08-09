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
    func getImageData(withImageId imageId: UInt32,
                      onSuccess: DataCallback? = nil,
                      onFailure: JSONCallback? = nil,
                      onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func deleteImage(withImageId imageId: UInt32,
                     onSuccess: JSONCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
}
