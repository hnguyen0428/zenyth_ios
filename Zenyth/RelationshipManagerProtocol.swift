//
//  RelationshipRequestsProtocol.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

protocol RelationshipManagerProtocol {
    func requestSendFriendRequestTo(requesteeId: UInt32,
                                    onSuccess: RelationshipCallback?,
                                    onFailure: JSONCallback?,
                                    onRequestError: ErrorCallback?)
    
    func requestRespondToFriendRequestFrom(requesterId: UInt32, status: Bool,
                                           onSuccess: RelationshipCallback?,
                                           onFailure: JSONCallback?,
                                           onRequestError: ErrorCallback?)
    
    func requestDeleteFriendWith(userId: UInt32,
                                 onSuccess: JSONCallback?,
                                 onFailure: JSONCallback?,
                                 onRequestError: ErrorCallback?)
    
    func requestBlockUserWith(userId: UInt32,
                              onSuccess: RelationshipCallback?,
                              onFailure: JSONCallback?,
                              onRequestError: ErrorCallback?)
}
