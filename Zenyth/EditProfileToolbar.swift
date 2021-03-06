//
//  EditProfileToolbar.swift
//  Zenyth
//
//  Created by Hoang on 8/19/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class EditProfileToolbar: UIToolbar {
    
    weak var cancelButton: UIButton?
    weak var saveButton: UIButton?
    
    // UI Sizing
    static let HEIGHT_OF_BUTTON: CGFloat = 0.75
    static let WIDTH_OF_BUTTON: CGFloat = 0.20
    static let FONT_SIZE: CGFloat = 15.0
    static let LEFT_INSET: CGFloat = 0.03
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let buttonWidth = frame.width * EditProfileToolbar.WIDTH_OF_BUTTON
        let buttonHeight = frame.height * EditProfileToolbar.HEIGHT_OF_BUTTON
        let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        let fontSize = EditProfileToolbar.FONT_SIZE
        
        let saveButton = UIButton(type: .system)
        self.saveButton = saveButton
        saveButton.frame = buttonFrame
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.black, for: .normal)
        saveButton.contentHorizontalAlignment = .right
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        
        let cancelButton = UIButton(type: .system)
        self.cancelButton = cancelButton
        cancelButton.frame = buttonFrame
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        
        let horizontalInset: CGFloat = self.frame.width * EditProfileToolbar.LEFT_INSET
        let container = UIView(frame: frame)
        container.backgroundColor = UIColor.clear
        container.addSubview(saveButton)
        container.addSubview(cancelButton)
        
        saveButton.anchor(nil, left: nil, bottom: container.bottomAnchor,
                           right: container.rightAnchor, topConstant: 0,
                           leftConstant: 0, bottomConstant: 0,
                           rightConstant: horizontalInset, widthConstant: buttonWidth,
                           heightConstant: buttonHeight)
        
        cancelButton.anchor(nil, left: container.leftAnchor, bottom: container.bottomAnchor,
                             right: nil, topConstant: 0,
                             leftConstant: horizontalInset, bottomConstant: 0,
                             rightConstant: 0, widthConstant: buttonWidth,
                             heightConstant: buttonHeight)
        
        self.backgroundColor = UIColor.white
        self.tintColor = UIColor.white
        self.isTranslucent = false
        self.barTintColor = UIColor.white
        self.addSubview(container)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
