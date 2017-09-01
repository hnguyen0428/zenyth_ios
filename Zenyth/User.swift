//
//  User.swift
//  Zenyth
//
//  Created by Hoang on 7/14/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User : APIObject {
    var id: UInt32
    var email: String?
    var username: String
    var followers: UInt32
    var firstName: String?
    var lastName: String?
    var gender: String?
    var birthday: String?
    var biography: String?
    var profilePicture: Image?
    var pinposts: [Pinpost] = [Pinpost]()
    var likes: UInt32?
    var numberOfPinposts: UInt32?
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.email = json["email"].string
        self.username = json["username"].stringValue
        self.followers = json["followers"].uInt32Value
        self.firstName = json["first_name"].string
        self.lastName = json["last_name"].string
        self.gender = json["gender"].string
        let date = json["birthday"].string
        if let str = date {
            let index = str.index(str.startIndex, offsetBy: 10)
            self.birthday = str.substring(to: index)
        }
        self.biography = json["biography"].string
        
        let imageJSON = json["picture"]
        if imageJSON != JSON.null {
            self.profilePicture = Image(json: imageJSON)
        }
        
        if json["pinposts"] != JSON.null {
            let pinpostsJSON = json["pinposts"].arrayValue
            for pinpostJSON in pinpostsJSON {
                self.pinposts.append(Pinpost(json: pinpostJSON))
            }
        }
        if json["number_of_pinposts"] != JSON.null {
            self.numberOfPinposts = json["number_of_pinposts"].uInt32Value
        }
        if json["likes"] != JSON.null {
            self.likes = json["likes"].uInt32Value
        }
    }
    
    func toJSON() -> JSON {
        var pinpostsJSON = [JSON]()
        for pinpost in pinposts {
            pinpostsJSON.append(pinpost.toJSON())
        }
        
        return [
            "id": id,
            "email": email,
            "username": username,
            "friends": followers,
            "first_name": firstName,
            "last_name": lastName,
            "gender": gender,
            "birthday": birthday,
            "biography": biography,
            "picture": profilePicture?.toJSON(),
            "pinposts": pinpostsJSON,
            "number_of_pinposts": numberOfPinposts,
            "likes": likes
        ]
    }
    
    func name() -> String? {
        var name: String? = nil
        if let firstName = self.firstName,
            let lastName = self.lastName {
            name = "\(firstName) \(lastName)"
        } else if let firstName = self.firstName {
            name = firstName
        } else if let lastName = self.lastName {
            name = lastName
        }
        return name
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
