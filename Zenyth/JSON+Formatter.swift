//
//  JSON+Formatter.swift
//  Zenyth
//
//  Created by Hoang on 7/15/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON

extension JSON {
    
    public var date: NSDate? {
        get {
            switch self.type {
            case is String:
                return Formatter.jsonDateFormatter.date(from: self.object as! String) as! NSDate
            default:
                return nil
            }
        }
    }
}
