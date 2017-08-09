//
//  UserManager.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class UserManager: UserManagerProtocol {
    func getFriends(ofUserId userId: UInt32,
                    onSuccess: UsersCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func getBlockedUsers(onSuccess: UsersCallback? = nil,
                         onFailure: JSONCallback? = nil,
                         onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func getFriendRequests(onSuccess: UsersCallback? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func readProfile(ofUserId userId: UInt32,
                     onSuccess: UserCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func updateProfile(firstName: String? = nil, lastName: String? = nil,
                       gender: String? = nil, birthday: String? = nil,
                       onSuccess: UserCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func updateProfilePicture(imageData: Data,
                              onSuccess: UserCallback? = nil,
                              onFailure: JSONCallback? = nil,
                              onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func searchUser(withKeyword keyword: String,
                    onSuccess: UsersCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
}
