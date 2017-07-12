//
//  ResetPasswordController.swift
//  Zenyth
//
//  Created by Hoang on 7/12/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ResetPasswordRequestor: Requestor {
    let resetPasswordRoute = Route(method: .post, urlString: "\(serverAddress)/api/password/send_reset_password")
    
    init(parameters: Parameters) {
        super.init(route: self.resetPasswordRoute, parameters: parameters)
    }
}
