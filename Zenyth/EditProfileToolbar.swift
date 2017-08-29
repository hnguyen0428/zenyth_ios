//
//  EditProfileToolbar.swift
//  Zenyth
//
//  Created by Hoang on 8/19/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class EditProfileToolbar: UIToolbar {
    
    var cancelButton: UIButton?
    var saveButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let buttonWidth = frame.width * 0.30
        let buttonHeight = frame.height * 0.75
        let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        
        saveButton = UIButton(type: .system)
        saveButton!.frame = buttonFrame
        saveButton!.setTitle("Save", for: .normal)
        saveButton!.setTitleColor(UIColor.black, for: .normal)
        saveButton?.contentHorizontalAlignment = .right
        saveButton!.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        cancelButton = UIButton(type: .system)
        cancelButton!.frame = buttonFrame
        cancelButton!.setTitle("Cancel", for: .normal)
        cancelButton!.setTitleColor(UIColor.black, for: .normal)
        cancelButton?.contentHorizontalAlignment = .left
        cancelButton!.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        let horizontalInset: CGFloat = 15.0
        let container = UIView(frame: frame)
        container.backgroundColor = UIColor.clear
        container.addSubview(saveButton!)
        container.addSubview(cancelButton!)
        
        saveButton?.anchor(nil, left: nil, bottom: container.bottomAnchor,
                           right: container.rightAnchor, topConstant: 0,
                           leftConstant: 0, bottomConstant: 0,
                           rightConstant: horizontalInset, widthConstant: buttonWidth,
                           heightConstant: buttonHeight)
        
        cancelButton?.anchor(nil, left: container.leftAnchor, bottom: container.bottomAnchor,
                             right: nil, topConstant: 0,
                             leftConstant: horizontalInset, bottomConstant: 0,
                             rightConstant: 0, widthConstant: buttonWidth,
                             heightConstant: buttonHeight)
        
        self.addSubview(container)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
