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
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var usernameActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailActivityIndicator: UIActivityIndicatorView!
    
    var validEmail: Bool = false
    var validUsername: Bool = false
    var checkTimer: Timer? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        // Add action for button to segue into PasswordController
        continueButton.addTarget(self, action: #selector(toPasswordVC),
                                 for: .touchUpInside)
        
        // Run a timer when user starts editing, once the timer ends, it will
        // trigger a method to check if username or email is valid
        usernameField.addTarget(self, action: #selector(timeBeforeCheck),
                                for: .editingChanged)
        emailField.addTarget(self, action: #selector(timeBeforeCheck),
                             for: .editingChanged)
        
        self.clearInfo()
    }
    
    func setupViews() {
        continueButton.backgroundColor = disabledButtonColor
        continueButton.layer.cornerRadius = 20
        continueButton.isEnabled = false
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        emailField.autocorrectionType = UITextAutocorrectionType.no
        
        formatTextField(textField: usernameField)
        formatTextField(textField: emailField)
        
        usernameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        
        emailActivityIndicator.hidesWhenStopped = true
        usernameActivityIndicator.hidesWhenStopped = true
        
        // Makes the activity indicator smaller
        emailActivityIndicator.transform = CGAffineTransform(
            scaleX: 0.75, y: 0.75
        )
        usernameActivityIndicator.transform = CGAffineTransform(
            scaleX: 0.75, y: 0.75
        )
    }
    
    func toPasswordVC(_ button: UIButton) {
        self.performSegue(withIdentifier: "toPassword", sender: self)
    }
    
    func oauthSegue(_ button: UIButton) {
        
    }
    
    func timeBeforeCheck(_ textField: UITextField) {
        // Reset the timer if it has been started
        if self.checkTimer != nil {
            self.checkTimer!.invalidate()
            self.checkTimer = nil
        }
        
        // Disable button as soon as user starts editing
        fieldCheck(validEmail: false, validUsername: false)
        
        // If user is editing email field, start timer on checking email
        if textField == emailField {
            self.checkTimer = Timer.scheduledTimer(timeInterval:
                timeBetweenCheck, target: self,
                selector: #selector(checkValidEmail), userInfo: textField.text,
                repeats: false)
        }
        // If user is editing username field, start timer on checking username
        if textField == usernameField {
            self.checkTimer = Timer.scheduledTimer(timeInterval:
                timeBetweenCheck, target: self,
                selector: #selector(checkValidUsername),
                userInfo: textField.text, repeats: false)
        }
    }
    
    func checkValidUsername(_ timer: Timer) {
        let text = usernameField.text ?? ""
        
        if text != "" {
            if text.characters.count < minimumUsernameLength ||
                text.characters.count > maximumUsernameLength {
                self.setUsernameError("usernameLengthError")
                return
            } else if !(isValidUsername(testStr: text)) {
                self.setUsernameError("notAlphaNumericError")
                return
            }
            
            let request = UsernameTakenRequestor.init(username: text)
            
            // Start the activity indicator to indicate that request is loading
            usernameActivityIndicator.startAnimating()
            usernameErrorLabel.text = activityIndicatorChecking
            usernameErrorLabel.textColor = .lightGray
            
            request.getJSON { data, error in
                if error != nil {
                    return
                }
                
                if data!["data"].boolValue { // username taken
                    self.setUsernameError("usernameTaken")
                } else { // username available
                    self.setUsernameError("usernameAvailable")
                }
                self.usernameActivityIndicator.stopAnimating()
                self.fieldCheck(validEmail: self.validEmail,
                                validUsername: self.validUsername)
            }
        }
    }
    
    func checkValidEmail(_ timer: Timer) {
        let text = emailField.text ?? ""
        
        if text != "" {
            if !(isValidEmail(testStr: text)) {
                self.setEmailError("notEmailError")
                return
            }
            
            let request = EmailTakenRequestor.init(email: text)
            
            // Start the activity indicator to indicate that request is loading
            emailActivityIndicator.startAnimating()
            emailErrorLabel.text = activityIndicatorChecking
            emailErrorLabel.textColor = .lightGray
            
            request.getJSON { data, error in
                if error != nil {
                    return
                }
                
                if data!["data"].boolValue { // email taken
                    self.setEmailError("emailTaken")
                } else { // email available
                    self.setEmailError("emailAvailable")
                }
                self.emailActivityIndicator.stopAnimating()
                self.fieldCheck(validEmail: self.validEmail,
                                validUsername: self.validUsername)
            }
        }
    }
    
    func setUsernameError(_ type: String) {
        if type == "usernameLengthError" {
            self.usernameErrorLabel.text = self.usernameRules
            self.usernameErrorLabel.isHidden = false
            self.usernameErrorLabel.textColor = .red
            self.validUsername = false
            self.fieldCheck(validEmail: validEmail,
                            validUsername: validUsername)
        }
        else if type == "notAlphaNumericError" {
            self.usernameErrorLabel.text = self.usernameInvalidCharacters
            self.usernameErrorLabel.isHidden = false
            self.usernameErrorLabel.textColor = .red
            self.validUsername = false
            self.fieldCheck(validEmail: validEmail,
                            validUsername: validUsername)
        }
        else if type == "usernameTaken" {
            self.usernameErrorLabel.text = "\(usernameField.text!) " +
            "\(self.usernameTakenMessage)"
            self.usernameErrorLabel.isHidden = false
            self.usernameErrorLabel.textColor = .red
            self.validUsername = false
        }
        else if type == "usernameAvailable" {
            self.usernameErrorLabel.text = "\(usernameField.text!) " +
            "\(self.usernameAvailableMessage)"
            self.usernameErrorLabel.isHidden = false
            self.usernameErrorLabel.textColor = .green
            self.validUsername = true
        }
    }
    
    func setEmailError(_ type: String) {
        if type == "notEmailError" {
            self.emailErrorLabel.text = self.invalidEmailMessage
            self.emailErrorLabel.isHidden = false
            self.emailErrorLabel.textColor = .red
            self.validEmail = false
            self.fieldCheck(validEmail: validEmail,
                            validUsername: validUsername)
        }
        else if type == "emailTaken" {
            self.emailErrorLabel.text = self.emailTakenMessage
            self.emailErrorLabel.isHidden = false
            self.emailErrorLabel.textColor = .red
            self.validEmail = false
        }
        else if type == "emailAvailable" {
            self.emailErrorLabel.text = self.emailAvailableMessage
            self.emailErrorLabel.isHidden = false
            self.emailErrorLabel.textColor = .green
            self.validEmail = true
        }
    }
    
    func fieldCheck(validEmail: Bool, validUsername: Bool) {
        if validEmail && validUsername {
            continueButton.isEnabled = true
            continueButton.backgroundColor = buttonColor
        } else {
            continueButton.isEnabled = false
            continueButton.backgroundColor = disabledButtonColor
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send info to the next page in order to retain the field's text
        // when traversing between the registration pages
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
