//
//  CommentManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol CommentManagerProtocol {
    func createComment(onPinpostId pinpostId: UInt32, text: String,
                       onSuccess: CommentCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    func uploadImage(toCommentId commentId: UInt32, imageData: Data,
                     onSuccess: ImageCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    func updateComment(withCommentId commentId: UInt32, text: String,
                       onSuccess: CommentCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    func readCommentInfo(withCommentId commentId: UInt32, text: String,
                         onSuccess: CommentCallback?,
                         onFailure: JSONCallback?,
                         onRequestError: ErrorCallback?)
    
    func readCommentImages(withCommentId commentId: UInt32,
                           onSuccess: ImagesCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    func deleteComment(withCommentId commentId: UInt32,
                       onSuccess: JSONCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    func getLikes(onCommentId commentId: UInt32,
                  onSuccess: LikesCallback?,
                  onFailure: JSONCallback?,
                  onRequestError: ErrorCallback?)
}
