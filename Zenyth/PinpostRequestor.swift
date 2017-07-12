//
//  PinpostRequestor.swift
//  Zenyth
//
//  Created by Hoang on 7/12/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class PinpostCreateRequestor: Requestor {
    let pinpostCreateRoute = Route(method: .post, urlString: "\(serverAddress)/api/pinpost/create")
    
    init(parameters: Parameters) {
        super.init(route: self.pinpostCreateRoute, parameters: parameters, needsAuthorization: true)
    }
}

class PinpostReadRequestor: Requestor {
    var pinpostReadRoute = Route(method: .get, urlString: "\(serverAddress)/api/pinpost/read/%d")
    
    init(pinpost_id: Int64) {
        pinpostReadRoute.urlString = String(format: pinpostReadRoute.urlString, pinpost_id)
        super.init(route: self.pinpostReadRoute)
    }
}

class PinpostUpdateRequestor: Requestor {
    var pinpostUpdateRoute = Route(method: .post, urlString: "\(serverAddress)/api/pinpost/update/%d")
    
    init(parameters: Parameters, pinpost_id: Int64) {
        pinpostUpdateRoute.urlString = String(format: pinpostUpdateRoute.urlString, pinpost_id)
        super.init(route: self.pinpostUpdateRoute, parameters: parameters, needsAuthorization: true)
    }
}

class PinpostDeleteRequestor: Requestor {
    var pinpostDeleteRoute = Route(method: .delete, urlString: "\(serverAddress)/api/pinpost/delete/%d")
    
    init(parameters: Parameters, pinpost_id: Int64) {
        pinpostDeleteRoute.urlString = String(format: pinpostDeleteRoute.urlString, pinpost_id)
        super.init(route: self.pinpostDeleteRoute, parameters: parameters, needsAuthorization: true)
    }
}
