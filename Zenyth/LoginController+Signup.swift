//
//  LoginController+Signup.swift
//  Zenyth
//
//  Created by Hoang on 7/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

extension LoginController {
    
    func setupSignupView() {
        formatTextField(textField: textFieldOne)
        formatTextField(textField: textFieldTwo)
        formatButton(button: tabOne)
        formatButton(button: tabTwo)
        
        registerButton.backgroundColor = disabledButtonColor
        registerButton.isEnabled = false
        registerButton.layer.cornerRadius = 20
        
        hideErrorLabel()
        indicatorOne.hidesWhenStopped = true
        indicatorTwo.hidesWhenStopped = true
        indicatorOne.transform = CGAffineTransform(
            scaleX: 0.75, y: 0.75
        )
        indicatorTwo.transform = CGAffineTransform(
            scaleX: 0.75, y: 0.75
        )
        hideButton.addTarget(self, action: #selector(hideSignupView),
                             for: .touchUpInside)
        
        tabOne.addTarget(self, action: #selector(tabOneAction), for: .touchUpInside)
        tabTwo.addTarget(self, action: #selector(tabTwoAction), for: .touchUpInside)
        tabThree.addTarget(self, action: #selector(tabThreeAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
        setupTabOne()
    }
    
    func registerButtonAction(_ sender: UIButton) {
        if self.notOfAge() {
            self.displayAlert(view: self, title: "Not Eligible",
                              message: notOfAgeMessage)
            return
        }
        
        let parameters: Parameters = [
            "username" : username!,
            "email" : email!,
            "password" : password!,
            "password_confirmation" : confirmPassword!,
            "gender" : gender!,
            "birthday" : dateOfBirth!
        ]
        
        let request = RegisterRequestor(parameters: parameters)
        
        let indicator = requestLoading(view: self.view)
        
        request.getJSON { data, error in
            self.requestDoneLoading(view: self.view, indicator: indicator)
            if (error != nil) {
                return
            }
            if (data?["success"].boolValue)! {
                let user = User.init(json: data!)
                print("User: \(user)")
                let alert = UIAlertController(
                    title: self.signupSuccessfulMessage,
                    message: self.checkEmailMessage,
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(title: "OK",
                                              style: UIAlertActionStyle.default, handler: { action in
                    self.clearInfo()
                    self.clearTextFields()
                    self.hideSignupView(UIButton())
                    self.disableButton()
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let errors = (data?["errors"].arrayValue)!
                var errorString = ""
                for item in errors {
                    errorString.append(item.stringValue + "\n")
                }
                // strip the newline character at the end
                errorString.remove(
                    at: errorString.index(before: errorString.endIndex)
                )
                
                self.displayAlert(view: self, title: "Login Failed",
                                  message: errorString)
            }
            
        }
        
    }

    
    func showSignupView(_ button: UIButton) {
        let pointOfSeparation = self.view.frame.height - self.signupView.frame.height
        let frame: CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width,
                                   height: pointOfSeparation)
        mask = UIView(frame: frame)
        mask!.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        UIView.animate(withDuration: 0.6, animations: {
            self.signupView.frame.origin.y = pointOfSeparation
        }, completion: { bool in
            self.view.addSubview(self.mask!)
            self.textFieldOne.becomeFirstResponder()
        })
    }
    
    func hideSignupView(_ button: UIButton) {
        mask?.removeFromSuperview()
        UIView.animate(withDuration: 0.6, animations: {
            self.signupView.frame.origin.y = self.view.frame.height
        })
    }
    
    func tabOneAction(_ button: UIButton) {
        setupTabOne()
        self.textFieldOne.becomeFirstResponder()
        checkValidEmail(Timer.init())
        checkValidUsername(Timer.init())
    }
    
    func tabTwoAction(_ button: UIButton) {
        setupTabTwo()
        self.textFieldOne.becomeFirstResponder()
        checkValidPassword(Timer.init())
    }
    
    func tabThreeAction(_ button: UIButton) {
        setupTabThree()
        self.textFieldOne.becomeFirstResponder()
    }
    
    func enableButton(_ identifier: Int) {
        if identifier == 1 {
            tabOne.backgroundColor = blueButtonColor
            tabTwo.backgroundColor = disabledButtonColor
            tabThree.backgroundColor = disabledButtonColor
            currentTab = 1
        }
        else if identifier == 2 {
            tabOne.backgroundColor = disabledButtonColor
            tabTwo.backgroundColor = blueButtonColor
            tabThree.backgroundColor = disabledButtonColor
            currentTab = 2
        }
        else if identifier == 3 {
            tabOne.backgroundColor = disabledButtonColor
            tabTwo.backgroundColor = disabledButtonColor
            tabThree.backgroundColor = blueButtonColor
            currentTab = 3
        }
    }
    
    func enableSecureEntry(_ enable: Bool) {
        if enable {
            textFieldOne.isSecureTextEntry = true
            textFieldTwo.isSecureTextEntry = true
        } else {
            textFieldOne.isSecureTextEntry = false
            textFieldTwo.isSecureTextEntry = false
        }
    }
    
    func saveInformation() {
        if currentTab == 1 {
            username = textFieldOne.text
            email = textFieldTwo.text
        }
        else if currentTab == 2 {
            password = textFieldOne.text
            confirmPassword = textFieldTwo.text
        }
        else if currentTab == 3 {
            gender = textFieldOne.text
            dateOfBirth = textFieldTwo.text
        }
    }
    
    func clearTextFields() {
        textFieldOne.text = ""
        textFieldTwo.text = ""
    }
    
    func checkAllFields() {
        let tabOne = checkTabOne()
        let tabTwo = checkTabTwo()
        let tabThree = checkTabThree()
        
        if tabOne && tabTwo && tabThree {
            enableButton()
        }
    }
    
    func setTintColor(_ clear: Bool) {
        if clear {
            textFieldOne.tintColor = .clear
            textFieldTwo.tintColor = .clear
        }
        else {
            textFieldOne.tintColor = .black
            textFieldTwo.tintColor = .black
        }
    }
    
    func disableButton() {
        registerButton.isEnabled = false
        registerButton.backgroundColor = disabledButtonColor
    }
    
    func enableButton() {
        registerButton.isEnabled = true
        registerButton.backgroundColor = blueButtonColor
    }
    
    func hideErrorLabel() {
        errorLabelOne.isHidden = true
        errorLabelTwo.isHidden = true
    }
    
    func disableTabButtons(_ disable: Bool) {
        if disable {
            tabOne.isEnabled = false
            tabTwo.isEnabled = false
            tabThree.isEnabled = false
        }
        else {
            tabOne.isEnabled = true
            tabTwo.isEnabled = true
            tabThree.isEnabled = true

        }
    }
}
