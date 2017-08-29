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
    func getFollowers(ofUserId userId: UInt32,
                      onSuccess: UsersCallback? = nil,
                      onFailure: JSONCallback? = nil,
                      onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetFollowers(userId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let usersJSON = json["data"]["users"].arrayValue
                var friends = [User]()
                for userJSON in usersJSON {
                    friends.append(User(json: userJSON))
                }
                onSuccess?(friends)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func getBlockedUsers(onSuccess: UsersCallback? = nil,
                         onFailure: JSONCallback? = nil,
                         onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetBlockedUsers.route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let usersJSON = json["data"]["users"].arrayValue
                var blockedUsers = [User]()
                for userJSON in usersJSON {
                    blockedUsers.append(User(json: userJSON))
                }
                onSuccess?(blockedUsers)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func getFollowerRequests(onSuccess: UsersCallback? = nil,
                             onFailure: JSONCallback? = nil,
                             onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.GetFollowerRequests.route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let usersJSON = json["data"]["users"].arrayValue
                var friendRequesters = [User]()
                for userJSON in usersJSON {
                    friendRequesters.append(User(json: userJSON))
                }
                onSuccess?(friendRequesters)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func readProfile(ofUserId userId: UInt32,
                     onSuccess: UserCallback? = nil,
                     onFailure: JSONCallback? = nil,
                     onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.ReadProfile(userId).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                let userJSON = json["data"]["user"]
                onSuccess?(User(json: userJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func updateProfile(firstName: String? = nil, lastName: String? = nil,
                       gender: String? = nil, birthday: String? = nil,
                       biography: String? = nil,
                       onSuccess: UserCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.UpdateProfile.route()
        APIClient.sharedClient.setAuthorization()
        
        var parameters: Parameters = Parameters.init()
        if firstName != nil {
            parameters.updateValue(firstName!, forKey: "first_name")
        }
        if lastName != nil {
            parameters.updateValue(lastName!, forKey: "last_name")
        }
        if gender != nil {
            parameters.updateValue(gender!, forKey: "gender")
        }
        if birthday != nil {
            parameters.updateValue(birthday!, forKey: "birthday")
        }
        if biography != nil {
            parameters.updateValue(biography!, forKey: "biography")
        }
        
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let userJSON = json["data"]["user"]
                onSuccess?(User(json: userJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func updatePrivacy(emailPrivacy: String? = nil, genderPrivacy: String? = nil,
                       birthdayPrivacy: String? = nil, followPrivacy: String? = nil,
                       onSuccess: UserCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.UpdateProfile.route()
        APIClient.sharedClient.setAuthorization()
        
        var parameters: Parameters = Parameters.init()
        if emailPrivacy != nil {
            parameters.updateValue(emailPrivacy!, forKey: "email_privacy")
        }
        if genderPrivacy != nil {
            parameters.updateValue(genderPrivacy!, forKey: "gender_privacy")
        }
        if birthdayPrivacy != nil {
            parameters.updateValue(birthdayPrivacy!, forKey: "birthday_privacy")
        }
        if followPrivacy != nil {
            parameters.updateValue(followPrivacy!, forKey: "follow_privacy")
        }
        
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let userJSON = json["data"]["user"]
                onSuccess?(User(json: userJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func updateProfilePicture(imageData: Data,
                              onSuccess: UserCallback? = nil,
                              onFailure: JSONCallback? = nil,
                              onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.UpdateProfilePicture.route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeUpload(route: route, data: imageData,
                                             fileKey: "image",
                                             onSuccess:
            { json in
                let userJSON = json["data"]["user"]
                onSuccess?(User(json: userJSON))
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func searchUser(withKeyword keyword: String,
                    onSuccess: UsersCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.SearchUser.route()
        APIClient.sharedClient.setAuthorization()
        
        let parameters = ["keyword" : keyword]
        
        APIClient.sharedClient.executeJSON(route: route, parameters: parameters,
                                           onSuccess:
            { json in
                let usersJSON = json["data"]["users"].arrayValue
                var users = [User]()
                for userJSON in usersJSON {
                    users.append(User(json: userJSON))
                }
                onSuccess?(users)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func deleteUser(withUsername username: String,
                    onSuccess: JSONCallback? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.DeleteUser(username).route()
        APIClient.sharedClient.setAuthorization()
        
        APIClient.sharedClient.executeJSON(route: route,
                                           onSuccess:
            { json in
                onSuccess?(json)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
}
