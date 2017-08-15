//
//  CrendentialManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

protocol CredentialManagerProtocol {
    /**
     Validate if the email has been taken
     - Parameters:
        - email: email to be validated
        - onSuccess: callback function with JSON parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func validateEmail(email: String,
                       onSuccess: JSONCallback?,
                       onFailure: JSONCallback?,
                       onRequestError: ErrorCallback?)
    
    /**
     Validate if the username has been taken
     - Parameters:
        - username: username to be validated
        - onSuccess: callback function with JSON parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func validateUsername(username: String,
                          onSuccess: JSONCallback?,
                          onFailure: JSONCallback?,
                          onRequestError: ErrorCallback?)
    
    /**
     Send reset password email to account
     - Parameters:
        - username: username of the account to be sent to
        - onSuccess: callback function with JSON parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func sendResetPassword(toUsername username: String,
                           onSuccess: JSONCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    /**
     Send reset password email to account
     - Parameters:
        - email: email of the account to be sent to
        - onSuccess: callback function with JSON parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func sendResetPassword(toEmail email: String,
                           onSuccess: JSONCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
}

