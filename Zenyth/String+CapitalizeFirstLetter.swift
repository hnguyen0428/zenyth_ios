//
//  String+CapitalizeFirstLetter.swift
//  Zenyth
//
//  Created by Hoang on 8/20/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
