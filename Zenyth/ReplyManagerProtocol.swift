//
//  ReplyManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol ReplyManagerProtocol {
    /**
     Create a reply
     - Parameters:
        - commentId: ID of comment to be replied to
        - text: reply's text
        - onSuccess: callback function with Reply parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func createReply(onCommentId commentId: UInt32, text: String,
                     onSuccess: ReplyCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    /**
     Upload an image to a reply
     - Parameters:
        - replyId: ID of reply to be uploaded to
        - imageData: image data to be uploaded
        - onSuccess: callback function with Image parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func uploadImage(toReplyId replyId: UInt32, imageData: Data,
                     onSuccess: ImageCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    /**
     Upload images to a reply
     - Parameters:
     - replyId: ID of reply to be uploaded to
     - imagesData: array of images data to be uploaded
     - onSuccess: callback function with [Image] parameter
     - onFailure: callback function with JSON parameter
     - onRequestError: callback function with NSError parameter
     */
    func uploadImages(toReplyId replyId: UInt32, imagesData: [Data],
                      onSuccess: ImagesCallback?,
                      onFailure: JSONCallback?,
                      onRequestError: ErrorCallback?)
    
    /**
     Update a reply
     - Parameters:
        - replyId: ID of reply to be updated
        - text: new reply's text
        - onSuccess: callback function with Reply parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func updateReply(withReplyId replyId: UInt32, text: String,
                     onSuccess: ReplyCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    /**
     Read a reply
     - Parameters:
        - replyId: ID of reply to be read
        - onSuccess: callback function with Reply parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func readReplyInfo(withReplyId replyId: UInt32,
                       onSuccess: ReplyCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    /**
     Read images of a reply
     - Parameters:
        - replyId: ID of reply to be read
        - onSuccess: callback function with [Image] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func readReplyImages(withReplyId replyId: UInt32,
                         onSuccess: ImagesCallback?,
                         onFailure: JSONCallback?,
                         onRequestError: ErrorCallback?)
    
    /**
     Delete a reply
     - Parameters:
        - replyId: ID of reply to be deleted
        - onSuccess: callback function with JSON parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func deleteReply(withReplyId replyId: UInt32,
                     onSuccess: JSONCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    /**
     Get likes on a reply
     - Parameters:
        - replyId: ID of reply to get likes
        - onSuccess: callback function with [Like] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func getLikes(onReplyId replyId: UInt32,
                  onSuccess: LikesCallback?,
                  onFailure: JSONCallback?,
                  onRequestError: ErrorCallback?)
}
