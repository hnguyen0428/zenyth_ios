//
//  UIHelper.swift
//  Zenyth
//
//  Created by Hoang on 7/4/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import LBTAComponents

func formatTextField(textField: UITextField) {
    let border = CALayer()
    let width = CGFloat(1.0)
    border.borderColor = UIColor.lightGray.cgColor
    border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
    
    border.borderWidth = 1
    textField.layer.addSublayer(border)
    textField.layer.masksToBounds = true
}

