//
//  PinpostFormView.swift
//  Zenyth
//
//  Created by Hoang on 8/23/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class PinpostFormView: UIView {
    
    var titleField: UITextField!
    var descriptionField: UITextView!
    var locationField: UITextField!
    var usePressedLocationButton: UIButton!
    var privacyField: UITextField!
    
    // Height Dimension in percentage of the frames height
    static let HEIGHT_OF_TITLE: CGFloat = 0.08
    static let HEIGHT_OF_DESCRIPTION: CGFloat = 0.15
    static let HEIGHT_OF_LOCATION: CGFloat = 0.08
    static let HEIGHT_OF_BUTTON: CGFloat = 0.04
    static let HEIGHT_OF_PRIVACY: CGFloat = 0.08
    
    static let WIDTH_OF_BUTTON: CGFloat = 0.80
    
    static let TOP_MARGIN: CGFloat = 0.05
    static let GAP: CGFloat = 0.02
    static let LEFT_MARGIN: CGFloat = 0.05
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTitleField()
        self.setupDescriptionField()
        self.setupLocationField()
        self.setupUsePressedLocationButton()
        self.setupPrivacyField()
    }
    
    func setupTitleField() {
        let width = self.frame.width
        let height = self.frame.height * PinpostFormView.HEIGHT_OF_TITLE
        let x: CGFloat = 0
        let y = self.frame.height * PinpostFormView.TOP_MARGIN
        let frame = CGRect(x: x, y: y, width: width, height: height)
        titleField = UITextField(frame: frame)
        titleField.placeholder = "Title"
        titleField.backgroundColor = UIColor.white
        self.addSubview(titleField)
    }
    
    func setupDescriptionField() {
        let width = self.frame.width
        let height = self.frame.height * PinpostFormView.HEIGHT_OF_DESCRIPTION
        let x: CGFloat = 0
        let gap = self.frame.height * PinpostFormView.GAP
        let y = titleField.frame.maxY + gap
        let frame = CGRect(x: x, y: y, width: width, height: height)
        descriptionField = UITextView(frame: frame)
        descriptionField.text = "Give a description"
        descriptionField.textColor = UIColor.lightGray
        descriptionField.backgroundColor = UIColor.white
        descriptionField.font = titleField.font
        self.addSubview(descriptionField)
    }
    
    func setupLocationField() {
        let width = self.frame.width
        let height = self.frame.height * PinpostFormView.HEIGHT_OF_LOCATION
        let x: CGFloat = 0
        let gap = self.frame.height * PinpostFormView.GAP
        let y = descriptionField.frame.maxY + gap
        let frame = CGRect(x: x, y: y, width: width, height: height)
        locationField = UITextField(frame: frame)
        locationField.placeholder = "Add a location"
        locationField.backgroundColor = UIColor.white
        self.addSubview(locationField)
    }
    
    func setupUsePressedLocationButton() {
        let width = self.frame.width * PinpostFormView.WIDTH_OF_BUTTON
        let height = self.frame.height * PinpostFormView.HEIGHT_OF_BUTTON
        let x: CGFloat = self.frame.width * PinpostFormView.LEFT_MARGIN
        let y = locationField.frame.maxY
        let frame = CGRect(x: x, y: y, width: width, height: height)
        usePressedLocationButton = UIButton(type: .system)
        usePressedLocationButton.frame = frame
        usePressedLocationButton.setTitle("or use the location of where you pressed",
                                           for: .normal)
        
        self.addSubview(usePressedLocationButton)
        
        usePressedLocationButton.contentHorizontalAlignment = .left
    }
    
    func setupPrivacyField() {
        let width = self.frame.width
        let height = self.frame.height * PinpostFormView.HEIGHT_OF_PRIVACY
        let x: CGFloat = 0
        let gap = self.frame.height * PinpostFormView.GAP
        let y = usePressedLocationButton.frame.maxY + gap
        let frame = CGRect(x: x, y: y, width: width, height: height)
        privacyField = UITextField(frame: frame)
        privacyField.placeholder = "Who do you want to see this pinpost?"
        privacyField.tintColor = UIColor.clear
        privacyField.backgroundColor = UIColor.white
        self.addSubview(privacyField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
