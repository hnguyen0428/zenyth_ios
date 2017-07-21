//
//  User.swift
//  Zenyth
//
//  Created by Hoang on 7/14/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON

class User: NSObject {
    
    let json: JSON
    var id: UInt32
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
    
    func getData() -> [String:Any] {
        return self.json.dictionaryObject!
    }
    
}
