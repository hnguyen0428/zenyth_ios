//
//  RegistrationManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/8/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol RegistrationManagerProtocol {
    func register(withUsername username: String, email: String,
                  password: String, passwordConfirmation: String,
                  gender: String, birthday: String,
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
}
