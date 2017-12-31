//
//  UITextField+Helpers.swift
//  Zenyth
//
//  Created by Hoang on 8/19/17.
//  Copyright © 2017 Hoang. All rights reserved.
//


import UIKit

extension UITextField {
    func bottomBorder(color: CGColor = UIColor.lightGray.cgColor) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,
                              width:  self.frame.size.width,
                              height: self.frame.size.height)
        
        border.borderWidth = 1
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
