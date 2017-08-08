//
//  CommentRequestsProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol CommentRequestsProtocol {
    func requestCreateCommentOn(pinpostId: UInt32, text: String,
                                onSuccess: CommentCallback?,
                                onFailure: JSONCallback?,
                                onRequestError: ErrorCallback?)
    
    func requestUploadImageTo(commentId: UInt32, imageData: Data,
                              onSuccess: ImageCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    func requestUpdateCommentWith(commentId: UInt32, text: String,
                                  onSuccess: CommentCallback?,
                                  onFailure: JSONCallback?,
                                  onRequestError: ErrorCallback?)
    
    func requestReadCommentWith(commentId: UInt32, text: String,
                                onSuccess: CommentCallback?,
                                onFailure: JSONCallback?,
                                onRequestError: ErrorCallback?)
    
    func requestReadCommentImages(commentId: UInt32,
                                  onSuccess: ImagesCallback?,
                                  onFailure: JSONCallback?,
                                  onRequestError: ErrorCallback?)
    
    func requestDeleteCommentWith(commentId: UInt32,
                                  onSuccess: JSONCallback?,
                                  onFailure: JSONCallback?,
                                  onRequestError: ErrorCallback?)
    
    func requestGetLikesOn(commentId: UInt32,
                           onSuccess: LikesCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
}
