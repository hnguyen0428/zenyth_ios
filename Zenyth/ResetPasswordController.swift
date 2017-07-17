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
    }
    
    func buttonAction(_ button: UIButton) {
        var key = ""
        if validEmail {
            key = "email"
        } else if validUsername {
            key = "username"
        }
        let parameters = [
            key : usernameEmailField.text!
        ]
        
        let request = ResetPasswordRequestor.init(parameters: parameters)
        
        let indicator = requestLoading(view: self.view)
        request.getJSON { data, error in
            self.requestDoneLoading(view: self.view, indicator: indicator)
            if (error != nil) {
                return
            }
            let email = data!["data"].stringValue
            
            self.displayAlert(view: self, title: self.requestSuccessMessage,
                              message: "\(self.checkEmailMessage)\(email)")
        }
    }
    
    func setupViews() {
        formatTextField(textField: usernameEmailField)
        errorLabel.isHidden = true
        indicator.hidesWhenStopped = true
        resetPasswordButton.backgroundColor = disabledButtonColor
        resetPasswordButton.layer.cornerRadius = 20
        resetPasswordButton.isEnabled = false
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
        
        let checkUsernameRequest = UsernameTakenRequestor.init(username: text)
        let checkEmailRequest = EmailTakenRequestor.init(email: text)
        
        // Dispatch group used to detect when all of the asynchronous requests
        // finish
        let group = DispatchGroup()
        
        group.enter()
        checkUsernameRequest.getJSON { data, error in
            group.leave()
            if error != nil {
                return
            }
            if data!["data"].boolValue {
                self.validUsername = true
                self.setButtonEnable(true)
                self.errorLabel.isHidden = true
            } else {
                self.validUsername = false
            }
        }
        group.enter()
        checkEmailRequest.getJSON { data, error in
            group.leave()
            if error != nil {
                return
            }
            if data!["data"].boolValue {
                self.validEmail = true
                self.setButtonEnable(true)
                self.errorLabel.isHidden = true
            } else {
                self.validEmail = false
            }
        }
        
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
            resetPasswordButton.backgroundColor = buttonColor
            resetPasswordButton.isEnabled = true
        } else {
            resetPasswordButton.backgroundColor = disabledButtonColor
            resetPasswordButton.isEnabled = false
        }
    }

}
