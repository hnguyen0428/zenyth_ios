//
//  Object.swift
//  Zenyth
//
//  Created by Hoang on 8/7/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON

protocol APIObject : CustomStringConvertible {
    init(json: JSON)
    
    func toJSON() -> JSON
    
}
