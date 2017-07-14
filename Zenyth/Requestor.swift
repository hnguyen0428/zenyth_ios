//
//  Requestor.swift
//  Zenyth
//
//  Created by Hoang on 7/11/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON
import Alamofire

class Requestor {
    var route: Route
    var header: HTTPHeaders
    let parameters: Parameters
    
    var jsonResponse: JSON? = nil
    var success: Bool = false
    let needsAuthorization: Bool

    init(route: Route, header: HTTPHeaders = HTTPHeaders.init(),
         parameters: Parameters = Parameters.init(), needsAuthorization: Bool = false) {
        self.needsAuthorization = needsAuthorization
        self.route = route
        self.header = header
        self.parameters = parameters
    }
    
    func execute() -> DataRequest {
        let method = route.method
        if needsAuthorization {
            setAuthorization()
        }
        
        return Alamofire.request(route.urlString, method: method,
                                 parameters: self.parameters,
                                 headers: header)

    }
    
    func setAuthorization() {
        let api_token = UserDefaults.standard.object(forKey: "api_token")
        header = [
            "Authorization" : "bearer \(api_token)"
        ]
    }
}
