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
    static func credentialManager() -> CredentialManager {
        return CredentialManager.init()
    }
    
    static func userManager() -> UserManager {
        return UserManager.init()
    }
    
    static func pinpostManager() -> PinpostManager {
        return PinpostManager.init()
    }
    
    static func commentManager() -> CommentManager {
        return CommentManager.init()
    }
    
    static func replyManager() -> ReplyManager {
        return ReplyManager.init()
    }
    
    static func likeManager() -> LikeManager {
        return LikeManager.init()
    }
    
    static func relationshipManager() -> RelationshipManager {
        return RelationshipManager.init()
    }
    
    static func imageManager() -> ImageManager {
        return ImageManager.init()
    }
    
    static func tagManager() -> TagManager {
        return TagManager.init()
    }
    
}
