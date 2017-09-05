//
//  ProfileEditView.swift
//  Zenyth
//
//  Created by Hoang on 8/19/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class ProfileEditView: UIView {
    
    weak var firstNameField: UITextField?
    weak var lastNameField: UITextField?
    weak var genderField: UITextField?
    weak var birthdayField: UITextField?
    weak var biographyField: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.setupNameFields()
        self.setupGenderField()
        self.setupBirthdayField()
        self.setupBiographyField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupNameFields() {
        let fieldHeight = self.frame.height / 4
        let fieldWidth = self.frame.width
        let frame = CGRect(x: 0, y: 0, width: fieldWidth, height: fieldHeight)
        let field = DoubleTextFieldView(frame: frame, image: #imageLiteral(resourceName: "name-icon"))
        firstNameField = field.textfieldOne!
        firstNameField!.placeholder = "First Name"
        lastNameField = field.textfieldTwo!
        lastNameField!.placeholder = "Last Name"
        self.addSubview(field)
    }
    
    func setupGenderField() {
        let fieldHeight = self.frame.height / 4
        let fieldWidth = self.frame.width
        let frame = CGRect(x: 0, y: fieldHeight * 1, width: fieldWidth, height: fieldHeight)
        
        let field = ImageTextFieldView(frame: frame, image: #imageLiteral(resourceName: "gendericon"))
        genderField = field.textfield!
        genderField!.placeholder = "Gender"
        self.addSubview(field)
    }
    
    func setupBirthdayField() {
        let fieldHeight = self.frame.height / 4
        let fieldWidth = self.frame.width
        let frame = CGRect(x: 0, y: fieldHeight * 2, width: fieldWidth, height: fieldHeight)
        
        let field = ImageTextFieldView(frame: frame, image: #imageLiteral(resourceName: "calendar"))
        birthdayField = field.textfield!
        birthdayField!.tintColor = UIColor.clear
        birthdayField!.placeholder = "Birthday"
        self.addSubview(field)
    }
    
    func setupBiographyField() {
        let fieldHeight = self.frame.height / 4
        let fieldWidth = self.frame.width
        let frame = CGRect(x: 0, y: fieldHeight * 3, width: fieldWidth, height: fieldHeight)
        
        let field = ImageTextFieldView(frame: frame, image: #imageLiteral(resourceName: "biography_icon"))
        biographyField = field.textfield!
        biographyField!.placeholder = "Biography"
        self.addSubview(field)
    }
    
    func setFirstName(_ text: String) {
        firstNameField?.text = text
    }
    
    func setLastName(_ text: String) {
        lastNameField?.text = text
    }
    
    func setGender(_ text: String) {
        genderField?.text = text
    }
    
    func setBirthday(_ text: String) {
        birthdayField?.text = text
    }
    
    func setBiography(_ text: String) {
        biographyField?.text = text
    }
    
    func firstName() -> String {
        return firstNameField!.text ?? ""
    }
    
    func lastName() -> String {
        return lastNameField!.text ?? ""
    }
    
    func gender() -> String {
        return genderField!.text ?? ""
    }
    
    func birthday() -> String {
        return birthdayField!.text ?? ""
    }
    
    func biography() -> String {
        return biographyField!.text ?? ""
    }
}
