//
//  ResetPasswordController.swift
//  Zenyth
//
//  Created by Emily Heejung Son on 7/16/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class ResetPasswordController: ModelViewController {

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
    
    var checkTimer: Timer? = nil
    var validEmail = false
    var validUsername = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        resetPasswordButton.addTarget(self, action: #selector(buttonAction),
                                      for: .touchUpInside)
        usernameEmailField.addTarget(self, action: #selector(timeBeforeCheck),
                             for: .editingChanged)
        usernameEmailField.becomeFirstResponder()
    }
    
    func buttonAction(_ button: UIButton) {
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
    
    func setupViews() {
        backgroundView.isHidden = true
        usernameEmailField.autocorrectionType = UITextAutocorrectionType.no
        formatTextField(textField: usernameEmailField)
        errorLabel.isHidden = true
        indicator.hidesWhenStopped = true
        resetPasswordButton.backgroundColor = disabledButtonColor
        resetPasswordButton.layer.cornerRadius = 25
        resetPasswordButton.isEnabled = false
        
        userIcon.image = #imageLiteral(resourceName: "user")
        formatImageView(imageView: userIconBorder,
                        color: disabledButtonColor.cgColor)
        
        topLabel.textColor = disabledButtonColor
    }
    
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
    
    func checkUser(_ timer: Timer) {
        let text = usernameEmailField.text ?? ""
        if text == "" {
            return
        }
        
        // Dispatch group used to detect when all of the asynchronous requests
        // finish
        let group = DispatchGroup()
        
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
        
        group.notify(queue: .main) {
            if !self.validUsername && !self.validEmail {
                self.errorLabel.text = self.notValidUserMessage
                self.errorLabel.textColor = .red
                self.errorLabel.isHidden = false
            }
        }
    }
    
    
    func setButtonEnable(_ toggle: Bool) {
        if toggle {
            resetPasswordButton.backgroundColor = blueButtonColor
            resetPasswordButton.isEnabled = true
        } else {
            resetPasswordButton.backgroundColor = disabledButtonColor
            resetPasswordButton.isEnabled = false
        }
    }
    
    override func onPressingBack() {
        self.navigationController?.popViewController(animated: true)
    }

}
