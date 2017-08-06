//
//  TabTwo.swift
//  Zenyth
//
//  Created by Hoang on 7/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

extension LoginController {
    func setupTabTwo() {
        clearTextFields()
        hideErrorLabel()
        enableButton(2)
        enableSecureEntry(true)
        iconOne.image = #imageLiteral(resourceName: "password")
        iconTwo.image = #imageLiteral(resourceName: "confirmpassword")
        setTintColor(false)
        textFieldOne.tintColor = .black
        textFieldOne.inputView = nil
        textFieldTwo.inputView = nil
        textLabelOne.text = "PASSWORD"
        textLabelTwo.text = "CONFIRM PASSWORD"
        if let text = password {
            textFieldOne.text = text
        }
        if let text = confirmPassword {
            textFieldTwo.text = text
        }
        textFieldOne.removeTarget(nil, action: nil, for: .allEvents)
        textFieldTwo.removeTarget(nil, action: nil, for: .allEvents)
        
        // Run a timer when user starts editing, once the timer ends, it will
        // trigger a method to check if username or email is valid
        textFieldOne.addTarget(self, action: #selector(timeBeforeCheckPw),
                                for: .editingChanged)
        textFieldTwo.addTarget(self, action: #selector(timeBeforeCheckPw),
                                       for: .editingChanged)
        textFieldOne.becomeFirstResponder()
    }
    
    func timeBeforeCheckPw(_ textField: UITextField) {
        // Reset the timer if it has been started
        if self.checkTimer != nil {
            self.checkTimer!.invalidate()
            self.checkTimer = nil
        }
        
        // Saves data
        password = textFieldOne.text
        confirmPassword = textFieldTwo.text
        
        // Hide errors while typing
        disableButton()
        disableTabButtons(true)
        errorLabelOne.isHidden = true
        errorLabelTwo.isHidden = true
        
        self.checkTimer = Timer.scheduledTimer(timeInterval: timeBetweenCheck,
                                               target: self, selector: #selector(checkValidPassword),
                                               userInfo: textField.text, repeats: false)
        
    }
    
    /* Overridden rules for checking the field before enabling the button
     */
    func checkValidPassword(_ timer: Timer) {
        disableTabButtons(false)
        let password = textFieldOne.text ?? ""
        let confirmPassword = textFieldTwo.text ?? ""
        
        // If both are empty, disable buttons and hide error labels
        if password == "" && confirmPassword == "" {
            errorLabelOne.isHidden = true
            errorLabelTwo.isHidden = true
            disableButton()
            self.validPw = false
            return
        }
        
        if password != "" {
            if isAlphaNumeric(testStr: password) { // is alpha numeric
                if !isValidLengthPassword(password: password) {
                    setErrorPassword("LengthError")
                    self.validPw = false
                    return
                } // does not satisfy length requirement
            } else { // not alpha numeric
                setErrorPassword("AlphaNumericError")
                self.validPw = false
                return
            }
        }
        
        // Password passed
        
        if confirmPassword != "" {
            // Password confirmation is not the same as password
            if confirmPassword != password {
                setErrorConfirmPassword()
                self.validPw = false
                return
            }
        } else {
            errorLabelOne.isHidden = true
            errorLabelTwo.isHidden = true
            disableButton()
            self.validPw = false
            return
        }
        
        self.validPw = true
        checkAllFields()
        
        
    }
    
    func setErrorPassword(_ type: String) {
        if type == "AlphaNumericError" {
            errorLabelOne.text = passwordAlphaNumericError
            errorLabelOne.textColor = .red
            errorLabelOne.isHidden = false
            disableButton()
        }
        if type == "LengthError" {
            errorLabelOne.text = passwordLengthError
            errorLabelOne.textColor = .red
            errorLabelOne.isHidden = false
            disableButton()
        }
    }
    
    func setErrorConfirmPassword() {
        errorLabelTwo.text = confirmPasswordNotMatchError
        errorLabelTwo.textColor = .red
        errorLabelTwo.isHidden = false
        disableButton()
    }
    
    func checkTabTwo() -> Bool {
        return self.validPw
    }
    
}
