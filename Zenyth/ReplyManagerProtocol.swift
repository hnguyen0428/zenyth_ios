//
//  ReplyRequestsProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol ReplyManagerProtocol {
    func requestCreateReplyOn(commentId: UInt32, text: String,
                              onSuccess: ReplyCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    func requestUploadImageTo(replyId: UInt32, imageData: Data,
                              onSuccess: ImageCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    func requestUpdateReplyWith(replyId: UInt32, text: String,
                                onSuccess: ReplyCallback?,
                                onFailure: JSONCallback?,
                                onRequestError: ErrorCallback?)
    
    func requestReadReplyWith(replyId: UInt32, text: String,
                              onSuccess: ReplyCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    func requestReadReplyImages(replyId: UInt32,
                                onSuccess: ImagesCallback?,
                                onFailure: JSONCallback?,
                                onRequestError: ErrorCallback?)
    
    func requestDeleteReplyWith(replyId: UInt32,
                                onSuccess: JSONCallback?,
                                onFailure: JSONCallback?,
                                onRequestError: ErrorCallback?)
    
    func requestGetLikesOn(replyId: UInt32,
                           onSuccess: LikesCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
}
