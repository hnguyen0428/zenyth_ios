//
//  UIButton+roundedButton.swift
//  Zenyth
//
//  Created by Hoang on 8/11/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

extension UIImageView {
    func leftRoundedImageView(){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topLeft , .bottomLeft],
                                     cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPAth1.cgPath
        self.layer.mask = maskLayer
    }
}

extension UITextField {
    func rightRoundedField(){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topRight , .bottomRight],
                                     cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPAth1.cgPath
        self.layer.mask = maskLayer
    }
}
