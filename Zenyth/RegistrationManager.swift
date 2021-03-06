//
//  RegistrationManager.swift
//  Zenyth
//
//  Created by Hoang on 8/8/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RegistrationManager: RegistrationManagerProtocol {
    func register(withUsername username: String, email: String,
                  password: String, passwordConfirmation: String,
                  gender: String, birthday: String,
                  onSuccess: UserCallbackWithToken? = nil,
                  onFailure: JSONCallback? = nil,
                  onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.Register.route()
        let parameters: Parameters = [
            "username" : username,
            "email" : email,
            "password" : password,
            "password_confirmation" : passwordConfirmation,
            "gender" : gender,
            "birthday" : birthday
        ]
        
        APIClient.sharedClient.executeJSON(route: route,
                                           parameters: parameters, onSuccess:
            { json in
                let apiToken = json["data"]["user"]["api_token"].stringValue
                let userJSON = json["data"]["user"]
                onSuccess?(User(json: userJSON), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    
    
    func oauthRegister(withUsername username: String, email: String,
                       firstName: String, lastName: String,
                       gender: String, oauthType: String,
                       accessToken: String,
                       onSuccess: UserCallbackWithToken? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.OAuthRegister.route()
        let parameters: Parameters = [
            "email" : email,
            "username" : username,
            "first_name" : firstName,
            "last_name" : lastName,
            "gender" : gender,
            "oauth_type" : oauthType
        ]
        
        APIClient.sharedClient.setAuthorization(token: accessToken)
        
        APIClient.sharedClient.executeJSON(route: route,
                                           parameters: parameters,
                                           onSuccess:
            { json in
                let apiToken = json["data"]["user"]["api_token"].stringValue
                let userJSON = json["data"]["user"]
                onSuccess?(User(json: userJSON), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func oauthMergeAccount(withEmail email: String, oauthType: String,
                           accessToken: String,
                           onSuccess: UserCallbackWithToken? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.OAuthLogin.route()
        let parameters: Parameters = [
            "email" : email,
            "oauth_type" : oauthType,
            "merge" : true
        ]

        APIClient.sharedClient.setAuthorization(token: accessToken)
        
        APIClient.sharedClient.executeJSON(route: route,
                                           parameters: parameters,
                                           onSuccess:
            { json in
                let apiToken = json["data"]["user"]["api_token"].stringValue
                let userJSON = json["data"]["user"]
                onSuccess?(User(json: userJSON), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
}
