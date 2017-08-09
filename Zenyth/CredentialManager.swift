//
//  CredentialManager.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class CredentialManager: APIClient, CredentialManagerProtocol {
    func validateEmail(email: String,
                       onSuccess: JSONCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        executeJSON(route: Endpoint.ValidateEmail(email).route(),
                    onSuccess: { json in
                        let data = json["data"]
                        onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func validateUsername(username: String,
                          onSuccess: JSONCallback? = nil,
                          onFailure: JSONCallback? = nil,
                          onRequestError: ErrorCallback? = nil) {
        executeJSON(route: Endpoint.ValidateUsername(username).route(),
                    onSuccess: { json in
                        let data = json["data"]
                        onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func sendResetPassword(toEmail email: String,
                           onSuccess: JSONCallback? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        let parameters: Parameters = [
            "email" : email
        ]
        
        executeJSON(route: Endpoint.SendResetPasswordEmail.route(),
                    parameters: parameters,
                    onSuccess: { json in
                        let data = json["data"]
                        onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func sendResetPassword(toUsername username: String,
                           onSuccess: JSONCallback? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        let parameters: Parameters = [
            "username" : username
        ]
        
        executeJSON(route: Endpoint.SendResetPasswordEmail.route(),
                    parameters: parameters,
                    onSuccess: { json in
                        let data = json["data"]
                        onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
}