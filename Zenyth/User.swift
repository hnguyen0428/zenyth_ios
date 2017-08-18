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
    var friends: UInt32
    var firstName: String?
    var lastName: String?
    var gender: String?
    var birthday: String?
    var profilePicture: Image?
    
    init(json: JSON) {
        self.id = json["id"].uInt32Value
        self.email = json["email"].string
        self.username = json["username"].stringValue
        self.friends = json["friends"].uInt32Value
        self.firstName = json["first_name"].string
        self.lastName = json["last_name"].string
        self.gender = json["gender"].string
        let date = json["birthday"].string
        if let str = date {
            let index = str.index(str.startIndex, offsetBy: 10)
            self.birthday = str.substring(to: index)
        }
        
        let imageJSON = json["picture"]
        if imageJSON != JSON.null {
            self.profilePicture = Image(json: imageJSON)
        }
    }
    
    func toJSON() -> JSON {
        return [
            "id": id,
            "email": email,
            "username": username,
            "friends": friends,
            "first_name": firstName,
            "last_name": lastName,
            "gender": gender,
            "birthday": birthday,
            "picture": profilePicture?.toJSON()
        ]
    }
    
    var description: String {
        return String(describing: toJSON())
    }
}
