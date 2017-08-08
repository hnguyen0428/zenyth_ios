//
//  PinpostRequestsProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol PinpostManagerProtocol {
    func createPinpost(withTitle title: String, description: String,
                       latitude: Double, longitude: Double,
                       privacy: String, tags: String?,
                       onSuccess: PinpostCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    func uploadImage(toPinpostId pinpostId: UInt32, imageData: Data,
                     onSuccess: ImageCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    func updatePinpost(withPinpostId pinpostId: UInt32,
                       title: String?, description: String?,
                       latitude: Double, longitude: Double,
                       privacy: String,
                       onSuccess: PinpostCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    func readPinpostInfo(withPinpostId pinpostId: UInt32,
                         onSuccess: PinpostCallback?,
                         onFailure: JSONCallback?,
                         onRequestError: ErrorCallback?)
    
    func readPinpostImages(withPinpostId pinpostId: UInt32,
                           onSuccess: ImagesCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    func deletePinpost(withPinpostId pinpostId: UInt32,
                       onSuccess: JSONCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    func getComments(onPinpostId pinpostId: UInt32,
                     onSuccess: CommentsCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    func getLikes(onPinpostId pinpostId: UInt32,
                  onSuccess: LikesCallback?,
                  onFailure: JSONCallback?,
                  onRequestError: ErrorCallback?)
    
    func fetchPinpostByFrame(withTopLeftLat topLeftLat: Double, topLeftLong: Double,
                             bottomRightLat: Double, bottomRightLong: Double,
                             scope: String,
                             onSuccess: PinpostsCallback?,
                             onFailure: JSONCallback?,
                             onRequestError: ErrorCallback?)
    
    func fetchPinpostByRadius(withCenterLat centerLat: Double, centerLong: Double,
                              radius: Double, scope: String,
                              unit: String,
                              onSuccess: PinpostsCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
}
