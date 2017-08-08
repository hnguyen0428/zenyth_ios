//
//  LikeRequestsProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol LikeManagerProtocol {
    func createLike(onPinpostId pinpostId: UInt32,
                    onSuccess: LikeCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
    
    func createLike(onCommentId commentId: UInt32,
                    onSuccess: LikeCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
    
    func createLike(onReplyId replyId: UInt32,
                    onSuccess: LikeCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
    
    func readLike(withLikeId likeId: UInt32,
                  onSuccess: LikeCallback?,
                  onFailure: JSONCallback?,
                  onRequestError: ErrorCallback?)
    
    func deleteLike(withLikeId likeId: UInt32,
                    onSuccess: JSONCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
}
