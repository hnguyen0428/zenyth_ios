//
//  UserTests.swift
//  Zenyth
//
//  Created by Hoang on 8/9/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Zenyth

class UserTests: XCTestCase {
    
    var userId: UInt32 = 0
    
    override func setUp() {
        super.setUp()
        baseURL = localhostURL
        let ex = expectation(description: "Setup")
        
        RegistrationManager().register(withUsername: "usertestiosuser",
                                       email: "testiosemailuser@zenyth.com",
                                       password: "password",
                                       passwordConfirmation: "password",
                                       gender: "non-binary",
                                       birthday: "1998-04-28",
                                       onSuccess:
            { user, apiToken in
                UserDefaults.standard.set(apiToken, forKey: "api_token")
                self.userId = user.id
                ex.fulfill()
        }, onFailure: { json in
            LoginManager().login(withUsername: "usertestiosuser",
                                 password: "password",
                                 onSuccess:
                { user, apiToken in
                    UserDefaults.standard.set(apiToken, forKey: "api_token")
                    self.userId = user.id
                    ex.fulfill()
            })
        }, onRequestError: { error in
            ex.fulfill()
        })
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetFriends() {
        let ex = expectation(description: "User Get Friends")
        
        UserManager().getFriends(ofUserId: self.userId, onSuccess:
            { users in
                XCTAssertEqual(users.count, 0)
                ex.fulfill()
        }, onFailure: { json in
            XCTFail("Should not get here")
            ex.fulfill()
        }, onRequestError: { error in
            XCTFail("Should not get here")
            ex.fulfill()
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetFriendRequesters() {
        let ex = expectation(description: "User Get Friend Requesters")
        
        UserManager().getFriendRequests(onSuccess:
            { users in
                XCTAssertEqual(users.count, 0)
                ex.fulfill()
        }, onFailure: { json in
            XCTFail("Should not get here")
            ex.fulfill()
        }, onRequestError: { error in
            XCTFail("Should not get here")
            ex.fulfill()
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetBlockedUsers() {
        let ex = expectation(description: "User Get Blocked Users")
        
        UserManager().getBlockedUsers(onSuccess:
            { users in
                XCTAssertEqual(users.count, 0)
                ex.fulfill()
        }, onFailure: { json in
            XCTFail("Should not get here")
            ex.fulfill()
        }, onRequestError: { error in
            XCTFail("Should not get here")
            ex.fulfill()
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testReadProfile() {
        let ex = expectation(description: "User Get Blocked Users")
        
        UserManager().readProfile(ofUserId: self.userId, onSuccess:
            { user in
                assertUserData(user: user, id: self.userId,
                               username: "usertestiosuser",
                               email: "testiosemailuser@zenyth.com")
                ex.fulfill()
        }, onFailure: { json in
            XCTFail("Should not get here")
            ex.fulfill()
        }, onRequestError: { error in
            XCTFail("Should not get here")
            ex.fulfill()
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testUpdateProfile() {
        let ex = expectation(description: "User Get Blocked Users")
        
        UserManager().updateProfile(firstName: "test", lastName: "man",
                                    onSuccess:
            { user in
                assertUserData(user: user, id: self.userId,
                               username: "usertestiosuser",
                               email: "testiosemailuser@zenyth.com",
                               firstName: "test", lastName: "man")
                ex.fulfill()
        }, onFailure: { json in
            XCTFail("Should not get here")
            ex.fulfill()
        }, onRequestError: { error in
            XCTFail("Should not get here")
            ex.fulfill()
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testUpdateProfilePicture() {
        let ex = expectation(description: "User Get Blocked Users")
        let image = #imageLiteral(resourceName: "user")
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        
        UserManager().updateProfilePicture(imageData: imageData!,
                                    onSuccess:
            { user in
                let image = user.profilePicture
                XCTAssertNotNil(image)
                assertImageData(image: image, userId: self.userId,
                                imageableType: "Profile")
                ex.fulfill()
        }, onFailure: { json in
            XCTFail("Should not get here")
            ex.fulfill()
        }, onRequestError: { error in
            XCTFail("Should not get here")
            ex.fulfill()
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSearchUser() {
        let ex = expectation(description: "User Get Blocked Users")
        
        UserManager().searchUser(withKeyword: "test",
                                 onSuccess:
            { users in
                XCTAssertTrue(users.count > 0)
                ex.fulfill()
        }, onFailure: { json in
            XCTFail("Should not get here")
            ex.fulfill()
        }, onRequestError: { error in
            XCTFail("Should not get here")
            ex.fulfill()
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
