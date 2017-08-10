//
//  LikeTests.swift
//  Zenyth
//
//  Created by Hoang on 8/9/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Zenyth

class LikeTests: XCTestCase {
    
    var pinpostId: UInt32 = 0
    var likeId: UInt32 = 0
    
    override func setUp() {
        super.setUp()
        baseURL = localhostURL
        let ex = expectation(description: "Setup User")
        
        RegistrationManager().register(withUsername: "liketestiosuser",
                                       email: "testiosemaillike@zenyth.com",
                                       password: "password",
                                       passwordConfirmation: "password",
                                       gender: "non-binary",
                                       birthday: "1998-04-28",
                                       onSuccess:
            { user, apiToken in
                UserDefaults.standard.set(apiToken, forKey: "api_token")
                ex.fulfill()
        }, onFailure: { json in
            LoginManager().login(withUsername: "liketestiosuser",
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
                PinpostManager().createPinpost(withTitle: "test pinpost",
                                               description: "test description of pinpost",
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
                self.waitForExpectations(timeout: 10.0, handler:
                    { action in
                        let ex3 = self.expectation(description: "Setup Like")
                        LikeManager().createLike(onPinpostId: self.pinpostId,
                                                 onSuccess:
                            { like in
                                self.likeId = like.id
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
    
    func testReadLike() {
        let ex = expectation(description: "Read Like")
        LikeManager().readLike(withLikeId: likeId,
                               onSuccess:
            { like in
                assertLikeData(like: like, likeableId: self.pinpostId,
                               likeableType: "Pinpost")
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
    
    func testDeleteLike() {
        let ex = expectation(description: "Like Delete")
        LikeManager().deleteLike(withLikeId: likeId,
                                 onSuccess:
            { json in
                XCTAssertTrue(json["success"].boolValue)
                ex.fulfill()
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        }, onRequestError: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
