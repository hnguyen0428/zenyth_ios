//
//  User.swift
//  Zenyth
//
//  Created by Hoang on 7/14/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON

struct User : Object {
    var id: UInt32
    var email: String?
    var username: String
    var friends: UInt32
    var firstName: String?
    var lastName: String?
    var gender: String?
    var birthday: String?
    var profilePictureId: UInt32?
    
    init(json: JSON) {
        id = json["id"].uInt32Value
        email = json["email"].string
        username = json["username"].stringValue
        friends = json["friends"].uInt32Value
        
        let profile: JSON = json["profile"]
        firstName = profile["first_name"].string
        lastName = profile["last_name"].string
        gender = profile["gender"].string
        
        let date = profile["birthday"].string
        if let str = date {
            let index = str.index(str.startIndex, offsetBy: 10)
            birthday = str.substring(to: index)
        }
        
        profilePictureId = profile["picture_id"].uInt32
    }
    
    func toJSON() -> JSON {
        return [
            "id" : id,
            "email" : email,
            "username" : username,
            "friends" : friends,
            "first_name" : firstName,
            "last_name" : lastName,
            "gender" : gender,
            "birthday" : birthday,
            "picture_id" : profilePictureId
        ]
    }
}
