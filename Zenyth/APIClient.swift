//
//  ZenythAPIClient.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

let baseURL = "http://54.219.134.56/api"

protocol ZenythAPIClient {
    static var credentialRequests : CredentialRequests { get }
}

class APIClient : ZenythAPIClient {
    static var credentialRequests: CredentialRequests {
        return CredentialRequests.init()
    }
}
