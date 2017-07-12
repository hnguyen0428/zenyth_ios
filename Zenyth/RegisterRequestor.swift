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
