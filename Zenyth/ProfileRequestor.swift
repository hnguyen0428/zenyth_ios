//
//  ProfileRequestor.swift
//  Zenyth
//
//  Created by Hoang on 7/12/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ProfileUpdateRequestor: Requestor {
    let profileUpdateRoute = Route(method: .post,
                            urlString: "\(serverAddress)/api/profile/update")
    
    init(parameters: Parameters) {
        super.init(route: self.profileUpdateRoute, parameters: parameters,
                   needsAuthorization: true)
    }
}
