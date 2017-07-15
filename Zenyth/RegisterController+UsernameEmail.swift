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
    
    var checkTimer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        usernameField.addTarget(self, action: #selector(timerBeforeCheck), for: .editingChanged)
        emailField.addTarget(self, action: #selector(timerBeforeCheck), for: .editingChanged)
        
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
        
        usernameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        
        emailActivityIndicator.hidesWhenStopped = true
        usernameActivityIndicator.hidesWhenStopped = true
        emailActivityIndicator.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        usernameActivityIndicator.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    func timerBeforeCheck(_ textField: UITextField) {
        if self.checkTimer != nil {
            self.checkTimer!.invalidate()
            self.checkTimer = nil
        }
        
        if textField == emailField {
            self.checkTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(checkValidEmail), userInfo: textField.text, repeats: false)
        }
        if textField == usernameField {
            self.checkTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(checkValidUsername), userInfo: textField.text, repeats: false)
        }
    }
    
    func checkValidUsername(_ timer: Timer) {
        let text = usernameField.text ?? ""
        
        if text != "" {
            if text.characters.count < 3 || text.characters.count > 20 {
                self.usernameErrorLabel.text = self.usernameRules
                self.usernameErrorLabel.isHidden = false
                self.usernameErrorLabel.textColor = .red
                continueButton.isEnabled = false
                continueButton.backgroundColor = disabledButtonColor
                return
            }
            let request = UsernameTakenRequestor.init(username: text)
            
            usernameActivityIndicator.startAnimating()
            usernameErrorLabel.text = activityIndicatorChecking
            usernameErrorLabel.textColor = .lightGray
            
            request.getJSON { data, error in
                if error != nil {
                    return
                }
                
                if data!["data"].boolValue { // username taken
                    self.usernameErrorLabel.text = "\(text) \(self.usernameTakenMessage)"
                    self.usernameErrorLabel.isHidden = false
                    self.usernameErrorLabel.textColor = .red
                } else { // username available
                    self.usernameErrorLabel.text = "\(text) \(self.usernameAvailableMessage)"
                    self.usernameErrorLabel.isHidden = false
                    self.usernameErrorLabel.textColor = .green
                }
                self.usernameActivityIndicator.stopAnimating()
                self.continueButton.isEnabled = true
                self.continueButton.backgroundColor = buttonColor
            }
        }
    }
    
    func checkValidEmail(_ timer: Timer) {
        let text = emailField.text ?? ""
        
        if text != "" {
            if !(isValidEmail(testStr: text)) {
                self.emailErrorLabel.text = self.invalidEmailMessage
                self.emailErrorLabel.isHidden = false
                self.emailErrorLabel.textColor = .red
                continueButton.isEnabled = false
                continueButton.backgroundColor = disabledButtonColor
                return
            }
            
            let request = EmailTakenRequestor.init(email: text)
            
            emailActivityIndicator.startAnimating()
            emailErrorLabel.text = activityIndicatorChecking
            emailErrorLabel.textColor = .lightGray
            
            request.getJSON { data, error in
                if error != nil {
                    return
                }
                
                if data!["data"].boolValue { // email taken
                    self.emailErrorLabel.text = self.emailTakenMessage
                    self.emailErrorLabel.isHidden = false
                    self.emailErrorLabel.textColor = .red
                } else { // email available
                    self.emailErrorLabel.text = self.emailAvailableMessage
                    self.emailErrorLabel.isHidden = false
                    self.emailErrorLabel.textColor = .green
                }
                self.emailActivityIndicator.stopAnimating()
                self.continueButton.isEnabled = true
                self.continueButton.backgroundColor = buttonColor
            }
        }
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
