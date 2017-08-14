//
//  PasswordController.swift
//  Zenyth
//
//  Created by Hoang on 8/11/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class PasswordController: ModelViewController {
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var confirmPwField: UITextField!
    @IBOutlet weak var pwErrorLabel: UILabel!
    @IBOutlet weak var confirmPwErrorLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var pwIconBorder: UIImageView!
    @IBOutlet weak var confirmPwIconBorder: UIImageView!
    
    var checkTimer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        pwField.addTarget(self, action: #selector(timeBeforeCheckPw),
                               for: .editingChanged)
        confirmPwField.addTarget(self, action: #selector(timeBeforeCheckPw),
                               for: .editingChanged)
        pwField.becomeFirstResponder()
    }
    
    func setupViews() {
        // Remove background
        backgroundView.removeFromSuperview()
        
        formatImageView(imageView: pwIconBorder, color: UIColor.darkGray.cgColor)
        formatImageView(imageView: confirmPwIconBorder, color: UIColor.darkGray.cgColor)
        
        formatTextField(textField: pwField, color: UIColor.darkGray.cgColor)
        formatTextField(textField: confirmPwField, color: UIColor.darkGray.cgColor)
        
        pwErrorLabel.isHidden = true
        confirmPwErrorLabel.isHidden = true
        
        continueButton.backgroundColor = disabledButtonColor
        continueButton.isEnabled = false
        continueButton.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let module = RegistrationModule.sharedInstance
        pwField.text = module.password
        confirmPwField.text = module.passwordConfirmation
        checkValidPassword(Timer.init())
    }
    
    func timeBeforeCheckPw(_ textField: UITextField) {
        // Reset the timer if it has been started
        if self.checkTimer != nil {
            self.checkTimer!.invalidate()
            self.checkTimer = nil
        }
        
        // Saves data
        let module = RegistrationModule.sharedInstance
        module.setPassword(password: pwField.text!)
        module.setPasswordConfirmation(passwordConfirmation: confirmPwField.text!)
        
        // Hide errors while typing
        disableButton()
        pwErrorLabel.isHidden = true
        confirmPwErrorLabel.isHidden = true
        
        self.checkTimer = Timer.scheduledTimer(timeInterval: timeBetweenCheck,
                                               target: self, selector: #selector(checkValidPassword),
                                               userInfo: textField.text, repeats: false)
        
    }
    
    /* Overridden rules for checking the field before enabling the button
     */
    func checkValidPassword(_ timer: Timer) {
        let password = pwField.text ?? ""
        let confirmPassword = confirmPwField.text ?? ""
        
        // If both are empty, disable buttons and hide error labels
        if password == "" && confirmPassword == "" {
            pwErrorLabel.isHidden = true
            confirmPwErrorLabel.isHidden = true
            disableButton()
            return
        }
        
        if password != "" {
            if isAlphaNumeric(testStr: password) { // is alpha numeric
                if !isValidLengthPassword(password: password) {
                    setErrorPassword("LengthError")
                    return
                } // does not satisfy length requirement
            } else { // not alpha numeric
                setErrorPassword("AlphaNumericError")
                return
            }
        }
        
        // Password passed
        
        if confirmPassword != "" {
            // Password confirmation is not the same as password
            if confirmPassword != password {
                setErrorConfirmPassword()
                return
            }
        } else {
            pwErrorLabel.isHidden = true
            confirmPwErrorLabel.isHidden = true
            disableButton()
            return
        }
        
        enableButton()
    }
    
    func setErrorPassword(_ type: String) {
        if type == "AlphaNumericError" {
            pwErrorLabel.text = RegistrationModule.passwordAlphaNumericError
            pwErrorLabel.textColor = .red
            pwErrorLabel.isHidden = false
            disableButton()
        }
        if type == "LengthError" {
            pwErrorLabel.text = RegistrationModule.passwordLengthError
            pwErrorLabel.textColor = .red
            pwErrorLabel.isHidden = false
            disableButton()
        }
    }
    
    func setErrorConfirmPassword() {
        confirmPwErrorLabel.text = RegistrationModule.confirmPasswordNotMatchError
        confirmPwErrorLabel.textColor = .red
        confirmPwErrorLabel.isHidden = false
        disableButton()
    }
    
    func disableButton() {
        continueButton.isEnabled = false
        continueButton.backgroundColor = disabledButtonColor
    }
    
    func enableButton() {
        continueButton.isEnabled = true
        continueButton.backgroundColor = blueButtonColor
    }
    
}
