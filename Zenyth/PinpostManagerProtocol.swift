//
//  PinpostManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol PinpostManagerProtocol {
    /**
     Create a pinpost
     - Parameters:
        - title: title of pinpost
        - description: description of pinpost
        - latitude: latitude of pinpost
        - longitude: longitude of pinpost
        - privacy: privacy option for pinpost
        - tags: tags of pinpost
        - onSuccess: callback function with Pinpost parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func createPinpost(withTitle title: String, description: String,
                       latitude: Double, longitude: Double,
                       privacy: String, tags: String?,
                       onSuccess: PinpostCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    /**
     Upload an image to a pinpost
     - Parameters:
        - pinpostId: ID of pinpost to be uploaded to
        - imageData: image data to be uploaded
        - thumbnailData: thumbnail data to be uploaded
        - onSuccess: callback function with Image parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func uploadImage(toPinpostId pinpostId: UInt32, imageData: Data,
                     thumbnailData: Data,
                     onSuccess: ImageCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    /**
     Upload images to a pinpost
     - Parameters:
     - pinpostId: ID of pinpost to be uploaded to
     - imagesData: array of images data to be uploaded
     - onSuccess: callback function with [Image] parameter
     - onFailure: callback function with JSON parameter
     - onRequestError: callback function with NSError parameter
     */
    func uploadImages(toPinpostId pinpostId: UInt32, imagesData: [Data],
                      onSuccess: ImagesCallback?,
                      onFailure: JSONCallback?,
                      onRequestError: ErrorCallback?)
    
    /**
     Update a pinpost
     - Parameters:
        - pinpostId: ID of pinpost to be updated
        - title: new title of pinpost
        - description: new description of pinpost
        - latitude: new latitude of pinpost
        - longitude: new longitude of pinpost
        - privacy: new privacy option for pinpost
        - onSuccess: callback function with Pinpost parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func updatePinpost(withPinpostId pinpostId: UInt32,
                       title: String?, description: String?,
                       latitude: Double?, longitude: Double?,
                       privacy: String?,
                       onSuccess: PinpostCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    /**
     Read a pinpost
     - Parameters:
        - pinpostId: ID of pinpost to be read
        - onSuccess: callback function with Pinpost parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func readPinpostInfo(withPinpostId pinpostId: UInt32,
                         onSuccess: PinpostCallback?,
                         onFailure: JSONCallback?,
                         onRequestError: ErrorCallback?)
    
    /**
     Read all images of a pinpost
     - Parameters:
        - pinpostId: ID of pinpost to be read
        - onSuccess: callback function with [Image] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func readPinpostImages(withPinpostId pinpostId: UInt32,
                           onSuccess: ImagesCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    /**
     Delete a pinpost
     - Parameters:
        - pinpostId: ID of pinpost to be deleted
        - onSuccess: callback function with JSON parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func deletePinpost(withPinpostId pinpostId: UInt32,
                       onSuccess: JSONCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    /**
     Get all comments on a pinpost
     - Parameters:
        - pinpostId: ID of pinpost to get comments
        - onSuccess: callback function with [Comment] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func getComments(onPinpostId pinpostId: UInt32,
                     onSuccess: CommentsCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    /**
     Get all likes on a pinpost
     - Parameters:
        - pinpostId: ID of pinpost to get likes
        - onSuccess: callback function with [Like] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func getLikes(onPinpostId pinpostId: UInt32,
                  onSuccess: LikesCallback?,
                  onFailure: JSONCallback?,
                  onRequestError: ErrorCallback?)
    
    /**
     Fetch pinpost in a rectangle on the map given the corner coordinates
     - Parameters:
        - topLeftLat: latitude of the top left corner
        - topLeftLong: longitude of the top left corner
        - bottmRightLat: latitude of the bottom right corner
        - bottomRightLong: longitude of the bottom right corner
        - scope: scope of the pinposts you want to get back ['self', 'friends', 'public']
        - onSuccess: callback function with [Pinpost] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func fetchPinpostByFrame(withTopLeftLat topLeftLat: Double, topLeftLong: Double,
                             bottomRightLat: Double, bottomRightLong: Double,
                             scope: String,
                             onSuccess: PinpostsCallback?,
                             onFailure: JSONCallback?,
                             onRequestError: ErrorCallback?)
    
    /**
     Fetch pinpost in a radius around the center
     - Parameters:
        - centerLat: latitude of the top left corner
        - centerLong: longitude of the top left corner
        - radius: radius around the center specified
        - scope: scope of the pinposts you want to get back ['self', 'friends', 'public']
        - unit: unit of radius ['km', 'mi']
        - onSuccess: callback function with [Pinpost] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func fetchPinpostByRadius(withCenterLat centerLat: Double, centerLong: Double,
                              radius: Double, scope: String,
                              unit: String,
                              onSuccess: PinpostsCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    /**
     Fetch the feed
     - Parameters:
        - paginate: how many pinposts to get back
        - scope: scope of the pinposts you want to get back ['self', 'friends', 'public']
        - onSuccess: callback function with [Pinpost] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func fetchPinpostsFeed(paginate: UInt32?, scope: String?,
                           onSuccess: PinpostsCallbackWithPaginate?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    /**
     Fetch the feed
     - Parameters:
     - url given by pagination to fetch the next page of pinposts
     - onSuccess: callback function with [Pinpost] parameter
     - onFailure: callback function with JSON parameter
     - onRequestError: callback function with NSError parameter
     */
    func fetchPinposts(fromURL url: String,
                       onSuccess: PinpostsCallbackWithPaginate?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
}
