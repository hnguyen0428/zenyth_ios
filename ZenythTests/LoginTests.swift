//
//  LoginTests.swift
//  Zenyth
//
//  Created by Hoang on 8/9/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Zenyth

class LoginTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        baseURL = localhostURL
        let ex = expectation(description: "Setup")
        RegistrationManager().register(withUsername: "logintestiosuser",
                                       email: "testiosemaillogin@zenyth.com",
                                       password: "password",
                                       passwordConfirmation: "password",
                                       gender: "non-binary",
                                       birthday: "1998-04-28",
                                       onSuccess:
            { user, apiToken in
                UserDefaults.standard.set(apiToken, forKey: "api_token")
                ex.fulfill()
        }, onFailure: { json in
            ex.fulfill()
        }, onRequestError: { error in
            ex.fulfill()
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginWithUsername() {
        
        let ex = expectation(description: "Login")
        LoginManager().login(withUsername: "logintestiosuser",
                             password: "password",
                             onSuccess:
            { user, apiToken in
                ex.fulfill()
                XCTAssertNotNil(apiToken)
                assertUserData(user: user, username: "logintestiosuser",
                               email: "testiosemaillogin@zenyth.com",
                               gender: "non-binary", birthday: "1998-04-28")
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testLoginWithEmail() {
        let ex = expectation(description: "Login")
        LoginManager().login(withEmail: "testiosemaillogin@zenyth.com",
                             password: "password",
                             onSuccess:
            { user, apiToken in
                ex.fulfill()
                XCTAssertNotNil(apiToken)
                assertUserData(user: user, username: "logintestiosuser",
                               email: "testiosemaillogin@zenyth.com",
                               gender: "non-binary", birthday: "1998-04-28")
        }, onFailure: { json in
            ex.fulfill()
            XCTAssertFalse(json["success"].boolValue)
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
