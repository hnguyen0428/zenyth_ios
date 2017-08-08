//
//  CrendentialManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

protocol CredentialManagerProtocol {
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

