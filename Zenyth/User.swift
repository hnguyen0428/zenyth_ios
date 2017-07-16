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
    let id: UInt64
    var username: String
    var email: String
    var api_token: String?
    var first_name: String?
    var last_name: String?
    var gender: String?
    var birthday: String?
    
    init(json: JSON) {
        self.id = json["data"]["user"]["id"].uInt64Value
        self.username = json["data"]["user"]["username"].stringValue
        self.email = json["data"]["user"]["email"].stringValue
        self.api_token = json["data"]["api_token"].string
        self.first_name = json["data"]["profile"]["first_name"].string
        self.last_name = json["data"]["profile"]["last_name"].string
        self.gender = json["data"]["profile"]["gender"].string
        
        let dateTime = json["data"]["profile"]["birthday"]["date"].string
        
        if let str = dateTime {
            let index = str.index(str.startIndex, offsetBy: 10)
            self.birthday = str.substring(to: index)
        }
        
        let userJSON: JSON = [
            "id" : id,
            "username" : username,
            "email" : email,
            "api_token" : api_token,
            "first_name" : first_name,
            "last_name" : last_name,
            "gender" : gender,
            "birthday" : birthday
        ]
        self.json = userJSON
    }
    
    override var description: String {
        return self.json.description
    }
    
    func getUser() -> JSON{
        return json
    }
    
}
