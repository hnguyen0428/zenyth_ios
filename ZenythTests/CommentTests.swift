//
//  CommentTests.swift
//  Zenyth
//
//  Created by Hoang on 8/9/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Zenyth

class CommentTests: XCTestCase {
    
    var pinpostId: UInt32 = 0
    var commentId: UInt32 = 0
    
    override func setUp() {
        super.setUp()
        baseURL = localhostURL
        let ex = expectation(description: "Setup User")
        
        RegistrationManager().register(withUsername: "commenttestiosuser",
                                       email: "testiosemailcomment@zenyth.com",
                                       password: "password",
                                       passwordConfirmation: "password",
                                       gender: "non-binary",
                                       birthday: "1998-04-28",
                                       onSuccess:
            { user, apiToken in
                UserDefaults.standard.set(apiToken, forKey: "api_token")
                ex.fulfill()
        }, onFailure: { json in
            LoginManager().login(withUsername: "commenttestiosuser",
                                 password: "password",
                                 onSuccess:
                { user, apiToken in
                    UserDefaults.standard.set(apiToken, forKey: "api_token")
                    ex.fulfill()
            })
        }, onRequestError: { error in
            ex.fulfill()
        })
        
        waitForExpectations(timeout: 10.0, handler:
            { action in
                let ex2 = self.expectation(description: "Setup Pinpost")

                PinpostManager().createPinpost(withTitle: "test pinpost for comment test",
                                               description: "test description of pinpost for comment test",
                                               latitude: 22.0, longitude: 22.0,
                                               privacy: "public",
                                               onSuccess:
                    { pinpost in
                        self.pinpostId = pinpost.id
                        ex2.fulfill()
                }, onFailure: { json in
                    ex2.fulfill()
                }, onRequestError: { error in
                    ex2.fulfill()
                })
                
                self.waitForExpectations(timeout: 10.0, handler: { action in
                    let ex3 = self.expectation(description: "Setup Comment")
                    CommentManager().createComment(onPinpostId: self.pinpostId,
                                                   text: "test comment",
                                                   onSuccess:
                        { comment in
                            self.commentId = comment.id
                            ex3.fulfill()
                    }, onFailure: { json in
                        ex3.fulfill()
                    }, onRequestError: { error in
                        ex3.fulfill()
                    })
                    self.waitForExpectations(timeout: 10.0, handler: nil)
                })
        })
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateComment() {
        let ex = expectation(description: "Create Comment")
        CommentManager().createComment(onPinpostId: pinpostId,
                                       text: "test comment create",
                                       onSuccess:
            { comment in
                assertCommentData(comment: comment, text: "test comment create",
                                  commentableId: self.pinpostId,
                                  commentableType: "Pinpost")
                ex.fulfill()
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testUpdateComment() {
        let ex = expectation(description: "Update Comment")
        CommentManager().updateComment(withCommentId: self.commentId,
                                       text: "updated comment",
                                       onSuccess:
            { comment in
                assertCommentData(comment: comment, text: "updated comment")
                ex.fulfill()
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testReadComment() {
        let ex = expectation(description: "Read Comment")
        CommentManager().readCommentInfo(withCommentId: self.commentId,
                                         onSuccess:
            { comment in
                assertCommentData(comment: comment, text: "test comment",
                                  commentableId: self.pinpostId)
                ex.fulfill()
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testUploadImage() {
        let ex = expectation(description: "Comment Upload Image")
        let image = #imageLiteral(resourceName: "whitemountain")
        let imageData = UIImagePNGRepresentation(image)
        
        CommentManager().uploadImage(toCommentId: commentId,
                                     imageData: imageData!,
                                     onSuccess:
            { image in
                ex.fulfill()
                assertImageData(image: image, imageableId: self.commentId,
                                imageableType: "Comment")
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetReplies() {
        let ex = expectation(description: "Get Replies on Comment")
        CommentManager().getReplies(onCommentId: self.commentId,
                                    onSuccess:
            { replies in
                XCTAssertEqual(replies.count, 0)
                ex.fulfill()
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetLikes() {
        let ex = expectation(description: "Get Likes on Comment")
        CommentManager().getLikes(onCommentId: self.commentId,
                                  onSuccess:
            { likes in
                XCTAssertEqual(likes.count, 0)
                ex.fulfill()
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
