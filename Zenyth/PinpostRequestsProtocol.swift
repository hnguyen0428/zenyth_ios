//
//  PinpostRequestsProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol PinpostRequestsProtocol {
    func requestCreatePinpost(title: String, description: String,
                              latitude: Double, longitude: Double,
                              privacy: String, tags: String?,
                              onSuccess: PinpostCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    func requestUploadImageTo(pinpostId: UInt32, imageData: Data,
                              onSuccess: ImageCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    func requestUpdatePinpostWith(pinpostId: UInt32,
                                  title: String?, description: String?,
                                  latitude: Double, longitude: Double,
                                  privacy: String,
                                  onSuccess: PinpostCallback?,
                                  onFailure: JSONCallback?,
                                  onRequestError: ErrorCallback?)
    
    func requestReadPinpostInfo(pinpostId: UInt32,
                                onSuccess: PinpostCallback?,
                                onFailure: JSONCallback?,
                                onRequestError: ErrorCallback?)
    
    func requestReadPinpostImages(pinpostId: UInt32,
                                  onSuccess: ImagesCallback?,
                                  onFailure: JSONCallback?,
                                  onRequestError: ErrorCallback?)
    
    func requestDeletePinpostWith(pinpostId: UInt32,
                                  onSuccess: JSONCallback?,
                                  onFailure: JSONCallback?,
                                  onRequestError: ErrorCallback?)
    
    func requestGetCommentsOn(pinpostId: UInt32,
                              onSuccess: CommentsCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    func requestGetLikesOn(pinpostId: UInt32,
                           onSuccess: LikesCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    func requestFetchPinpostByFrame(topLeftLat: Double, topLeftLong: Double,
                                    bottomRightLat: Double, bottomRightLong: Double,
                                    scope: String,
                                    onSuccess: PinpostsCallback?,
                                    onFailure: JSONCallback?,
                                    onRequestError: ErrorCallback?)
    
    func requestFetchPinpostByRadius(centerLat: Double, centerLong: Double,
                                     radius: Double, scope: String,
                                     unit: String,
                                     onSuccess: PinpostsCallback?,
                                     onFailure: JSONCallback?,
                                     onRequestError: ErrorCallback?)
}
