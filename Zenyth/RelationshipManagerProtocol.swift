//
//  RelationshipManagerProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol RelationshipManagerProtocol {
    /**
     Send a follower request to a user
     - Parameters:
        - requesteeId: ID of user for the request to be sent to
        - onSuccess: callback function with Relationship parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func sendFollowerRequest(toRequesteeId requesteeId: UInt32,
                             onSuccess: RelationshipCallback?,
                             onFailure: JSONCallback?,
                             onRequestError: ErrorCallback?)
    
    /**
     Respond to a follower request from a user
     - Parameters:
        - requesterId: ID of user the request is from
        - onSuccess: callback function with Relationship parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func respondToFollowerRequest(fromRequesterId requesterId: UInt32, status: Bool,
                                  onSuccess: RelationshipCallback?,
                                  onFailure: JSONCallback?,
                                  onRequestError: ErrorCallback?)
    
    /**
     Unfollow user
     - Parameters:
        - userId: ID of user to be unfollowed
        - onSuccess: callback function with JSON parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func unfollowUser(withUserId userId: UInt32,
                      onSuccess: JSONCallback?,
                      onFailure: JSONCallback?,
                      onRequestError: ErrorCallback?)
    
    /**
     Block a user
     - Parameters:
        - userId: ID of user to be blocked
        - onSuccess: callback function with Relationship parameter
        - onFailure: callback function with JSON parameter
        - onRequestError: callback function with NSError parameter
     */
    func blockUser(withUserId userId: UInt32,
                   onSuccess: RelationshipCallback?,
                   onFailure: JSONCallback?,
                   onRequestError: ErrorCallback?)
}
