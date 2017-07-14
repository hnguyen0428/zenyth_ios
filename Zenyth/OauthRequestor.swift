//
//  OauthRequestor.swift
//  Zenyth
//
//  Created by Hoang on 7/13/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class OauthRegisterRequestor: Requestor {
    let oauthRegisterRoute = Route(method: .post, urlString: "\(serverAddress)/api/oauth/register")
    
    init(parameters: Parameters) {
        super.init(route: self.oauthRegisterRoute, parameters: parameters)
    }
}


class OauthFBLoginRequestor: Requestor {
    let oauthFBLoginRoute = Route(method: .post, urlString: "\(serverAddress)/api/oauth/fb/login")
    
    init(parameters: Parameters, header: HTTPHeaders) {
        super.init(route: self.oauthFBLoginRoute, header: header, parameters: parameters)
    }
}

