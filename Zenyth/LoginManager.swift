//
//  LoginManager.swift
//  Zenyth
//
//  Created by Hoang on 8/8/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoginManager: LoginManagerProtocol {
    func login(withUsername username: String, password: String,
               onSuccess: UserCallbackWithToken? = nil,
               onFailure: JSONCallback? = nil,
               onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.Login.route()
        let parameters: Parameters = [
            "username" : username,
            "password" : password,
        ]
        
        APIClient.sharedClient.executeJSON(route: route,
                                           parameters: parameters,
                                           onSuccess:
            { json in
                let apiToken = json["data"]["user"]["api_token"].stringValue
                let userJSON = json["data"]["user"]
                onSuccess?(User(json: userJSON), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
        
    }
    
    func login(withEmail email: String, password: String,
               onSuccess: UserCallbackWithToken? = nil,
               onFailure: JSONCallback? = nil,
               onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.Login.route()
        let parameters: Parameters = [
            "email" : email,
            "password" : password,
        ]
        
        APIClient.sharedClient.executeJSON(route: route,
                                           parameters: parameters, onSuccess:
            { json in
                let apiToken = json["data"]["user"]["api_token"].stringValue
                let userJSON = json["data"]["user"]
                onSuccess?(User(json: userJSON), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func oauthLogin(withEmail email: String, oauthType: String,
                    accessToken: String,
                    onSuccess: UserCallbackWithToken? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.OAuthLogin.route()
        let parameters: Parameters = [
            "email" : email,
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
}
