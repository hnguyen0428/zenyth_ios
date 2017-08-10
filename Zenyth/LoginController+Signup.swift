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
        signupView.isHidden = true
        self.view.addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(hideSignupView))
        formatTextField(textField: textFieldOne,
                        color: UIColor.darkGray.cgColor)
        formatTextField(textField: textFieldTwo,
                        color: UIColor.darkGray.cgColor)
        formatImageView(imageView: iconOneBorder, color: UIColor.darkGray.cgColor)
        formatImageView(imageView: iconTwoBorder, color: UIColor.darkGray.cgColor)
        
        formatButton(button: tabOne)
        formatButton(button: tabTwo)
        textFieldOne.autocorrectionType = UITextAutocorrectionType.no
        textFieldTwo.autocorrectionType = UITextAutocorrectionType.no
        textLabelOne.textColor = disabledButtonColor
        textLabelTwo.textColor = disabledButtonColor
        
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
        let indicator = requestLoading(view: self.view)
        
        RegistrationManager().register(withUsername: username!,
                                       email: email!,
                                       password: password!,
                                       passwordConfirmation: confirmPassword!,
                                       gender: gender!.lowercased(),
                                       birthday: dateOfBirth!,
                                       onSuccess:
            { user, apiToken in
                self.requestDoneLoading(view: self.view, indicator: indicator)
                print(user)
                
                let alert = UIAlertController(
                    title: self.signupSuccessfulMessage,
                    message: self.checkEmailMessage,
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(title: "OK",
                                              style: UIAlertActionStyle.default, handler:
                    { action in
                        self.clearInfo()
                        self.clearTextFields()
                        self.hideSignupViewHelper()
                        self.disableButton()
                }))
                
                self.present(alert, animated: true, completion: nil)
        })
    }

    
    func showSignupView(_ button: UIButton) {
        signupView.isHidden = false
        mask = UIView(frame: self.view.frame)
        mask!.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.addSubview(self.mask!)
        self.showSignupViewHelper()
    }
    
    func showSignupViewHelper(_ showKeyboard: Bool = true) {
        let pointOfSeparation = self.view.frame.height - self.signupView.frame.height
        UIView.animate(withDuration: 0.2, animations: {
            self.signupView.frame.origin.y = pointOfSeparation
            self.mask!.frame.origin.y = -self.signupView.frame.height
        }, completion: { bool in
            if showKeyboard {
                self.textFieldOne.becomeFirstResponder()
            }
        })
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
    }
    
    func hideSignupView(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        let view = self.view.hitTest(location, with: nil)
        
        if sender.state == .began {
            if view == signupView {
                return
            }
        }
        
        if sender.state == .changed {
            if view == signupView {
                return
            }
            let translation = sender.translation(in: self.view)
            
            // Check if swiping down
            if grabbed || (location.y >= signupView.frame.origin.y && translation.y > 0) {
                grabbed = true
                sender.setTranslation(CGPoint.zero, in: self.view)
                self.dismissKeyboard()
                signupView.frame.origin.y = location.y
                mask!.frame.origin.y = location.y - mask!.frame.height
            }
        }
        // check where the signup view is at
        if sender.state == .ended {
            grabbed = false
            let yCoord = signupView.frame.origin.y
            let originalY = self.view.frame.height - signupView.frame.height
            let velocityY = sender.velocity(in: self.view).y
            
            // If the swipe is long or fast enough it will hide
            if velocityY > 3000.0 ||
                (yCoord - originalY > signupView.frame.height * 0.60) {
                hideSignupViewHelper()
            } else { // Moves the signupView back to its original position
                showSignupViewHelper(false)
            }
        }
        
    }
    
    func hideSignupViewHelper() {
        self.dismissKeyboard()
        mask?.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: {
            self.signupView.frame.origin.y = self.view.frame.height
        }, completion: { bool in
            self.signupView.isHidden = true
        })
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(self.keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
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
