//
//  TabOne.swift
//  Zenyth
//
//  Created by Hoang on 7/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

extension LoginController {
    func setupTabOne() {
        clearTextFields()
        hideErrorLabel()
        enableButton(1)
        enableSecureEntry(false)
        iconOne.image = #imageLiteral(resourceName: "user")
        iconTwo.image = #imageLiteral(resourceName: "mail")
        setTintColor(false)
        textFieldOne.inputView = nil
        textFieldTwo.inputView = nil
        textLabelOne.text = "USERNAME"
        textLabelTwo.text = "EMAIL"
        if let text = username {
            textFieldOne.text = text
        }
        if let text = email {
            textFieldTwo.text = text
        }
        
        textFieldOne.removeTarget(nil, action: nil, for: .allEvents)
        textFieldTwo.removeTarget(nil, action: nil, for: .allEvents)
        // Run a timer when user starts editing, once the timer ends, it will
        // trigger a method to check if username or email is valid
        textFieldOne.addTarget(self, action: #selector(timeBeforeCheckTabOne),
                               for: .editingChanged)
        textFieldTwo.addTarget(self, action: #selector(timeBeforeCheckTabOne),
                               for: .editingChanged)
    }
    
    func checkTabOne() -> Bool {
        return validEmail && validUsername
    }
    
    func timeBeforeCheckTabOne(_ textField: UITextView) {
        // Reset the timer if it has been started
        if self.checkTimer != nil {
            self.checkTimer!.invalidate()
            self.checkTimer = nil
        }
        
        // Saves data
        username = textFieldOne.text
        email = textFieldTwo.text
        
        // Disable button as soon as user starts editing
        disableButton()
        disableTabButtons(true)
        
        // If user is editing email field, start timer on checking email
        if textField == textFieldTwo {
            self.checkTimer = Timer.scheduledTimer(timeInterval:
                timeBetweenCheck, target: self,
                                  selector: #selector(checkValidEmail), userInfo: textField.text,
                                  repeats: false)
        }
        // If user is editing username field, start timer on checking username
        if textField == textFieldOne {
            self.checkTimer = Timer.scheduledTimer(timeInterval:
                timeBetweenCheck, target: self,
                                  selector: #selector(checkValidUsername),
                                  userInfo: textField.text, repeats: false)
        }
    }
    
    func checkValidUsername(_ timer: Timer) {
        disableTabButtons(false)
        let text = textFieldOne.text ?? ""
        
        if text != "" {
            if !(isValidLengthUsername(username: text)) {
                self.setUsernameError("usernameLengthError")
                return
            } else if !(isValidCharactersUsername(username: text)) {
                self.setUsernameError("notAlphaNumericError")
                return
            }
            
            // Start the activity indicator to indicate that request is loading
            indicatorOne.startAnimating()
            errorLabelOne.text = activityIndicatorChecking
            errorLabelOne.textColor = .lightGray
            
            APIClient.credentialManager().requestValidateUsername(username: text, onSuccess:
                { data in
                    if data["taken"].boolValue {
                        self.setUsernameError("usernameTaken")
                    } else {
                        self.setUsernameError("usernameAvailable")
                    }
                    
                    self.indicatorOne.stopAnimating()
                    self.checkAllFields()
            })
        }
    }
    
    func checkValidEmail(_ timer: Timer) {
        disableTabButtons(false)
        let text = textFieldTwo.text ?? ""
        
        if text != "" {
            if !(isValidEmail(email: text)) {
                self.setEmailError("notEmailError")
                return
            }
            
            // Start the activity indicator to indicate that request is loading
            indicatorTwo.startAnimating()
            errorLabelTwo.text = activityIndicatorChecking
            errorLabelTwo.textColor = .lightGray
            
            APIClient.credentialManager().requestValidateEmail(email: text, onSuccess:
                { data in
                    if data["taken"].boolValue {
                        self.setEmailError("emailTaken")
                    } else {
                        self.setEmailError("emailAvailable")
                    }
                    
                    self.indicatorTwo.stopAnimating()
                    self.checkAllFields()
            })
        }
    }
    
    func setUsernameError(_ type: String) {
        if type == "usernameLengthError" {
            self.errorLabelOne.text = self.usernameRules
            self.errorLabelOne.isHidden = false
            self.errorLabelOne.textColor = .red
            self.validUsername = false
            disableButton()
        }
        else if type == "notAlphaNumericError" {
            self.errorLabelOne.text = self.usernameInvalidCharacters
            self.errorLabelOne.isHidden = false
            self.errorLabelOne.textColor = .red
            self.validUsername = false
            disableButton()
        }
        else if type == "usernameTaken" {
            self.errorLabelOne.text = "\(textFieldOne.text!) " +
            "\(self.usernameTakenMessage)"
            self.errorLabelOne.isHidden = false
            self.errorLabelOne.textColor = .red
            self.validUsername = false
            disableButton()
        }
        else if type == "usernameAvailable" {
            self.errorLabelOne.text = "\(textFieldOne.text!) " +
            "\(self.usernameAvailableMessage)"
            self.errorLabelOne.isHidden = false
            self.errorLabelOne.textColor = .green
            self.validUsername = true
        }
    }
    
    func setEmailError(_ type: String) {
        if type == "notEmailError" {
            self.errorLabelTwo.text = self.invalidEmailMessage
            self.errorLabelTwo.isHidden = false
            self.errorLabelTwo.textColor = .red
            self.validEmail = false
            disableButton()
        }
        else if type == "emailTaken" {
            self.errorLabelTwo.text = self.emailTakenMessage
            self.errorLabelTwo.isHidden = false
            self.errorLabelTwo.textColor = .red
            self.validEmail = false
            disableButton()
        }
        else if type == "emailAvailable" {
            self.errorLabelTwo.text = self.emailAvailableMessage
            self.errorLabelTwo.isHidden = false
            self.errorLabelTwo.textColor = .green
            self.validEmail = true
        }
    }
    
}
