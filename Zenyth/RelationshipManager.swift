//
//  RelationshipManager.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class RelationshipManager: RelationshipManagerProtocol {
    func sendFriendRequest(toRequesteeId requesteeId: UInt32,
                           onSuccess: RelationshipCallback? = nil,
                           onFailure: JSONCallback? = nil,
                           onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func respondToFriendRequest(fromRequesterId requesterId: UInt32,
                                status: Bool,
                                onSuccess: RelationshipCallback? = nil,
                                onFailure: JSONCallback? = nil,
                                onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func deleteFriend(withUserId userId: UInt32,
                      onSuccess: JSONCallback? = nil,
                      onFailure: JSONCallback? = nil,
                      onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
    
    func blockUser(withUserId userId: UInt32,
                   onSuccess: RelationshipCallback? = nil,
                   onFailure: JSONCallback? = nil,
                   onRequestError: ErrorCallback? = nil) {
        <#code#>
    }
}
