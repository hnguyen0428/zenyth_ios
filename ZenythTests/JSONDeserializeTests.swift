//
//  UserJSONTests.swift
//  Zenyth
//
//  Created by Hoang on 8/10/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Zenyth

class JSONDeserializeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserJSONDeserialize() {
        let json = getJSONFromFile(filename: "UserJSON")
        let user = User(json: json!["data"]["user"])
        assertUserData(user: user, id: 1, username: "testiosuser",
                       email: "testiosuser@zenyth.com", gender: "non-binary",
                       birthday: "2000-01-01", firstName: "Test", lastName: "Man")
        
        let image = user.profilePicture
        XCTAssertNotNil(image)
        assertImageData(image: image, id: 1, userId: 1, imageableId: 1,
                        fileName: "file.jpg", imageableType: "Profile")
    }
    
    func testPinpostJSONDeserialize() {
        let json = getJSONFromFile(filename: "PinpostJSON")
        let pinpost = Pinpost(json: json!["data"]["pinpost"])
        assertPinpostData(pinpost: pinpost, id: 1, title: "test pinpost title",
                          description: "test pinpost description",
                          latitude: 0.0, longitude: 0.0, userId: 1,
                          privacy: "public", updatedAt: "2000-01-01 00:00:00",
                          createdAt: "2000-01-01 00:00:00", comments: 100,
                          likes: 100)
        let images = pinpost.images
        XCTAssertEqual(images.count, 3)
    }
    
    func testCommentJSONDeserialize() {
        let json = getJSONFromFile(filename: "CommentJSON")
        let comment = Comment(json: json!["data"]["comment"])
        assertCommentData(comment: comment, id: 1, text: "test comment",
                          userId: 1, commentableId: 1,
                          commentableType: "Pinpost",
                          updatedAt: "2000-01-01 00:00:00",
                          createdAt: "2000-01-01 00:00:00", replies: 100,
                          likes: 100)
        let images = comment.images
        XCTAssertEqual(images.count, 3)
    }
    
    func testReplyJSONDeserialize() {
        let json = getJSONFromFile(filename: "ReplyJSON")
        let reply = Reply(json: json!["data"]["reply"])
        assertReplyData(reply: reply, id: 1, text: "test reply",
                        userId: 1, onCommentId: 1,
                        updatedAt: "2000-01-01 00:00:00",
                        createdAt: "2000-01-01 00:00:00", likes: 100)
        let images = reply.images
        XCTAssertEqual(images.count, 3)
    }
    
    func testImageJSONDeserialize() {
        let json = getJSONFromFile(filename: "ImageJSON")
        let image = Image(json: json!["data"]["image"])
        assertImageData(image: image, id: 1, userId: 1, imageableId: 1,
                        fileName: "file.jpeg", imageableType: "Profile",
                        directory: "profile_pictures")
    }
    
    func testLikeJSONDeserialize() {
        let json = getJSONFromFile(filename: "LikeJSON")
        let like = Like(json: json!["data"]["like"])
        assertLikeData(like: like, id: 1, userId: 1, likeableId: 1,
                       likeableType: "Pinpost")
    }
    
    func testRelationshipJSONDeserialize() {
        let json = getJSONFromFile(filename: "RelationshipJSON")
        let relationship = Relationship(json: json!["data"]["relationship"])
        assertRelationshipData(relationship: relationship,
                               requesterId: 1, requesteeId: 2, status: true,
                               blocked: false)
    }
    
    func testTagJSONDeserialize() {
        let json = getJSONFromFile(filename: "TagJSON")
        let tag = Tag(json: json!["data"]["tag"])
        assertTagData(tag: tag, id: 1, name: "test tag name")
    }
    
}

