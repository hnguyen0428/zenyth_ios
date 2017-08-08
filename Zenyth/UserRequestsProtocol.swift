//
//  UserRequestsProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol UserRequestsProtocol {
    func requestGetFriends(userId: UInt32,
                           onSuccess: UsersCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    func requestGetBlockedUsers(onSuccess: UsersCallback?,
                                onFailure: JSONCallback?,
                                onRequestError: ErrorCallback?)
    
    func requestGetFriendRequests(onSuccess: UsersCallback?,
                                  onFailure: JSONCallback?,
                                  onRequestError: ErrorCallback?)
    
    func requestReadProfile(userId: UInt32,
                            onSuccess: UserCallback?,
                            onFailure: JSONCallback?,
                            onRequestError: ErrorCallback?)
    
    func requestUpdateProfile(onSuccess: UserCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    func requestUpdateProfilePicture(imageData: Data,
                                     onSuccess: UserCallback?,
                                     onFailure: JSONCallback?,
                                     onRequestError: ErrorCallback?)
    
    func requestSearchUser(keyword: String,
                           onSuccess: UsersCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
}
