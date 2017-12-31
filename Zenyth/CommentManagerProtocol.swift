//
//  CommentManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol CommentManagerProtocol {
    /**
     Create a comment
     - Parameters:
        - pinpostId: ID of pinpost to be commented on
        - text: comment's text
        - onSuccess: callback function with Comment parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func createComment(onPinpostId pinpostId: UInt32, text: String,
                       onSuccess: CommentCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    /**
     Upload an image to a comment
     - Parameters:
        - commentId: ID of comment to be uploaded to
        - imageData: image data to be uploaded
        - onSuccess: callback function with Image parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func uploadImage(toCommentId commentId: UInt32, imageData: Data,
                     onSuccess: ImageCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    /**
     Upload images to a comment
     - Parameters:
     - commentId: ID of comment to be uploaded to
     - imagesData: array of images data to be uploaded
     - onSuccess: callback function with [Image] parameter
     - onFailure: callback function with JSON parameter
     - onRequestError: callback function with NSError parameter
     */
    func uploadImages(toCommentId commentId: UInt32, imagesData: [Data],
                      onSuccess: ImagesCallback?,
                      onFailure: JSONCallback?,
                      onRequestError: ErrorCallback?)
    
    /**
     Update a comment
     - Parameters:
        - commentId: ID of comment to be updated
        - text: new text of comment
        - onSuccess: callback function with Comment parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func updateComment(withCommentId commentId: UInt32, text: String,
                       onSuccess: CommentCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    /**
     Read a comment
     - Parameters:
        - commentId: ID of comment to be read
        - onSuccess: callback function with Comment parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func readCommentInfo(withCommentId commentId: UInt32,
                         onSuccess: CommentCallback?,
                         onFailure: JSONCallback?,
                         onRequestError: ErrorCallback?)
    
    /**
     Read all images of a comment
     - Parameters:
        - commentId: ID of comment to be read
        - onSuccess: callback function with [Image] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func readCommentImages(withCommentId commentId: UInt32,
                           onSuccess: ImagesCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    /**
     Delete a comment
     - Parameters:
        - commentId: ID of comment to be deleted
        - onSuccess: callback function with JSON parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func deleteComment(withCommentId commentId: UInt32,
                       onSuccess: JSONCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    /**
     Get all likes on a comment
     - Parameters:
        - commentId: ID of comment to get likes
        - onSuccess: callback function with [Like] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func getLikes(onCommentId commentId: UInt32,
                  onSuccess: LikesCallback?,
                  onFailure: JSONCallback?,
                  onRequestError: ErrorCallback?)
    
    /**
     Get all replies on a comment
     - Parameters:
        - commentId: ID of comment to get likes
        - onSuccess: callback function with [Reply] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func getReplies(onCommentId commentId: UInt32,
                    onSuccess: RepliesCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
}
