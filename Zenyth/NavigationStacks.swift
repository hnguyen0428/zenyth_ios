//
//  NavigationStacks.swift
//  Zenyth
//
//  Created by Hoang on 9/2/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

/**
 This class contains static variables that are used to store the navigation
 stacks to reuse them
 */
class NavigationStacks {
    
    static let shared = NavigationStacks()
    
    private init() {}
    
    var feedNC: UINavigationController?
    var notificationNC: UINavigationController?
    var profileNC: UINavigationController?
    var stackIndex = 0
    
    func clearStacks() {
        self.feedNC = nil
        self.notificationNC = nil
        self.profileNC = nil
        self.stackIndex = 0
    }
}
