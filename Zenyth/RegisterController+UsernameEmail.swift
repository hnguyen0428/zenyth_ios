//
//  RegisterController.swift
//  Zenyth
//
//  Created by Hoang on 7/3/17.
//  Copyright © 2017 Hoang. All rights reserved.
//


import LBTAComponents
import Alamofire
import SwiftyJSON

class UsernameEmailController: RegisterController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        usernameField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        for subview in view.subviews {
            if !(subview is UIScrollView) && !(subview is UIImageView) {
                print("Subview: ", subview)
                scrollView.addSubview(subview)
            }
        }
        
    }
    
    func setupViews() {
        continueButton.backgroundColor = disabledButtonColor
        continueButton.layer.cornerRadius = 20
        continueButton.isEnabled = false
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        emailField.autocorrectionType = UITextAutocorrectionType.no
        
        formatTextField(textField: usernameField)
        formatTextField(textField: emailField)
    }
    
    
    
    /* Overridden rules for checking the field before enabling the button
     */
    override func fieldCheck() {
        
        guard
            let username = usernameField.text, !username.isEmpty,
            let email = emailField.text, !email.isEmpty && isValidEmail(testStr: email)
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
        fieldCheck()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPassword" {
            let resultVC = segue.destination  as! PasswordController
            resultVC.username = usernameField.text
            resultVC.email = emailField.text
            resultVC.password = password
            resultVC.confirmPassword = confirmPassword
            resultVC.gender = gender
            resultVC.dateOfBirth = dateOfBirth
        }
    }
    
}
