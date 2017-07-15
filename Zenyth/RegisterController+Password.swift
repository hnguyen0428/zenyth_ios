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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        passwordField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        for subview in view.subviews {
            if !(subview is UIScrollView) && !(subview is UIImageView) {
                print("Subview: ", subview)
                scrollView.addSubview(subview)
            }
        }
        
        fieldCheck()
    }
    
    func setupViews() {
        continueButton.backgroundColor = disabledButtonColor
        continueButton.layer.cornerRadius = 20
        continueButton.isEnabled = false
        
        formatTextField(textField: passwordField)
        formatTextField(textField: confirmPasswordField)
        
        passwordField.text = password
        confirmPasswordField.text = confirmPassword
    }
    
    /* Overridden rules for checking the field before enabling the button
     */
    override func fieldCheck() {
        
        guard
            let password = passwordField.text, !password.isEmpty &&
                        password.characters.count >= minimumPasswordLength &&
                        password.characters.count <= maximumPasswordLength,
            let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty &&
                        confirmPassword.characters.count >= minimumPasswordLength &&
                        confirmPassword.characters.count <= maximumPasswordLength &&
                        confirmPassword == password
            else {
                continueButton.isEnabled = false
                continueButton.backgroundColor = disabledButtonColor
                return
        }
        continueButton.isEnabled = true
        continueButton.backgroundColor = buttonColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        fieldCheck()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
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
