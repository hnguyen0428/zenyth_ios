//
//  RegistrationTest.swift
//  Zenyth
//
//  Created by Hoang on 8/9/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Zenyth

class RegistrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        baseURL = localhostURL
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRegistration() {
        let ex = expectation(description: "Registration")
        RegistrationManager().register(withUsername: "registertestiosuser",
                                       email: "testiosemailregister@zenyth.com",
                                       password: "password",
                                       passwordConfirmation: "password",
                                       gender: "non-binary", birthday: "1998-04-28",
                                       onSuccess:
            { user, apiToken in
                ex.fulfill()
                XCTAssertNotNil(apiToken)
                assertUserData(user: user, username: "registertestiosuser",
                               email: "testiosemailregister@zenyth.com",
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
    
}
