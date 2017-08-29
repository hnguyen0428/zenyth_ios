//
//  PinpostForm.swift
//  Zenyth
//
//  Created by Hoang on 8/23/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class PinpostForm {
    
    static var shared = PinpostForm()
    
    private init() {}
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String = String()
    var description: String = String()
    var privacy: String = String()
    var location: GMSAddress = GMSAddress()
    var pressedCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var usePressedCoordinate: Bool = true
    
    func clearInfo() {
        coordinate = CLLocationCoordinate2D()
        pressedCoordinate = CLLocationCoordinate2D()
        title = String()
        description = String()
        privacy = String()
        location = GMSAddress()
    }
}
