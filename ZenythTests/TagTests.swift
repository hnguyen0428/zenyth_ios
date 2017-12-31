//
//  TagTests.swift
//  Zenyth
//
//  Created by Hoang on 8/9/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Zenyth

class TagTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        baseURL = localhostURL
        let ex = expectation(description: "Setup User")
        
        RegistrationManager().register(withUsername: "tagtestiosuser",
                                       email: "testiosemailtag@zenyth.com",
                                       password: "password",
                                       passwordConfirmation: "password",
                                       gender: "non-binary",
                                       birthday: "1998-04-28",
                                       onSuccess:
            { user, apiToken in
                UserDefaults.standard.set(apiToken, forKey: "api_token")
                ex.fulfill()
        }, onFailure: { json in
            LoginManager().login(withUsername: "tagtestiosuser",
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
                                               tags: "test,tdd,testing,tested",
                                               onSuccess:
                    { pinpost in
                        ex2.fulfill()
                }, onFailure: { json in
                    ex2.fulfill()
                }, onRequestError: { error in
                    ex2.fulfill()
                })
                self.waitForExpectations(timeout: 10.0, handler: nil)
        })
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchTag() {
        let ex = expectation(description: "Search Tag")
        TagManager().searchTag(withKeyword: "test",
                               onSuccess:
            { tags in
                XCTAssertTrue(tags.count > 0)
                ex.fulfill()
        }, onFailure: { json in
            ex.fulfill()
            print(json)
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetTagInfo() {
        let ex = expectation(description: "Search Tag")
        TagManager().getTagInfo(forTagName: "test",
                               onSuccess:
            { pinposts in
                XCTAssertTrue(pinposts.count > 0)
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
