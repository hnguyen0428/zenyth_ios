//
//  ZenythAPIClient.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

protocol CredentialRequestsProtocol {
    func requestLoginWith(username: String,
                          password: String,
                          onSuccess: UserCallbackWithToken?,
                          onFailure: JSONCallback?,
                          onRequestError: ErrorCallback?)
    
    func requestLoginWith(email: String,
                          password: String,
                          onSuccess: UserCallbackWithToken?,
                          onFailure: JSONCallback?,
                          onRequestError: ErrorCallback?)
    
    func requestRegisterWith(username: String, email: String,
                             password: String, passwordConfirmation: String,
                             gender: String, birthday: String,
                             onSuccess: UserCallbackWithToken?,
                             onFailure: JSONCallback?,
                             onRequestError: ErrorCallback?)
    
    func requestOAuthLoginWith(email: String, oauthType: String,
                               accessToken: String,
                               onSuccess: UserCallbackWithToken?,
                               onFailure: JSONCallback?,
                               onRequestError: ErrorCallback?)
    
    func requestOAuthRegisterWith(username: String, email: String,
                                  firstName: String, lastName: String,
                                  gender: String, oauthType: String,
                                  accessToken: String,
                                  onSuccess: UserCallbackWithToken?,
                                  onFailure: JSONCallback?,
                                  onRequestError: ErrorCallback?)
    
    func requestOAuthMergeAccount(email: String, oauthType: String,
                                  accessToken:String,
                                  onSuccess: UserCallbackWithToken?,
                                  onFailure: JSONCallback?,
                                  onRequestError: ErrorCallback?)
    
    func requestValidateEmail(email: String,
                              onSuccess: JSONCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    func requestValidateUsername(username: String,
                                 onSuccess: JSONCallback?,
                                 onFailure: JSONCallback?,
                                 onRequestError: ErrorCallback?)
    
    func requestResetPassword(username: String,
                              onSuccess: JSONCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
    
    func requestResetPassword(email: String,
                              onSuccess: JSONCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
}

