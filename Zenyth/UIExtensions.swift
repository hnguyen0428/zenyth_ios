//
//  UIButton+roundedButton.swift
//  Zenyth
//
//  Created by Hoang on 8/11/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /**
     Format the image view to have rounded topleft and bottomleft corners
     */
    func leftRoundedImageView() {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topLeft , .bottomLeft],
                                     cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

extension UITextField {
    /**
     Format the textfield to have rounded topright and bottomright corners
     */
    func rightRoundedField() {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topRight , .bottomRight],
                                     cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

extension UIView {
    /**
     Format the view to have rounded bottom corners with shadow
     */
    func bottomRoundedWithShadow(radius: CGFloat) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds,
                                        byRoundingCorners: [.bottomLeft , .bottomRight],
                                        cornerRadii: CGSize(width: radius, height: radius)).cgPath
        shadowLayer.fillColor = self.backgroundColor?.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.shadowRadius = 2
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}
