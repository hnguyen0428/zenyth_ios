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
    var firstName: String?
    var lastName: String?
    var gender: String?
    var birthday: String?
    
    init(json: JSON) {
        let user: JSON = json["data"]["user"]
        id = user["id"].uInt32Value
        email = user["email"].string
        username = user["username"].stringValue
        
        let profile: JSON = user["profile"]
        firstName = profile["first_name"].string
        lastName = profile["last_name"].string
        gender = profile["gender"].string
        
        let date = profile["birthday"]["data"].string
        if let str = date {
            let index = str.index(str.startIndex, offsetBy: 10)
            birthday = str.substring(to: index)
        }
    }
    
    func toJSON() -> JSON {
        return [
            "id" : id,
            "email" : email,
            "username" : username,
            "first_name" : firstName,
            "last_name" : lastName,
            "gender" : gender,
            "birthday" : birthday
        ]
    }
}
