//
//  UserRequests.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class CredentialRequests: Requests, CredentialRequestsProtocol {
    func requestLoginWith(username: String, password: String,
                          onSuccess: UserCallbackWithToken? = nil,
                          onFailure: JSONCallback? = nil,
                          onRequestError: ErrorCallback? = nil) {
        let urlString = "\(baseURL)/login"
        let parameters: Parameters = [
            "username" : username,
            "password" : password,
        ]
        
        executeJSON(urlString: urlString, method: .post, parameters: parameters,
                    onSuccess: { json in
                        let apiToken = json["data"]["user"]["api_token"].stringValue
                        onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
        
    }
    
    func requestLoginWith(email: String, password: String,
                          onSuccess: UserCallbackWithToken? = nil,
                          onFailure: JSONCallback? = nil,
                          onRequestError: ErrorCallback? = nil) {
        let urlString = "\(baseURL)/login"
        let parameters: Parameters = [
            "email" : email,
            "password" : password,
        ]
        
        executeJSON(urlString: urlString, method: .post, parameters: parameters,
                    onSuccess: { json in
                        let apiToken = json["data"]["user"]["api_token"].stringValue
                        onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func requestRegisterWith(username: String, email: String,
                             password: String, passwordConfirmation: String,
                             gender: String, birthday: String,
                             onSuccess: UserCallbackWithToken? = nil,
                             onFailure: JSONCallback? = nil,
                             onRequestError: ErrorCallback? = nil) {
        let urlString = "\(baseURL)/register"
        let parameters: Parameters = [
            "username" : username,
            "email" : email,
            "password" : password,
            "password_confirmation" : passwordConfirmation,
            "gender" : gender,
            "birthday" : birthday
        ]
        
        executeJSON(urlString: urlString, method: .post, parameters: parameters,
                    onSuccess: { json in
                        let apiToken = json["data"]["user"]["api_token"].stringValue
                        onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func requestOAuthLoginWith(email: String, oauthType: String,
                               accessToken: String,
                               onSuccess: UserCallbackWithToken? = nil,
                               onFailure: JSONCallback? = nil,
                               onRequestError: ErrorCallback? = nil) {
        let urlString = "\(baseURL)/oauth/login"
        let parameters: Parameters = [
            "email" : email,
            "oauth_type" : oauthType
        ]
        let headers: HTTPHeaders = [
            "Authorization" : "bearer \(accessToken)"
        ]
        
        executeJSON(urlString: urlString, method: .post, parameters: parameters,
                    headers: headers,
                    onSuccess: { json in
                        let apiToken = json["data"]["user"]["api_token"].stringValue
                        onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func requestOAuthRegisterWith(username: String, email: String,
                                  firstName: String, lastName: String,
                                  gender: String, oauthType: String,
                                  accessToken: String,
                                  onSuccess: UserCallbackWithToken? = nil,
                                  onFailure: JSONCallback? = nil,
                                  onRequestError: ErrorCallback? = nil) {
        let urlString = "\(baseURL)/oauth/register"
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
        
        executeJSON(urlString: urlString, method: .post, parameters: parameters,
                    headers: headers,
                    onSuccess: { json in
                        let apiToken = json["data"]["user"]["api_token"].stringValue
                        onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func requestOAuthMergeAccount(email: String, oauthType: String,
                                  accessToken: String,
                                  onSuccess: UserCallbackWithToken? = nil,
                                  onFailure: JSONCallback? = nil,
                                  onRequestError: ErrorCallback? = nil) {
        let urlString = "\(baseURL)/oauth/login"
        let parameters: Parameters = [
            "email" : email,
            "oauth_type" : oauthType,
            "merge" : true
        ]
        let headers: HTTPHeaders = [
            "Authorization" : "bearer \(accessToken)"
        ]
        
        executeJSON(urlString: urlString, method: .post, parameters: parameters,
                    headers: headers,
                    onSuccess: { json in
                        let apiToken = json["data"]["user"]["api_token"].stringValue
                        onSuccess?(User(json: json["data"]["user"]), apiToken)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func requestValidateEmail(email: String,
                              onSuccess: JSONCallback? = nil,
                              onFailure: JSONCallback? = nil,
                              onRequestError: ErrorCallback? = nil) {
        let urlString = "\(baseURL)/email_taken/\(email)"
        
        executeJSON(urlString: urlString, method: .get,
                    onSuccess: { json in
                        let data = json["data"]
                        onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func requestValidateUsername(username: String,
                                 onSuccess: JSONCallback? = nil,
                                 onFailure: JSONCallback? = nil,
                                 onRequestError: ErrorCallback? = nil) {
        let urlString = "\(baseURL)/username_taken/\(username)"
        
        executeJSON(urlString: urlString, method: .get,
                    onSuccess: { json in
                        let data = json["data"]
                        onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func requestResetPassword(email: String,
                              onSuccess: JSONCallback? = nil,
                              onFailure: JSONCallback? = nil,
                              onRequestError: ErrorCallback? = nil) {
        let urlString = "\(baseURL)/password/send_reset_password"
        let parameters: Parameters = [
            "email" : email
        ]
        
        executeJSON(urlString: urlString, method: .post, parameters: parameters,
                    onSuccess: { json in
                        let data = json["data"]
                        onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
    func requestResetPassword(username: String,
                              onSuccess: JSONCallback? = nil,
                              onFailure: JSONCallback? = nil,
                              onRequestError: ErrorCallback? = nil) {
        let urlString = "\(baseURL)/password/send_reset_password"
        let parameters: Parameters = [
            "username" : username
        ]
        
        executeJSON(urlString: urlString, method: .post, parameters: parameters,
                    onSuccess: { json in
                        let data = json["data"]
                        onSuccess?(data)
        }, onFailure: onFailure, onRequestError: onRequestError)
    }
    
}
