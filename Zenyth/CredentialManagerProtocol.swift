//
//  ZenythAPIClient.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

protocol CredentialManagerProtocol {
    func login(withUsername username: String,
               password: String,
               onSuccess: UserCallbackWithToken?,
               onFailure: JSONCallback?,
               onRequestError: ErrorCallback?)
    
    func login(withEmail email: String,
               password: String,
               onSuccess: UserCallbackWithToken?,
               onFailure: JSONCallback?,
               onRequestError: ErrorCallback?)
    
    func register(withUsername username: String, email: String,
                  password: String, passwordConfirmation: String,
                  gender: String, birthday: String,
                  onSuccess: UserCallbackWithToken?,
                  onFailure: JSONCallback?,
                      onRequestError: ErrorCallback?)
    
    func oauthLogin(withEmail email: String, oauthType: String,
                    accessToken: String,
                    onSuccess: UserCallbackWithToken?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
    
    func oauthRegister(withUsername username: String, email: String,
                       firstName: String, lastName: String,
                       gender: String, oauthType: String,
                       accessToken: String,
                       onSuccess: UserCallbackWithToken?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    func oauthMergeAccount(withEmail email: String, oauthType: String,
                           accessToken:String,
                           onSuccess: UserCallbackWithToken?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    func validateEmail(email: String,
                       onSuccess: JSONCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    func validateUsername(username: String,
                          onSuccess: JSONCallback?,
                          onFailure: JSONCallback?,
                          onRequestError: ErrorCallback?)
    
    func sendResetPassword(toUsername username: String,
                           onSuccess: JSONCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    func sendResetPassword(toEmail email: String,
                           onSuccess: JSONCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
}

