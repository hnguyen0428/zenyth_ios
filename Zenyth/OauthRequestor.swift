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
    let oauthRegisterRoute = Route(method: .post,
                            urlString: "\(serverAddress)/api/oauth/register")
    
    init(parameters: Parameters, header: HTTPHeaders) {
        super.init(route: self.oauthRegisterRoute, header: header, parameters: parameters)
    }
}


class OauthLoginRequestor: Requestor {
    let oauthLoginRoute = Route(method: .post,
                            urlString: "\(serverAddress)/api/oauth/login")
    
    init(parameters: Parameters, header: HTTPHeaders) {
        super.init(route: self.oauthLoginRoute, header: header,
                   parameters: parameters)
    }
}

