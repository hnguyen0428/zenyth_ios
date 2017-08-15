//
//  RegistrationManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/8/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol RegistrationManagerProtocol {
    /**
     Register a User
     - Parameters:
        - username: username of user
        - email: email of user
        - password: password of user
        - passwordConfirmation: password confirmation
        - gender: gender of user
        - birthday: birthday of user
        - onSuccess: callback function with User and api token parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func register(withUsername username: String, email: String,
                  password: String, passwordConfirmation: String,
                  gender: String, birthday: String,
                  onSuccess: UserCallbackWithToken?,
                  onFailure: JSONCallback?,
                  onRequestError: ErrorCallback?)
    
    /**
     Register a User with Oauth
     - Parameters:
        - username: username of user
        - email: email of user
        - firstName: first name of user
        - lastName: last name of user
        - gender: gender of user
        - oauthType: oauth type
        - onSuccess: callback function with User and api token parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func oauthRegister(withUsername username: String, email: String,
                       firstName: String, lastName: String,
                       gender: String, oauthType: String,
                       accessToken: String,
                       onSuccess: UserCallbackWithToken?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    /**
     Merge an oauth account to existing account
     - Parameters:
        - email: email of user
        - oauthType: oauth type
        - accessToken: oauth token
        - onSuccess: callback function with User and api token parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func oauthMergeAccount(withEmail email: String, oauthType: String,
                           accessToken:String,
                           onSuccess: UserCallbackWithToken?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
}
