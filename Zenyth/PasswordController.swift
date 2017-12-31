//
//  PasswordController.swift
//  Zenyth
//
//  Created by Hoang on 8/11/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

/// PasswordController handling the password registration page
class PasswordController: ModelViewController {
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var confirmPwField: UITextField!
    @IBOutlet weak var pwErrorLabel: UILabel!
    @IBOutlet weak var confirmPwErrorLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var pwIconBorder: UIImageView!
    @IBOutlet weak var confirmPwIconBorder: UIImageView!
    
    /// Timer used to check for validity of password
    var checkTimer: Timer? = nil
    
    /**
     Setup views and add target to buttons
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        // Add a timer to check for validity of password
        pwField.addTarget(self, action: #selector(timeBeforeCheckPw),
                               for: .editingChanged)
        
        // Add a timer to check for validity of password confirmation
        confirmPwField.addTarget(self, action: #selector(timeBeforeCheckPw),
                               for: .editingChanged)
        
        // Allow the user to edit the password field as soon as the page is loaded
        pwField.becomeFirstResponder()
    }
    
    /**
     Setup view of the Password page
     */
    func setupViews() {
        // Remove background
        backgroundView.removeFromSuperview()
        
        // Format the imageviews and textfields
        formatImageView(imageView: pwIconBorder, color: UIColor.darkGray.cgColor)
        formatImageView(imageView: confirmPwIconBorder, color: UIColor.darkGray.cgColor)
        formatTextField(textField: pwField, color: UIColor.darkGray.cgColor)
        formatTextField(textField: confirmPwField, color: UIColor.darkGray.cgColor)
        
        // Hide error labels
        pwErrorLabel.isHidden = true
        confirmPwErrorLabel.isHidden = true
        
        // Setup continue button
        continueButton.backgroundColor = disabledButtonColor
        continueButton.isEnabled = false
        continueButton.layer.cornerRadius = 20
    }
    
    /**
     Called when the view has appeared.
     Immediately check if the password is valid whenever the view appears so
     that if it is valid, the button is enabled. This is to prevent the button
     from being disabled whenever the user needs to go back to the previous page.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prefill the textfields if the information has already been filled
        // before
        let module = RegistrationModule.sharedInstance
        pwField.text = module.password
        confirmPwField.text = module.passwordConfirmation
        checkValidPassword(Timer.init())
    }
    
    /**
     Trigger a timer that check for validity of password after 0.6 seconds.
     Also save data to RegistrationModule
     
     - Parameter textField: textfield being edited
     */
    func timeBeforeCheckPw(_ textField: UITextField) {
        // Reset the timer if it has been started
        if self.checkTimer != nil {
            self.checkTimer!.invalidate()
            self.checkTimer = nil
        }
        
        // Save data
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
    
    /** 
     Check validity of password
     
     - Parameter timer: timer being run
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
    
    /**
     Set the password error label depending on the type of error
     Called by checkValidPassword()
     
     - Parameter type: type of error
     */
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
    
    /**
     Set the confirm password error label depending on the type of error
     Called by checkValidPassword()
     
     - Parameter type: type of error
     */
    func setErrorConfirmPassword() {
        confirmPwErrorLabel.text = RegistrationModule.confirmPasswordNotMatchError
        confirmPwErrorLabel.textColor = .red
        confirmPwErrorLabel.isHidden = false
        disableButton()
    }
    
    /**
     Disable the continue button
     */
    func disableButton() {
        continueButton.isEnabled = false
        continueButton.backgroundColor = disabledButtonColor
    }
    
    /**
     Enable the continue button
     */
    func enableButton() {
        continueButton.isEnabled = true
        continueButton.backgroundColor = blueButtonColor
    }
    
}
