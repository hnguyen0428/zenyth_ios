//
//  APIRequest.swift
//  Zenyth
//
//  Created by Hoang on 7/9/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON;
import Alamofire;

protocol RouteProtocol {
    var urlString: String {get set}
    var method: HTTPMethod {get set}
    
}

struct Route: RouteProtocol {
    var method: HTTPMethod
    var urlString: String
}
