//
//  LoginRequestor.swift
//  Zenyth
//
//  Created by Hoang on 7/12/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class LoginRequestor: Requestor {
    let loginRoute = Route(method: .post, urlString: "\(serverAddress)/api/login")
    
    init(parameters: Parameters) {
        super.init(route: self.loginRoute, parameters: parameters)
    }
}
