//
//  Formatter.swift
//  Zenyth
//
//  Created by Hoang on 7/15/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import SwiftyJSON


class Formatter {
    
    private static var internalJsonDateFormatter: DateFormatter?
    
    static var jsonDateFormatter: DateFormatter {
        if (internalJsonDateFormatter == nil) {
            internalJsonDateFormatter = DateFormatter()
            internalJsonDateFormatter!.dateFormat = "yyyy-MM-dd"
        }
        return internalJsonDateFormatter!
    }
    
}
