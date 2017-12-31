//
//  Object.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON

protocol APIObject : CustomStringConvertible {
    
    /**
     Deserialize the json into an object
     
     - Parameter json: JSON to be deserialized
     - Returns: An object
     */
    init(json: JSON)
    
    /**
     Serialize the object into a JSON
     
     - Returns: JSON representation of object
     */
    func toJSON() -> JSON
    
}
