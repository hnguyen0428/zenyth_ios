//
//  LoginManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/8/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol LoginManagerProtocol {
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
    
    func oauthLogin(withEmail email: String, oauthType: String,
                    accessToken: String,
                    onSuccess: UserCallbackWithToken?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
}
