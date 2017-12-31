//
//  LoginManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/8/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol LoginManagerProtocol {
    /**
     Login a user
     - Parameters:
        - username: username of user
        - password: password of user
        - onSuccess: callback function with User and api token parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func login(withUsername username: String,
               password: String,
               onSuccess: UserCallbackWithToken?,
               onFailure: JSONCallback?,
               onRequestError: ErrorCallback?)
    
    /**
     Login a user
     - Parameters:
        - email: email of user
        - password: password of user
        - onSuccess: callback function with User and api token parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func login(withEmail email: String,
               password: String,
               onSuccess: UserCallbackWithToken?,
               onFailure: JSONCallback?,
               onRequestError: ErrorCallback?)
    
    /**
     Login a user
     - Parameters:
        - email: email of user
        - oauthType: oauth type
        - accessToken: oauth token
        - onSuccess: callback function with User and api token parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func oauthLogin(withEmail email: String, oauthType: String,
                    accessToken: String,
                    onSuccess: UserCallbackWithToken?,
                    onFailure: JSONCallback?,
                    onRequestError: ErrorCallback?)
}
