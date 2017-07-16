//
//  RegisterController+Password.swift
//  Zenyth
//
//  Created by Hoang on 7/14/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class PasswordController: RegisterController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    var checkTimer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        passwordField.addTarget(self, action: #selector(timeBeforeCheck),
                                for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(timeBeforeCheck),
                                       for: .editingChanged)
        
        NotificationCenter.default.addObserver(self,
                                selector: #selector(self.keyboardWillShow),
                                name: NSNotification.Name.UIKeyboardWillShow,
                                object: nil)
        NotificationCenter.default.addObserver(self,
                                selector: #selector(self.keyboardWillHide),
                                name: NSNotification.Name.UIKeyboardWillHide,
                                object: nil)
        
        for subview in view.subviews {
            if !(subview is UIScrollView) && !(subview is UIImageView) {
                scrollView.addSubview(subview)
            }
        }
        
    }
    
    func setupViews() {
        continueButton.backgroundColor = disabledButtonColor
        continueButton.layer.cornerRadius = 20
        continueButton.isEnabled = false
        
        formatTextField(textField: passwordField)
        formatTextField(textField: confirmPasswordField)
        
        passwordField.text = password
        confirmPasswordField.text = confirmPassword
        
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
    }
    
    func timeBeforeCheck(_ textField: UITextField) {
        if self.checkTimer != nil {
            self.checkTimer!.invalidate()
            self.checkTimer = nil
        }
        
        // hides errors while typing
        continueButton.isEnabled = false
        continueButton.backgroundColor = disabledButtonColor
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
        
        self.checkTimer = Timer.scheduledTimer(timeInterval: timeBetweenCheck,
                        target: self, selector: #selector(checkValidPassword),
                        userInfo: textField.text, repeats: false)
        
    }
    
    /* Overridden rules for checking the field before enabling the button
     */
    func checkValidPassword(_ timer: Timer) {
        let password = passwordField.text ?? ""
        let confirmPassword = confirmPasswordField.text ?? ""
        
        if password == "" && confirmPassword == "" {
            passwordErrorLabel.isHidden = true
            confirmPasswordErrorLabel.isHidden = true
            continueButton.isEnabled = false
            continueButton.backgroundColor = disabledButtonColor
            return
        }
        
        if password != "" {
            if isAlphaNumeric(testStr: password) { // is alpha numeric
                let count = password.characters.count
                if count > maximumPasswordLength ||
                    count < minimumPasswordLength {
                    setErrorPassword("LengthError")
                    return
                } // does not satisfy length requirement
            } else { // not alpha numeric
                setErrorPassword("AlphaNumericError")
                return
            }
        }
        
        // password passed
        
        if confirmPassword != "" {
            if confirmPassword != password {
                setErrorConfirmPassword()
                return
            }
        } else {
            passwordErrorLabel.isHidden = true
            confirmPasswordErrorLabel.isHidden = true
            continueButton.isEnabled = false
            continueButton.backgroundColor = disabledButtonColor
            return
        }
        
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
        continueButton.isEnabled = true
        continueButton.backgroundColor = buttonColor
        
    }
    
    func setErrorPassword(_ type: String) {
        if type == "AlphaNumericError" {
            passwordErrorLabel.text = passwordAlphaNumericError
            passwordErrorLabel.textColor = .red
            passwordErrorLabel.isHidden = false
            continueButton.isEnabled = false
            continueButton.backgroundColor = disabledButtonColor
        }
        if type == "LengthError" {
            passwordErrorLabel.text = passwordLengthError
            passwordErrorLabel.textColor = .red
            passwordErrorLabel.isHidden = false
            continueButton.isEnabled = false
            continueButton.backgroundColor = disabledButtonColor
        }
    }
    
    func setErrorConfirmPassword() {
        confirmPasswordErrorLabel.text = confirmPasswordNotMatchError
        confirmPasswordErrorLabel.textColor = .red
        confirmPasswordErrorLabel.isHidden = false
        continueButton.isEnabled = false
        continueButton.backgroundColor = disabledButtonColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        checkValidPassword(Timer.init())
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if let usernameEmailVC = viewController as? UsernameEmailController {
            usernameEmailVC.password = passwordField.text
            usernameEmailVC.confirmPassword = confirmPasswordField.text
            usernameEmailVC.gender = gender
            usernameEmailVC.dateOfBirth = dateOfBirth
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGenderBirthday" {
            let resultVC = segue.destination  as! GenderBirthdayController
            resultVC.username = username
            resultVC.email = email
            resultVC.password = passwordField.text
            resultVC.confirmPassword = confirmPasswordField.text
            resultVC.gender = gender
            resultVC.dateOfBirth = dateOfBirth
        }
    }
    
}
