//
//  RegisterRequestor.swift
//  Zenyth
//
//  Created by Hoang on 7/12/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class RegisterRequestor: Requestor {
    let registerRoute = Route(method: .post, urlString: "\(serverAddress)/api/register")
    
    init(parameters: Parameters) {
        super.init(route: self.registerRoute, parameters: parameters)
    }
}

class EmailTakenRequestor: Requestor {
    var emailTakenRoute = Route(method: .get, urlString: "\(serverAddress)/api/email_taken/%@")
    
    init(email: String) {
        emailTakenRoute.urlString = String(format: emailTakenRoute.urlString, email)
        super.init(route: emailTakenRoute)
    }
}

class UsernameTakenRequestor: Requestor {
    var usernameTakenRoute = Route(method: .get, urlString: "\(serverAddress)/api/username_taken/%@")
    
    init(username: String) {
        usernameTakenRoute.urlString = String(format: usernameTakenRoute.urlString, username)
        super.init(route: usernameTakenRoute)
    }
}
