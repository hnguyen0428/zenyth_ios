//
//  ReplyManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol ReplyManagerProtocol {
    func createReply(onCommentId commentId: UInt32, text: String,
                     onSuccess: ReplyCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    func uploadImage(toReplyId replyId: UInt32, imageData: Data,
                     onSuccess: ImageCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    func updateReply(withReplyId replyId: UInt32, text: String,
                     onSuccess: ReplyCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    func readReplyInfo(withReplyId replyId: UInt32, text: String,
                   onSuccess: ReplyCallback?,
                   onFailure: JSONCallback?,
                   onRequestError: ErrorCallback?)
    
    func readReplyImages(withReplyId replyId: UInt32,
                         onSuccess: ImagesCallback?,
                         onFailure: JSONCallback?,
                         onRequestError: ErrorCallback?)
    
    func deleteReply(withReplyId replyId: UInt32,
                     onSuccess: JSONCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    func getLikes(onReplyId replyId: UInt32,
                  onSuccess: LikesCallback?,
                  onFailure: JSONCallback?,
                  onRequestError: ErrorCallback?)
}
