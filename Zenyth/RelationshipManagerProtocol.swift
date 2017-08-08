//
//  RelationshipManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol RelationshipManagerProtocol {
    func sendFriendRequest(toRequesteeId requesteeId: UInt32,
                           onSuccess: RelationshipCallback?,
                           onFailure: JSONCallback?,
                           onRequestError: ErrorCallback?)
    
    func respondToFriendRequest(fromRequesterId requesterId: UInt32, status: Bool,
                                onSuccess: RelationshipCallback?,
                                onFailure: JSONCallback?,
                                onRequestError: ErrorCallback?)
    
    func deleteFriend(withUserId userId: UInt32,
                      onSuccess: JSONCallback?,
                      onFailure: JSONCallback?,
                      onRequestError: ErrorCallback?)
    
    func blockUser(withUserId userId: UInt32,
                   onSuccess: RelationshipCallback?,
                   onFailure: JSONCallback?,
                   onRequestError: ErrorCallback?)
}
