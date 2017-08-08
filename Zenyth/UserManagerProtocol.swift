//
//  UserManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol UserManagerProtocol {
    func getFriends(ofUserId userId: UInt32,
                    onSuccess: UsersCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
    
    func getBlockedUsers(onSuccess: UsersCallback?,
                         onFailure: JSONCallback?,
                         onRequestError: ErrorCallback?)
    
    func getFriendRequests(onSuccess: UsersCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    func readProfile(ofUserId userId: UInt32,
                     onSuccess: UserCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    func updateProfile(firstName: String?, lastName: String?,
                       gender: String?, birthday: String?,
                       onSuccess: UserCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    func updateProfilePicture(imageData: Data,
                              onSuccess: UserCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    func searchUser(withKeyword keyword: String,
                    onSuccess: UsersCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
}
