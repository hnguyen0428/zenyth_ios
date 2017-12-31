//
//  ResetPasswordController.swift
//  Zenyth
//
//  Created by Emily Heejung Son on 7/16/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

/// ResetPasswordController handling the reset password page
class ResetPasswordController: ModelViewController {

    /// Error messages
    let notValidUserMessage = "Username or Email cannot be found"
    let requestSuccessMessage = "Request Successful"
    let checkEmailMessage = "A reset password request has been sent to "
    
    @IBOutlet weak var usernameEmailField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userIconBorder: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    
    /// Timer for real time check
    var checkTimer: Timer? = nil
    
    /// Boolean checking for email and username validity
    var validEmail = false
    var validUsername = false
    
    /**
     Setup the view and targets for buttons
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        resetPasswordButton.addTarget(self, action: #selector(buttonAction),
                                      for: .touchUpInside)
        usernameEmailField.addTarget(self, action: #selector(timeBeforeCheck),
                             for: .editingChanged)
        
        // Allow user to edit the username field as soon as they get to the page
        usernameEmailField.becomeFirstResponder()
    }
    
    /**
     Reset password button action
     
     - Parameter button: resetPasswordButton
     */
    func buttonAction(_ button: UIButton) {
        
        // If the field contains a valid email, call the network request sending
        // reset password email to email else call the network request sending
        // reset password email to account with the associated username
        if validEmail {
            let indicator = requestLoading(view: self.view)
            CredentialManager().sendResetPassword(toEmail: usernameEmailField.text!,
                                                  onSuccess:
                { data in
                    self.requestDoneLoading(view: self.view, indicator: indicator)
                    let email = data["email"].stringValue
                    self.displayAlert(view: self, title: self.requestSuccessMessage,
                                      message: "\(self.checkEmailMessage)\(email)")
            })
        } else if validUsername {
            let indicator = requestLoading(view: self.view)
            CredentialManager().sendResetPassword(toUsername: usernameEmailField.text!,
                                                  onSuccess:
                { data in
                    self.requestDoneLoading(view: self.view, indicator: indicator)
                    let email = data["email"].stringValue
                    self.displayAlert(view: self, title: self.requestSuccessMessage,
                                      message: "\(self.checkEmailMessage)\(email)")
            })
        }
        
    }
    
    /**
     Setup views
     */
    func setupViews() {
        backgroundView.isHidden = true
        
        // Remove autocorrection from the textfield
        usernameEmailField.autocorrectionType = UITextAutocorrectionType.no
        
        // Format text field
        formatTextField(textField: usernameEmailField)
        
        // Hide error label and activity indicator
        errorLabel.isHidden = true
        indicator.hidesWhenStopped = true
        
        // Format reset password button
        resetPasswordButton.backgroundColor = disabledButtonColor
        resetPasswordButton.layer.cornerRadius = 25
        resetPasswordButton.isEnabled = false
        
        // Configure the user icon next to the textfield
        userIcon.image = #imageLiteral(resourceName: "user")
        
        // Format the image view
        formatImageView(imageView: userIconBorder,
                        color: disabledButtonColor.cgColor)
        
        topLabel.textColor = disabledButtonColor
    }
    
    /**
     Trigger timer to check for validity of the username or email entered.
     
     - Parameter textField: textfield being edited
     */
    func timeBeforeCheck(_ textField: UITextField) {
        // Reset the timer if it has been started
        if self.checkTimer != nil {
            self.checkTimer!.invalidate()
            self.checkTimer = nil
        }
        self.setButtonEnable(false)
        self.checkTimer = Timer.scheduledTimer(timeInterval: timeBetweenCheck,
                                               target: self,
                                               selector: #selector(checkUser),
                                               userInfo: textField.text,
                                               repeats: false)
        
    }
    
    /**
     Check if the username or email entered refers to a valid user
     
     - Parameter timer: timer that triggers this function
     */
    func checkUser(_ timer: Timer) {
        let text = usernameEmailField.text ?? ""
        if text == "" {
            return
        }
        
        // Dispatch group used to detect when all of the asynchronous requests
        // finish
        let group = DispatchGroup()
        
        // Enter the username async check
        group.enter()
        CredentialManager().validateUsername(username: text,
                                             onSuccess:
            { data in
                group.leave()
                if data["taken"].boolValue {
                    self.validUsername = true
                    self.setButtonEnable(true)
                    self.errorLabel.isHidden = true
                }
                else {
                    self.validUsername = false
                }
        })
        // Enter the email async check
        group.enter()
        CredentialManager().validateEmail(email: text,
                                          onSuccess:
            { data in
                group.leave()
                if data["taken"].boolValue {
                    self.validEmail = true
                    self.setButtonEnable(true)
                    self.errorLabel.isHidden = true
                } else {
                    self.validEmail = false
                }
        })
        
        // Action handler when both checks have finished
        group.notify(queue: .main) {
            // If any of the check doesn't pass, set the error label
            if !self.validUsername && !self.validEmail {
                self.errorLabel.text = self.notValidUserMessage
                self.errorLabel.textColor = .red
                self.errorLabel.isHidden = false
            }
        }
    }
    
    /**
     Enable of disable the button
     
     - Parameter toggle: if true, enable the button, if false, disable the button
     */
    func setButtonEnable(_ toggle: Bool) {
        if toggle {
            resetPasswordButton.backgroundColor = blueButtonColor
            resetPasswordButton.isEnabled = true
        } else {
            resetPasswordButton.backgroundColor = disabledButtonColor
            resetPasswordButton.isEnabled = false
        }
    }
    
    /**
     Add animation to the back button when backing out to the login page since
     the default back action is not animated
     */
    override func onPressingBack() {
        self.navigationController?.popViewController(animated: true)
    }

}
