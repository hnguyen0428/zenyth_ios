//
//  UserManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol UserManagerProtocol {
    /**
     Get friends of user with user ID
     - Parameters:
        - userId: ID of user to be looked up
        - onSuccess: callback function with [User] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func getFriends(ofUserId userId: UInt32,
                    onSuccess: UsersCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
    
    /**
     Get blocked users of the person logged in
     - Parameters:
        - onSuccess: callback function with [User] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func getBlockedUsers(onSuccess: UsersCallback?,
                         onFailure: JSONCallback?,
                         onRequestError: ErrorCallback?)
    
    /**
     Get friend requesters of the person logged in
     - Parameters:
        - onSuccess: callback function with [User] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func getFriendRequests(onSuccess: UsersCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    /**
     Get profile information of the user with user ID
     - Parameters:
        - userId: ID of user to be looked up
        - onSuccess: callback function with User parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func readProfile(ofUserId userId: UInt32,
                     onSuccess: UserCallback?,
                     onFailure: JSONCallback?,
                     onRequestError: ErrorCallback?)
    
    /**
     Update profile of the person logged in
     - Parameters:
        - firstName: first name to be changed to
        - lastName: last name to be changed to
        - gender: gender to be changed to
        - birthday: birthday to be changed to
        - onSuccess: callback function with User parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func updateProfile(firstName: String?, lastName: String?,
                       gender: String?, birthday: String?,
                       onSuccess: UserCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    /**
     Update profile picture of the person logged in
     - Parameters:
        - imageData: image data that is to be used as profile picture
        - onSuccess: callback function with User parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func updateProfilePicture(imageData: Data,
                              onSuccess: UserCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    /**
     Search for users with a keyword
     - Parameters:
        - keyword: search query
        - onSuccess: callback function with [User] parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func searchUser(withKeyword keyword: String,
                    onSuccess: UsersCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
    
    /**
     Delete the person logged in account
     - Parameters:
        - username: username of the user logged in
        - onSuccess: callback function with JSON parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */

    func deleteUser(withUsername username: String,
                    onSuccess: JSONCallback?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
}
