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

class APIClient {
    static var credentialRequests: CredentialRequests {
        return CredentialRequests.init()
    }
    
    static var userRequests: UserRequests {
        return UserRequests.init()
    }
    
    static var pinpostRequests: PinpostRequests {
        return PinpostRequests.init()
    }
    
    static var commentRequests: CommentRequests {
        return CommentRequests.init()
    }
    
    static var replyRequests: ReplyRequests {
        return ReplyRequests.init()
    }
    
    static var likeRequests: LikeRequests {
        return LikeRequests.init()
    }
    
    static var relationshipRequests: RelationshipRequests {
        return RelationshipRequests.init()
    }
    
    static var imageRequests: ImageRequests {
        return ImageRequests.init()
    }
    
    static var tagRequests: TagRequests {
        return TagRequests.init()
    }
    
}
