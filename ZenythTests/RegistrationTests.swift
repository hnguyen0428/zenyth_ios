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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        baseURL = localhostURL
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRegistration() {
        
        let ex = expectation(description: "Registration")
        RegistrationManager().register(withUsername: "testiosuserregister",
                                       email: "testiosemailregister@zenyth.com",
                                       password: "password",
                                       passwordConfirmation: "password",
                                       gender: "non-binary", birthday: "1998-04-28",
                                       onSuccess:
            { user, apiToken in
                ex.fulfill()
                XCTAssertNotNil(apiToken)
                assertUserData(user: user, username: "testiosuserregister",
                               email: "testiosemailregister@zenyth.com",
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
