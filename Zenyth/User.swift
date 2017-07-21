//
//  User.swift
//  Zenyth
//
//  Created by Hoang on 7/14/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON

class User: NSObject, NSCoding {
    
    let json: JSON
    let id: UInt32
    var username: String
    var email: String
    var api_token: String?
    var profile: Profile
    
    init(id: UInt32, username: String, email: String, api_token: String?, profile: Profile) {
        self.id = id
        self.username = username
        self.email = email
        self.api_token = api_token
        self.profile = profile
        
        self.json = [
            "id" : id,
            "username" : username,
            "email" : email,
            "api_token" : api_token ?? "",
            "profile" : profile.json
        ]
    }
    
    init(json: JSON) {
        self.id = json["data"]["user"]["id"].uInt32Value
        self.username = json["data"]["user"]["username"].stringValue
        self.email = json["data"]["user"]["email"].stringValue
        self.api_token = json["data"]["api_token"].string
        
        self.profile = Profile.init(json: json["data"]["profile"])
        
        let userJSON: JSON = [
            "id" : id,
            "username" : username,
            "email" : email,
            "api_token" : api_token ?? "",
            "profile" : profile.json
        ]
        self.json = userJSON
    }
    
    override var description: String {
        return self.json.description
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let api_token = aDecoder.decodeObject(forKey: "api_token") as! String
        
        let userId = aDecoder.decodeInteger(forKey: "user_id")
        let firstName = aDecoder.decodeObject(forKey: "first_name") as! String
        let lastName = aDecoder.decodeObject(forKey: "last_name") as! String
        let gender = aDecoder.decodeObject(forKey: "gender") as! String
        let birthday = aDecoder.decodeObject(forKey: "birthday") as! String
        let profile = Profile.init(userId: UInt32(userId), firstName: firstName,
                                   lastName: lastName, gender: gender,
                                   birthday: birthday)
        
        self.init(id: UInt32(id), username: username, email: email, api_token: api_token, profile: profile)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(api_token, forKey: "api_token")
        aCoder.encode(profile.userId, forKey: "user_id")
        aCoder.encode(profile.firstName, forKey: "first_name")
        aCoder.encode(profile.lastName, forKey: "last_name")
        aCoder.encode(profile.gender, forKey: "gender")
        aCoder.encode(profile.birthday, forKey: "birthday")
    }
    
}
