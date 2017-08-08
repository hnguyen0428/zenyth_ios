//
//  Endpoint.swift
//  Zenyth
//
//  Created by Hoang on 8/8/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import Alamofire

let baseURL = "http://54.219.134.56/api"
typealias APIRoute = (String, HTTPMethod)

public enum Endpoint {
    case Register
    case OAuthRegister
    case OAuthMergeAccount
    
    case Login
    case OAuthLogin
    case ValidateUsername(String)
    case ValidateEmail(String)
    case SendResetPasswordEmail
    
    func route() -> APIRoute {
        switch self {
        case .Register:
            return ("\(baseURL)/register", .post)
        case .OAuthRegister:
            return ("\(baseURL)/oauth/register", .post)
        case .Login:
            return ("\(baseURL)/login", .post)
        case .OAuthLogin:
            return ("\(baseURL)/oauth/login", .post)
        case .ValidateEmail(let email):
            return ("\(baseURL)/email_taken/\(email)", .get)
        case .ValidateUsername(let username):
            return ("\(baseURL)/username_taken/\(username)", .get)
        case .SendResetPasswordEmail:
            return ("\(baseURL)/password/send_reset_password", .post)
        }
    }
}
