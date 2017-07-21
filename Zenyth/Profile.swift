//
//  Profile.swift
//  Zenyth
//
//  Created by Hoang on 7/20/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON

class Profile: NSObject, NSCoding {
    let json: JSON
    var userId: UInt32
    var firstName: String?
    var lastName: String?
    var gender: String?
    var birthday: String?
    
    init(userId: UInt32, firstName: String?, lastName: String?, gender: String?,
        birthday: String?) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.birthday = birthday
        
        self.json = [
            "user_id" : userId,
            "first_name" : firstName ?? "",
            "last_name" : lastName ?? "",
            "gender" : gender ?? "",
            "birthday" : birthday ?? ""
        ]
    }
    
    init(json: JSON) {
        self.userId = json["user_id"].uInt32Value
        self.firstName = json["first_name"].string
        self.lastName = json["last_name"].string
        self.gender = json["gender"].string
        
        let date = json["birthday"]["date"].string
        if let str = date {
            let index = str.index(str.startIndex, offsetBy: 10)
            self.birthday = str.substring(to: index)
        }
        
        let profileJSON: JSON = [
            "user_id" : userId,
            "first_name" : firstName ?? "",
            "last_name" : lastName ?? "",
            "gender" : gender ?? "",
            "birthday" : birthday ?? ""
        ]
        self.json = profileJSON
    }
    
    override var description: String {
        return self.json.description
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let userId = aDecoder.decodeInteger(forKey: "user_id")
        let firstName = aDecoder.decodeObject(forKey: "first_name") as! String
        let lastName = aDecoder.decodeObject(forKey: "last_name") as! String
        let gender = aDecoder.decodeObject(forKey: "gender") as! String
        let birthday = aDecoder.decodeObject(forKey: "birthday") as! String
        self.init(userId: UInt32(userId), firstName: firstName, lastName: lastName,
                  gender: gender, birthday: birthday)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userId, forKey: "user_id")
        aCoder.encode(firstName, forKey: "first_name")
        aCoder.encode(lastName, forKey: "last_name")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(birthday, forKey: "birthday")
    }

}
