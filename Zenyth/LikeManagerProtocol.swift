//
//  LikeManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol LikeManagerProtocol {
    /**
     Like a pinpost
     - Parameters:
        - pinpostId: ID of pinpost to be liked
        - onSuccess: callback function with Like parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func createLike(onPinpostId pinpostId: UInt32,
                    onSuccess: LikeCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
    
    /**
     Like a comment
     - Parameters:
        - commentId: ID of comment to be liked
        - onSuccess: callback function with Like parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func createLike(onCommentId commentId: UInt32,
                    onSuccess: LikeCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
    
    /**
     Like a reply
     - Parameters:
        - replyId: ID of reply to be liked
        - onSuccess: callback function with Like parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func createLike(onReplyId replyId: UInt32,
                    onSuccess: LikeCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
    
    /**
     Read a like
     - Parameters:
        - likeId: ID of like to be read
        - onSuccess: callback function with Like parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func readLike(withLikeId likeId: UInt32,
                  onSuccess: LikeCallback?,
                  onFailure: JSONCallback?,
                  onRequestError: ErrorCallback?)
    
    /**
     Delete a like
     - Parameters:
        - likeId: ID of like to be deleted
        - onSuccess: callback function with JSON parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func deleteLike(withLikeId likeId: UInt32,
                    onSuccess: JSONCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
}
