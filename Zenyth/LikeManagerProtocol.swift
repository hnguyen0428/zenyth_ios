//
//  LikeRequestsProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol LikeManagerProtocol {
    func requestCreateLikeOn(pinpostId: UInt32,
                             onSuccess: LikeCallback?,
                             onFailure: JSONCallback?,
                             onRequestError: ErrorCallback?)
    
    func requestCreateLikeOn(commentId: UInt32,
                             onSuccess: LikeCallback?,
                             onFailure: JSONCallback?,
                             onRequestError: ErrorCallback?)
    
    func requestCreateLikeOn(replyId: UInt32,
                             onSuccess: LikeCallback?,
                             onFailure: JSONCallback?,
                             onRequestError: ErrorCallback?)
    
    func requestReadLikeWith(likeId: UInt32,
                             onSuccess: LikeCallback?,
                             onFailure: JSONCallback?,
                             onRequestError: ErrorCallback?)
    
    func requestDeleteLikeWith(likeId: UInt32,
                               onSuccess: JSONCallback?,
                               onFailure: JSONCallback?,
                               onRequestError: ErrorCallback?)
}
