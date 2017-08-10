//
//  PinpostTests.swift
//  Zenyth
//
//  Created by Hoang on 8/9/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Zenyth

class PinpostTests: XCTestCase {
    var userId: UInt32 = 0
    var pinpostIdToUpdate: UInt32 = 0
    var pinpostIdToDelete: UInt32 = 0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        baseURL = localhostURL
        let ex = expectation(description: "Setup User")
        
        RegistrationManager().register(withUsername: "testiosuserpinpost",
                                       email: "testiosemailpinpost@zenyth.com",
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
            ex.fulfill()
        }, onRequestError: { error in
            ex.fulfill()
        })
        
        let ex2 = expectation(description: "Setup Pinpost to Update")
        
        PinpostManager().createPinpost(withTitle: "test pinpost to update",
                                       description: "test description of pinpost to update",
                                       latitude: 22.0, longitude: 22.0,
                                       privacy: "friends",
                                       onSuccess:
            { pinpost in
                self.pinpostIdToUpdate = pinpost.id
                ex2.fulfill()
        }, onFailure: { json in
            ex2.fulfill()
        }, onRequestError: { error in
            ex2.fulfill()
        })
        
        let ex3 = expectation(description: "Setup Pinpost to Delete")
        
        PinpostManager().createPinpost(withTitle: "test pinpost to delete",
                                       description: "test description of pinpost to delete",
                                       latitude: 22.0, longitude: 22.0,
                                       privacy: "friends",
                                       onSuccess:
            { pinpost in
                self.pinpostIdToDelete = pinpost.id
                ex3.fulfill()
        }, onFailure: { json in
            ex3.fulfill()
        }, onRequestError: { error in
            ex3.fulfill()
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreatePinpost() {
        let ex = expectation(description: "Pinpost Create")
        PinpostManager().createPinpost(withTitle: "test title",
                                       description: "test description",
                                       latitude: 22.0, longitude: 22.0,
                                       privacy: "self", tags: "hi,hello,goodbye",
                                       onSuccess:
            { pinpost in
                ex.fulfill()
                assertPinpostData(pinpost: pinpost, title: "test title",
                                  description: "test description",
                                  latitude: 22.0, longitude: 22.0,
                                  privacy: "self")
        }, onFailure: { json in
            ex.fulfill()
            XCTAssertFalse(json["success"].boolValue)
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testUpdatePinpost() {
        let ex = expectation(description: "Pinpost Update")
        PinpostManager().updatePinpost(withPinpostId: pinpostIdToUpdate,
                                       title: "updated title",
                                       description: "updated description",
                                       onSuccess:
            { pinpost in
                ex.fulfill()
                print(pinpost)
                assertPinpostData(pinpost: pinpost, title: "updated title",
                                  description: "updated description",
                                  latitude: 22.0, longitude: 22.0,
                                  privacy: "friends")
        }, onFailure: { json in
            ex.fulfill()
            XCTAssertFalse(json["success"].boolValue)
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testDeletePinpost() {
        let ex = expectation(description: "Pinpost Delete")
        PinpostManager().deletePinpost(withPinpostId: pinpostIdToDelete,
                                       onSuccess:
            { json in
                ex.fulfill()
                XCTAssertTrue(json["success"].boolValue)
        }, onFailure: { json in
            ex.fulfill()
            XCTAssertFalse(json["success"].boolValue)
        }, onRequestError: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testUploadImage() {
        let ex = expectation(description: "Pinpost Upload Image")
        let image = #imageLiteral(resourceName: "whitemountain")
        let imageData = UIImagePNGRepresentation(image)
        
        PinpostManager().uploadImage(toPinpostId: pinpostIdToUpdate,
                                     imageData: imageData!,
                                     onSuccess:
            { image in
                ex.fulfill()
                assertImageData(image: image, userId: self.userId,
                                imageableId: self.pinpostIdToUpdate,
                                imageableType: "Pinpost")
        }, onFailure: { json in
            ex.fulfill()
            print(json)
            XCTAssertFalse(json["success"].boolValue)
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
