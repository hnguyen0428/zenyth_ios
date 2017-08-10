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
    
    var pinpostId: UInt32 = 0
    
    override func setUp() {
        super.setUp()
        baseURL = localhostURL
        let ex = expectation(description: "Setup User")
        
        RegistrationManager().register(withUsername: "pinposttestiosuser",
                                       email: "testiosemailpinpost@zenyth.com",
                                       password: "password",
                                       passwordConfirmation: "password",
                                       gender: "non-binary",
                                       birthday: "1998-04-28",
                                       onSuccess:
            { user, apiToken in
                UserDefaults.standard.set(apiToken, forKey: "api_token")
                ex.fulfill()
        }, onFailure: { json in
            LoginManager().login(withUsername: "pinposttestiosuser",
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
                
                self.waitForExpectations(timeout: 10.0, handler: nil)
        })
        
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
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testUpdatePinpost() {
        let ex = expectation(description: "Pinpost Update")
        PinpostManager().updatePinpost(withPinpostId: pinpostId,
                                       title: "updated title",
                                       description: "updated description",
                                       onSuccess:
            { pinpost in
                ex.fulfill()
                assertPinpostData(pinpost: pinpost, title: "updated title",
                                  description: "updated description",
                                  latitude: 22.0, longitude: 22.0,
                                  privacy: "public")
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testReadPinpost() {
        let ex = expectation(description: "Pinpost Read")
        PinpostManager().readPinpostInfo(withPinpostId: pinpostId,
                                         onSuccess:
            { pinpost in
                ex.fulfill()
                assertPinpostData(pinpost: pinpost, title: "test pinpost",
                                  description: "test description of pinpost",
                                  latitude: 22.0, longitude: 22.0,
                                  privacy: "public")
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testDeletePinpost() {
        let ex = expectation(description: "Pinpost Delete")
        PinpostManager().deletePinpost(withPinpostId: pinpostId,
                                       onSuccess:
            { json in
                ex.fulfill()
                XCTAssertTrue(json["success"].boolValue)
                self.pinpostId = 0
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
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
        var imageName = ""
        
        PinpostManager().uploadImage(toPinpostId: pinpostId,
                                     imageData: imageData!,
                                     onSuccess:
            { image in
                ex.fulfill()
                assertImageData(image: image, imageableId: self.pinpostId,
                                imageableType: "Pinpost")
                imageName = image.filename
        }, onFailure: { json in
            ex.fulfill()
            XCTFail("Should not get here")
        }, onRequestError: { error in
            ex.fulfill()
            XCTFail("Should not get here")
        })
        waitForExpectations(timeout: 5.0, handler: { action in
            let ex2 = self.expectation(description: "Pinpost Check Image")
            PinpostManager().readPinpostInfo(withPinpostId: self.pinpostId,
                                             onSuccess:
                { pinpost in
                    XCTAssertTrue(pinpost.images.count > 0)
                    let image = pinpost.images.first
                    assertImageData(image: image, fileName: imageName)
                    ex2.fulfill()
            })
            self.waitForExpectations(timeout: 5.0, handler: nil)
        })
    }
    
}
