//
//  ReplyTests.swift
//  Zenyth
//
//  Created by Hoang on 8/9/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Zenyth

class ReplyTests: XCTestCase {
    
    var pinpostId: UInt32 = 0
    var commentId: UInt32 = 0
    var replyId: UInt32 = 0
    
    override func setUp() {
        super.setUp()
        baseURL = localhostURL
        let ex = expectation(description: "Setup User")
        
        RegistrationManager().register(withUsername: "replytestiosuser",
                                       email: "testiosemailreply@zenyth.com",
                                       password: "password",
                                       passwordConfirmation: "password",
                                       gender: "non-binary",
                                       birthday: "1998-04-28",
                                       onSuccess:
            { user, apiToken in
                UserDefaults.standard.set(apiToken, forKey: "api_token")
                ex.fulfill()
        }, onFailure: { json in
            LoginManager().login(withUsername: "replytestiosuser",
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
                
                PinpostManager().createPinpost(withTitle: "test pinpost for reply test",
                                               description: "test description of pinpost for reply test",
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
                    self.waitForExpectations(timeout: 10.0, handler:
                        { action in
                            let ex4 = self.expectation(description: "Setup Reply")
                            ReplyManager().createReply(onCommentId: self.commentId,
                                                       text: "test reply",
                                                       onSuccess:
                                { reply in
                                    self.replyId = reply.id
                                    ex4.fulfill()
                            }, onFailure: { json in
                                ex4.fulfill()
                            }, onRequestError: { error in
                                ex4.fulfill()
                            })
                            self.waitForExpectations(timeout: 10.0, handler: nil)
                    })
                })
        })
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateReply() {
        let ex = expectation(description: "Create Reply")
        ReplyManager().createReply(onCommentId: commentId,
                                   text: "test reply create",
                                   onSuccess:
            { reply in
                assertReplyData(reply: reply, text: "test reply create")
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
    
    func testUpdateReply() {
        let ex = expectation(description: "Update Reply")
        ReplyManager().updateReply(withReplyId: self.replyId,
                                   text: "updated reply",
                                   onSuccess:
            { reply in
                assertReplyData(reply: reply, text: "updated reply")
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
    
    func testReadReply() {
        let ex = expectation(description: "Read Reply")
        ReplyManager().readReplyInfo(withReplyId: self.replyId,
                                     onSuccess:
            { reply in
                assertReplyData(reply: reply, text: "test reply")
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
        let ex = expectation(description: "Reply Upload Image")
        let image = #imageLiteral(resourceName: "whitemountain")
        let imageData = UIImagePNGRepresentation(image)
        
        ReplyManager().uploadImage(toReplyId: replyId,
                                   imageData: imageData!,
                                   onSuccess:
            { image in
                ex.fulfill()
                assertImageData(image: image, imageableId: self.replyId,
                                imageableType: "Reply")
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
        let ex = expectation(description: "Get Likes on Reply")
        ReplyManager().getLikes(onReplyId: self.replyId,
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
