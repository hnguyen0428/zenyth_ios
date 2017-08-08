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

class RegistrationManager: APIClient, RegistrationManagerProtocol {
    func register(withUsername username: String, email: String,
                  password: String, passwordConfirmation: String,
                  gender: String, birthday: String,
                  onSuccess: UserCallbackWithToken? = nil,
                  onFailure: JSONCallback? = nil,
                  onRequestError: ErrorCallback? = nil) {
        let parameters: Parameters = [
            "username" : username,
            "email" : email,
            "password" : password,
            "password_confirmation" : passwordConfirmation,
            "gender" : gender,
            "birthday" : birthday
        ]
        
        executeJSON(route: Endpoint.Register.route(), parameters: parameters,
                    onSuccess: { json in
                        let apiToken = json["data"]["user"]["api_token"].stringValue
                        onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    
    
    func oauthRegister(withUsername username: String, email: String,
                       firstName: String, lastName: String,
                       gender: String, oauthType: String,
                       accessToken: String,
                       onSuccess: UserCallbackWithToken? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let parameters: Parameters = [
            "email" : email,
            "username" : username,
            "first_name" : firstName,
            "last_name" : lastName,
            "gender" : gender,
            "oauth_type" : oauthType
        ]
        let headers: HTTPHeaders = [
            "Authorization" : "bearer \(accessToken)"
        ]
        
        executeJSON(route: Endpoint.OAuthRegister.route(), parameters: parameters,
                    headers: headers,
                    onSuccess: { json in
                        let apiToken = json["data"]["user"]["api_token"].stringValue
                        onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func oauthMergeAccount(withEmail email: String, oauthType: String,
                           accessToken: String,
                           onSuccess: UserCallbackWithToken? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        let parameters: Parameters = [
            "email" : email,
            "oauth_type" : oauthType,
            "merge" : true
        ]
        let headers: HTTPHeaders = [
            "Authorization" : "bearer \(accessToken)"
        ]
        
        executeJSON(route: Endpoint.OAuthLogin.route(), parameters: parameters,
                    headers: headers,
                    onSuccess: { json in
                        let apiToken = json["data"]["user"]["api_token"].stringValue
                        onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
}
