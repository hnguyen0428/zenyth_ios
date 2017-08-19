//
//  RegisterController.swift
//  Zenyth
//
//  Created by Hoang on 7/3/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// UsernameController handling the username and email registration page
class UsernameController: ModelViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var usernameActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var userIconBorder: UIImageView!
    @IBOutlet weak var mailIconBorder: UIImageView!
    
    /// Indicate validity of email
    var validEmail: Bool = false
    
    /// Indicate validity of username
    var validUsername: Bool = false
    
    /// Timer used to do real time checking
    var checkTimer: Timer? = nil
    
    /// OAuth JSON containing information from OAuth account
    var oauthJSON: JSON? = nil
    
    /// Message passed in from LoginController in order to inform if the
    /// current OAuth process if google or facebook
    var messageFromOauth: String? = nil
    
    let signupTitle = "Sign Up"
    
    /// OAuth access tokens
    var fbToken: String? = nil
    var googleToken: String? = nil
    
    /**
     Setup button targets and subviews when the main view has been loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.isHidden = true
        
        // Run a timer when user starts editing, once the timer ends, it will
        // trigger a method to check if username or email is valid
        usernameField.addTarget(self, action: #selector(timeBeforeCheck),
                                for: .editingChanged)
        emailField.addTarget(self, action: #selector(timeBeforeCheck),
                             for: .editingChanged)
        
        setupViews()
        
        // Allow user to edit the username field as soon as the page is loaded
        usernameField.becomeFirstResponder()
        
        // Add navigation controller delegate in order to add a listener to
        // the back button of the navigation bar
        self.navigationController?.delegate = self
    }
    
    /**
     Listener on the navigation bar's back button. If user backs out to the
     login page, clear registration module's information
     */
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if viewController is LoginController {
            RegistrationModule.sharedInstance.clearInfo()
        }
    }
    
    /**
     Add animation to the back button when backing out to the login page since
     the default back action is not animated
     */
    override func onPressingBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     Setup the view
     */
    func setupViews() {
        // Set up continue button
        continueButton.backgroundColor = disabledButtonColor
        continueButton.layer.cornerRadius = 25
        continueButton.isEnabled = false
        
        // Remove auto correction
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        emailField.autocorrectionType = UITextAutocorrectionType.no
        
        // Format text field and image view
        formatTextField(textField: usernameField)
        formatTextField(textField: emailField)
        formatImageView(imageView: userIconBorder, color: disabledButtonColor.cgColor)
        formatImageView(imageView: mailIconBorder, color: disabledButtonColor.cgColor)
        
        usernameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        
        emailActivityIndicator.hidesWhenStopped = true
        usernameActivityIndicator.hidesWhenStopped = true
        
        // Make the activity indicator smaller
        emailActivityIndicator.transform = CGAffineTransform(
            scaleX: 0.75, y: 0.75
        )
        usernameActivityIndicator.transform = CGAffineTransform(
            scaleX: 0.75, y: 0.75
        )
        
        // Prefill the email textfield with the email retrieved from OAuth
        if let email = oauthJSON?["email"].string {
            emailField.text = email
            emailField.textColor = .lightGray
            emailField.isUserInteractionEnabled = false
            validEmail = true
        }
        
        // Changing the continue button targets based on the OAuth type
        // If the message is nil then the user is in the normal registration
        // process. If the message has a value then the user is in the OAuth
        // registration process
        if messageFromOauth == "changeButtonTargetFB" {
            continueButton.removeTarget(nil, action: nil,
                                        for: .allEvents)
            continueButton.addTarget(self,
                                     action: #selector(oauthFBRegister),
                                     for: .touchUpInside)
            continueButton.setTitle(signupTitle, for: .normal)
        } else if messageFromOauth == "changeButtonTargetGoogle" {
            continueButton.removeTarget(nil, action: nil,
                                        for: .allEvents)
            continueButton.addTarget(self,
                                     action: #selector(oauthGoogleRegister),
                                     for: .touchUpInside)
            continueButton.setTitle(signupTitle, for: .normal)
        }
    }
    
    /**
     Run the timer to check for validity of email and username. After 0.6
     seconds, if the user has not made any further change, the timer will trigger
     the method checkValidEmail() or checkValidUsername() depending on what field
     is being edited.
     
     - Parameter textField: textfield being edited
     */
    func timeBeforeCheck(_ textField: UITextField) {
        // Reset the timer if it has been started
        if self.checkTimer != nil {
            self.checkTimer!.invalidate()
            self.checkTimer = nil
        }
        
        // Disable button as soon as user starts editing
        fieldCheck(validEmail: false, validUsername: false)
        
        // Save information to registration module
        let module = RegistrationModule.sharedInstance
        module.setUsername(username: usernameField.text!)
        module.setEmail(email: emailField.text!)
        
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
    
    /**
     Check validity of username.
     
     - Parameter timer: Timer being run
     */
    func checkValidUsername(_ timer: Timer) {
        let text = usernameField.text ?? ""
        
        if text != "" {
            if !(isValidLengthUsername(username: text)) {
                self.setUsernameError("usernameLengthError")
                return
            } else if !(isValidCharactersUsername(username: text)) {
                self.setUsernameError("notAlphaNumericError")
                return
            }
            
            // Start the activity indicator to indicate that request is loading
            usernameActivityIndicator.startAnimating()
            usernameErrorLabel.text = RegistrationModule.activityIndicatorChecking
            usernameErrorLabel.textColor = .lightGray
            
            CredentialManager().validateUsername(username: text,
                                                 onSuccess:
                { data in
                    if data["taken"].boolValue { // username taken
                        self.setUsernameError("usernameTaken")
                    } else { // username available
                        self.setUsernameError("usernameAvailable")
                    }
                    self.usernameActivityIndicator.stopAnimating()
                    self.fieldCheck(validEmail: self.validEmail,
                                    validUsername: self.validUsername)
            })
        }
    }
    
    /**
     Check validity of email.
     
     - Parameter timer: Timer being run
     */
    func checkValidEmail(_ timer: Timer) {
        let text = emailField.text ?? ""
        
        if text != "" {
            if !(isValidEmail(email: text)) {
                self.setEmailError("notEmailError")
                return
            }
            
            // Start the activity indicator to indicate that request is loading
            emailActivityIndicator.startAnimating()
            emailErrorLabel.text = RegistrationModule.activityIndicatorChecking
            emailErrorLabel.textColor = .lightGray
            
            CredentialManager().validateEmail(email: text,
                                              onSuccess:
                { data in
                    if data["taken"].boolValue { // email taken
                        self.setEmailError("emailTaken")
                    } else { // email available
                        self.setEmailError("emailAvailable")
                    }
                    self.emailActivityIndicator.stopAnimating()
                    self.fieldCheck(validEmail: self.validEmail,
                                    validUsername: self.validUsername)
            })
        }
    }
    
    /**
     Set the username error label based on the type of error.
     This function is called by checkValidUsername method.
     
     - Parameter type: the type of error
     */
    func setUsernameError(_ type: String) {
        if type == "usernameLengthError" {
            self.usernameErrorLabel.text = RegistrationModule.usernameRules
            self.usernameErrorLabel.isHidden = false
            self.usernameErrorLabel.textColor = .red
            self.validUsername = false
            self.fieldCheck(validEmail: validEmail,
                            validUsername: validUsername)
        }
        else if type == "notAlphaNumericError" {
            self.usernameErrorLabel.text = RegistrationModule.usernameInvalidCharacters
            self.usernameErrorLabel.isHidden = false
            self.usernameErrorLabel.textColor = .red
            self.validUsername = false
            self.fieldCheck(validEmail: validEmail,
                            validUsername: validUsername)
        }
        else if type == "usernameTaken" {
            self.usernameErrorLabel.text = "\(usernameField.text!) " +
            "\(RegistrationModule.usernameTakenMessage)"
            self.usernameErrorLabel.isHidden = false
            self.usernameErrorLabel.textColor = .red
            self.validUsername = false
        }
        else if type == "usernameAvailable" {
            self.usernameErrorLabel.text = "\(usernameField.text!) " +
            "\(RegistrationModule.usernameAvailableMessage)"
            self.usernameErrorLabel.isHidden = false
            self.usernameErrorLabel.textColor = .green
            self.validUsername = true
        }
    }
    
    /**
     Set the email error label based on the type of error.
     This function is called by checkValidEmail method.
     
     - Parameter type: the type of error
     */
    func setEmailError(_ type: String) {
        if type == "notEmailError" {
            self.emailErrorLabel.text = RegistrationModule.invalidEmailMessage
            self.emailErrorLabel.isHidden = false
            self.emailErrorLabel.textColor = .red
            self.validEmail = false
            self.fieldCheck(validEmail: validEmail,
                            validUsername: validUsername)
        }
        else if type == "emailTaken" {
            self.emailErrorLabel.text = RegistrationModule.emailTakenMessage
            self.emailErrorLabel.isHidden = false
            self.emailErrorLabel.textColor = .red
            self.validEmail = false
        }
        else if type == "emailAvailable" {
            self.emailErrorLabel.text = RegistrationModule.emailAvailableMessage
            self.emailErrorLabel.isHidden = false
            self.emailErrorLabel.textColor = .green
            self.validEmail = true
        }
    }
    
    /**
     Method checking for email validity and username validity and enable the
     continue button if both are valid
     
     - Parameter validEmail: validity of email
     - Parameter validUsername: validity of username
     */
    func fieldCheck(validEmail: Bool, validUsername: Bool) {
        if validEmail && validUsername {
            continueButton.isEnabled = true
            continueButton.backgroundColor = blueButtonColor
        } else {
            continueButton.isEnabled = false
            continueButton.backgroundColor = disabledButtonColor
        }
    }
    
    /**
     Register for an account using Facebook OAuth
     
     - Parameter button: the continue button triggering this process
     */
    func oauthFBRegister(_ button: UIButton) {
        let oauthType = "facebook"
        let username = usernameField.text!
        
        // Retrieving information from the JSON object passed in from
        // LoginController
        let email = oauthJSON!["email"].stringValue
        let gender = oauthJSON!["gender"].string ?? ""
        let firstName = oauthJSON!["first_name"].string ?? ""
        let lastName = oauthJSON!["last_name"].string ?? ""
        
        let indicator = requestLoading(view: self.view)
        
        RegistrationManager().oauthRegister(
            withUsername: username, email: email,
            firstName: firstName, lastName: lastName, gender: gender,
            oauthType: oauthType, accessToken: fbToken!,
            onSuccess: { user, apiToken in
                self.requestDoneLoading(view: self.view, indicator: indicator)
                LoginController.saveLoggedInUserInfo(user: user, apiToken: apiToken)
                let alert = UIAlertController(
                    title: RegistrationModule.signupSuccessfulMessage,
                    message: nil,
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(title: "OK",
                                              style: UIAlertActionStyle.default,
                                              handler:
                    { action in
                        self.transitionToHome()
                }))
                self.present(alert, animated: true, completion: nil)
        })
    }
    
    /**
     Register for an account using Google OAuth
     
     - Parameter button: the continue button triggering this process
     */
    func oauthGoogleRegister(_ button: UIButton) {
        let oauthType = "google"
        let username = usernameField.text!
        
        // Retrieving information from the JSON object passed in from
        // LoginController
        let email = oauthJSON!["email"].stringValue
        let gender = oauthJSON!["gender"].string ?? ""
        let firstName = oauthJSON!["given_name"].string ?? ""
        let lastName = oauthJSON!["family_name"].string ?? ""

        let indicator = requestLoading(view: self.view)
        
        RegistrationManager().oauthRegister(
            withUsername: username, email: email,
            firstName: firstName, lastName: lastName, gender: gender,
            oauthType: oauthType, accessToken: googleToken!,
            onSuccess: { user, apiToken in
                self.requestDoneLoading(view: self.view, indicator: indicator)
                LoginController.saveLoggedInUserInfo(user: user, apiToken: apiToken)
                let alert = UIAlertController(
                    title: RegistrationModule.signupSuccessfulMessage,
                    message: nil,
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(title: "OK",
                                              style: UIAlertActionStyle.default,
                                              handler:
                    { action in
                        self.transitionToHome()
                }))
                self.present(alert, animated: true, completion: nil)
        })
    }
    
}
