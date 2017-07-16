//
//  RelationshipRequestor.swift
//  Zenyth
//
//  Created by Hoang on 7/12/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Alamofire
import SwiftyJSON

class FriendRequestRequestor: Requestor {
    let friendRequestRoute = Route(method: .post,
                urlString: "\(serverAddress)/api/relationship/friend_request")
    
    init(parameters: Parameters) {
        super.init(route: self.friendRequestRoute, parameters: parameters,
                   needsAuthorization: true)
    }
}

class RespondToRequestRequestor: Requestor {
    var respondToRequestRoute = Route(method: .post,
                urlString: "\(serverAddress)/api/relationship/response/%d")
    
    init(parameters: Parameters, requester_id: Int64) {
        respondToRequestRoute.urlString = String(
            format: respondToRequestRoute.urlString, requester_id)
        super.init(route: self.respondToRequestRoute, parameters: parameters,
                   needsAuthorization: true)
    }
}

class DeleteFriendRequestor: Requestor {
    var deleteFriendRoute = Route(method: .delete,
                urlString: "\(serverAddress)/api/relationship/delete/%d")
    
    init(user_id: Int64) {
        deleteFriendRoute.urlString = String(
            format:deleteFriendRoute.urlString, user_id)
        super.init(route: self.deleteFriendRoute, needsAuthorization: true)
    }
}

class BlockRequestor: Requestor {
    var blockRoute = Route(method: .get,
                urlString: "\(serverAddress)/api/relationship/block/%d")
    
    init(user_id: Int64) {
        blockRoute.urlString = String(format:blockRoute.urlString, user_id)
        super.init(route: self.blockRoute, needsAuthorization: true)
    }
}
