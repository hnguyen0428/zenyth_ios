//
//  CredentialManager.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class CredentialManager: CredentialManagerProtocol {
    func validateEmail(email: String,
                       onSuccess: JSONCallback? = nil,
                       onFailure: JSONCallback? = nil,
                       onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.ValidateEmail(email).route()
        APIClient.sharedClient.executeJSON(route: route, onSuccess:
            { json in
                let data = json["data"]
                onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func validateUsername(username: String,
                          onSuccess: JSONCallback? = nil,
                          onFailure: JSONCallback? = nil,
                          onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.ValidateUsername(username).route()
        APIClient.sharedClient.executeJSON(route: route, onSuccess:
            { json in
                let data = json["data"]
                onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func sendResetPassword(toEmail email: String,
                           onSuccess: JSONCallback? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.SendResetPasswordEmail.route()
        let parameters: Parameters = [
            "email" : email
        ]
        
        APIClient.sharedClient.executeJSON(route: route,
                                           parameters: parameters, onSuccess:
            { json in
                let data = json["data"]
                onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func sendResetPassword(toUsername username: String,
                           onSuccess: JSONCallback? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        let route = Endpoint.SendResetPasswordEmail.route()
        let parameters: Parameters = [
            "username" : username
        ]
        
        APIClient.sharedClient.executeJSON(route: route,
                                           parameters: parameters, onSuccess:
            { json in
                let data = json["data"]
                onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
}
