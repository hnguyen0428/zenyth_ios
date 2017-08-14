//
//  CustomAsserts.swift
//  Zenyth
//
//  Created by Hoang on 8/9/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import XCTest
@testable import Zenyth

func assertUserData(user: User?, id: UInt32? = nil, username: String? = nil,
                    email: String? = nil, gender: String? = nil,
                    birthday: String? = nil, firstName: String? = nil,
                    lastName: String? = nil, friends: UInt32? = nil) {
    XCTAssertNotNil(user)
    if user != nil {
        if id != nil {
            XCTAssertEqual(user!.id, id)
        }
        if username != nil {
            XCTAssertEqual(user!.username, username)
        }
        if birthday != nil {
            XCTAssertEqual(user!.birthday, birthday)
        }
        if gender != nil {
            XCTAssertEqual(user!.gender, gender)
        }
        if email != nil {
            XCTAssertEqual(user!.email, email)
        }
        if firstName != nil {
            XCTAssertEqual(user!.firstName, firstName)
        }
        if lastName != nil {
            XCTAssertEqual(user!.lastName, lastName)
        }
    }
}

func assertPinpostData(pinpost: Pinpost?, id: UInt32? = nil, title: String? = nil,
                       description: String? = nil, latitude: Double? = nil,
                       longitude: Double? = nil, userId: UInt32? = nil,
                       privacy: String? = nil, updatedAt: String? = nil,
                       createdAt: String? = nil, comments: UInt32? = nil,
                       likes: UInt32? = nil) {
    XCTAssertNotNil(pinpost)
    if pinpost != nil {
        if id != nil {
            XCTAssertEqual(pinpost!.id, id)
        }
        if title != nil {
            XCTAssertEqual(pinpost!.title, title)
        }
        if description != nil {
            XCTAssertEqual(pinpost!.pinpostDescription, description)
        }
        if latitude != nil {
            XCTAssertEqual(pinpost!.latitude, latitude)
        }
        if longitude != nil {
            XCTAssertEqual(pinpost!.longitude, longitude)
        }
        if userId != nil {
            XCTAssertEqual(pinpost!.creator.id, userId)
        }
        if privacy != nil {
            XCTAssertEqual(pinpost!.privacy, privacy)
        }
        if updatedAt != nil {
            XCTAssertEqual(pinpost!.updatedAt, updatedAt)
        }
        if createdAt != nil {
            XCTAssertEqual(pinpost!.createdAt, createdAt)
        }
        if comments != nil {
            XCTAssertEqual(pinpost!.comments, comments)
        }
        if likes != nil {
            XCTAssertEqual(pinpost!.likes, likes)
        }
    }
}

func assertCommentData(comment: Comment?, id: UInt32? = nil,
                       text: String? = nil, userId: UInt32? = nil,
                       commentableId: UInt32? = nil,
                       commentableType: String? = nil,
                       updatedAt: String? = nil, createdAt: String? = nil,
                       replies: UInt32? = nil, likes: UInt32? = nil) {
    XCTAssertNotNil(comment)
    if comment != nil {
        if id != nil {
            XCTAssertEqual(comment!.id, id)
        }
        if text != nil {
            XCTAssertEqual(comment!.text, text)
        }
        if userId != nil {
            XCTAssertEqual(comment!.creator.id, userId)
        }
        if commentableId != nil {
            XCTAssertEqual(comment!.commentableId, commentableId)
        }
        if commentableType != nil {
            XCTAssertEqual(comment!.commentableType, commentableType)
        }
        if updatedAt != nil {
            XCTAssertEqual(comment!.updatedAt, updatedAt)
        }
        if createdAt != nil {
            XCTAssertEqual(comment!.createdAt, createdAt)
        }
        if replies != nil {
            XCTAssertEqual(comment!.replies, replies)
        }
        if likes != nil {
            XCTAssertEqual(comment!.likes, likes)
        }
    }
}

func assertReplyData(reply: Reply?, id: UInt32? = nil,
                       text: String? = nil, userId: UInt32? = nil,
                       onCommentId: UInt32? = nil,
                       updatedAt: String? = nil, createdAt: String? = nil,
                       likes: UInt32? = nil) {
    XCTAssertNotNil(reply)
    if reply != nil {
        if id != nil {
            XCTAssertEqual(reply!.id, id)
        }
        if text != nil {
            XCTAssertEqual(reply!.text, text)
        }
        if userId != nil {
            XCTAssertEqual(reply!.creator.id, userId)
        }
        if onCommentId != nil {
            XCTAssertEqual(reply!.onCommentId, onCommentId)
        }
        if updatedAt != nil {
            XCTAssertEqual(reply!.updatedAt, updatedAt)
        }
        if createdAt != nil {
            XCTAssertEqual(reply!.createdAt, createdAt)
        }
        if likes != nil {
            XCTAssertEqual(reply!.likes, likes)
        }
    }
}

func assertLikeData(like: Like?, id: UInt32? = nil, userId: UInt32? = nil,
                    likeableId: UInt32? = nil, likeableType: String? = nil) {
    XCTAssertNotNil(like)
    if like != nil {
        if id != nil {
            XCTAssertEqual(like!.id, id)
        }
        if userId != nil {
            XCTAssertEqual(like!.user.id, userId)
        }
        if likeableId != nil {
            XCTAssertEqual(like!.likeableId, likeableId)
        }
        if likeableType != nil {
            XCTAssertEqual(like!.likeableType, likeableType)
        }
    }
}

func assertImageData(image: Image?, id: UInt32? = nil, userId: UInt32? = nil,
                     imageableId: UInt32? = nil, fileName: String? = nil,
                     imageableType: String? = nil, directory: String? = nil) {
    XCTAssertNotNil(image)
    if image != nil {
        if id != nil {
            XCTAssertEqual(image!.id, id)
        }
        if userId != nil {
            XCTAssertEqual(image!.userId, userId)
        }
        if imageableId != nil {
            XCTAssertEqual(image!.imageableId, imageableId)
        }
        if fileName != nil {
            XCTAssertEqual(image!.filename, fileName)
        }
        if imageableType != nil {
            XCTAssertEqual(image!.imageableType, imageableType)
        }
        if directory != nil {
            XCTAssertEqual(image!.directory, directory)
        }
    }
}

func assertRelationshipData(relationship: Relationship?,
                            requesterId: UInt32? = nil,
                            requesteeId: UInt32? = nil,
                            status: Bool? = nil,
                            blocked: Bool? = nil) {
    XCTAssertNotNil(relationship)
    if relationship != nil {
        if requesterId != nil {
            XCTAssertEqual(relationship!.requester.id, requesterId)
        }
        if requesteeId != nil {
            XCTAssertEqual(relationship!.requestee.id, requesteeId)
        }
        if status != nil {
            XCTAssertEqual(relationship!.status, status)
        }
        if blocked != nil {
            XCTAssertEqual(relationship!.blocked, blocked)
        }
    }
}

func assertTagData(tag: Tag?, id: UInt32? = nil, name: String? = nil) {
    XCTAssertNotNil(tag)
    if tag != nil {
        if id != nil {
            XCTAssertEqual(tag!.id, id)
        }
        if name != nil {
            XCTAssertEqual(tag!.name, name)
        }
    }
}


