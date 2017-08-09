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
        let parameters: Parameters = [
            "username" : username,
            "password" : password,
        ]
        
        APIClient.sharedClient.executeJSON(route: Endpoint.Login.route(),
                                           parameters: parameters,
                                           onSuccess:
            { json in
                let apiToken = json["data"]["user"]["api_token"].stringValue
                onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
        
    }
    
    func login(withEmail email: String, password: String,
               onSuccess: UserCallbackWithToken? = nil,
               onFailure: JSONCallback? = nil,
               onRequestError: ErrorCallback? = nil) {
        let parameters: Parameters = [
            "email" : email,
            "password" : password,
        ]
        
        APIClient.sharedClient.executeJSON(route: Endpoint.Login.route(),
                                           parameters: parameters, onSuccess:
            { json in
                let apiToken = json["data"]["user"]["api_token"].stringValue
                onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func oauthLogin(withEmail email: String, oauthType: String,
                    accessToken: String,
                    onSuccess: UserCallbackWithToken? = nil,
                    onFailure: JSONCallback? = nil,
                    onRequestError: ErrorCallback? = nil) {
        let parameters: Parameters = [
            "email" : email,
            "oauth_type" : oauthType
        ]
        APIClient.sharedClient.updateHeaders(value: "Authorization",
                                             forKey: "bearer \(accessToken)")
        
        APIClient.sharedClient.executeJSON(route: Endpoint.OAuthLogin.route(),
                                           parameters: parameters,
                                           onSuccess:
            { json in
                let apiToken = json["data"]["user"]["api_token"].stringValue
                onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
}
