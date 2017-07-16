//
//  LoginController.swift
//  Zenyth
//
//  Created by Hoang on 7/3/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import LBTAComponents
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import GoogleSignIn
//import TwitterKit


class LoginController: ModelViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var gplusButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        let parameters: Parameters = [
            "username" : usernameField.text!,
            "password" : passwordField.text!
        ]
        
        let request = LoginRequestor(parameters: parameters)
        
        request.getJSON { data, error in
            
            if (error != nil) {
                return
            }
            
            if (data?["success"].boolValue)! {
                let user = User.init(json: data!)
                print("User: \(user)")
                UserDefaults.standard.set(user.api_token, forKey: "api_token")
                UserDefaults.standard.synchronize()
            } else {
                let errors = (data?["errors"].arrayValue)!
                var errorString = ""
                for item in errors {
                    errorString.append(item.stringValue + "\n")
                }
                // strip the newline character at the end
                errorString.remove(at: errorString.index(
                    before: errorString.endIndex)
                )
                
                self.displayAlert(view: self, title: "Login Failed",
                                  message: errorString)
                
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The following is for the custom login button 
        // (may need to call set up views prior)
        fbButton.addTarget(self, action: #selector(handleCustomFBLogin),
                           for: .touchUpInside)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // custom Google+
        gplusButton.addTarget(self, action: #selector(handleCustomGoogleLogin),
                              for: .touchUpInside)
        
        setupViews()
        usernameField.addTarget(self, action: #selector(editingChanged),
                                for: .editingChanged)
        passwordField.addTarget(self, action: #selector(editingChanged),
                                for: .editingChanged)
        
    }
    
    /* Setup images for the buttons and setups textfields
     */
    func setupViews() {
        fbButton.setImage(#imageLiteral(resourceName: "Facebook_Icon"), for: .normal)
        twitterButton.setImage(#imageLiteral(resourceName: "Twitter_Icon"), for: .normal)
        gplusButton.setImage(#imageLiteral(resourceName: "Google_Plus_Icon"), for: .normal)
        
        fbButton.imageView?.contentMode = .scaleAspectFit
        twitterButton.imageView?.contentMode = .scaleAspectFit
        gplusButton.imageView?.contentMode = .scaleAspectFit
        
        signinButton.backgroundColor = disabledButtonColor
        signinButton.layer.cornerRadius = 20
        signinButton.isEnabled = false
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        
        formatTextField(textField: usernameField)
        formatTextField(textField: passwordField)
    }
    
    func handleCustomGoogleLogin() {
    
        GIDSignIn.sharedInstance().signIn()
    
    }
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email",
                                                        "public_profile"],
                                  from: self) { (result, err) in
            if err != nil {
                print ("FB login failed:", err ?? "")
                return
            }
            
            self.graphRequest()
        }
    }
    
    func graphRequest() {
    
        // not firAuth anymore
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        print("Successfully logged in with facebook...")
        FBSDKGraphRequest(graphPath: "/me", parameters:
            ["fields": "last_name, first_name, email, gender"])
            .start { (connnection, result, err) in
            
            if err != nil {
                
                print("Failed to start graph request:", err ?? "")
                return
            }
            let json = JSON(result)
            self.fbOauthHandler(json: json, accessToken: accessTokenString)
            
        }
    }
    
    func fbOauthHandler(json: JSON, accessToken: String) {
        
        // Checks if facebook email has already been used
        let request = EmailTakenRequestor.init(email: json["email"].stringValue)
        
        request.getJSON { data, error in
            
            if (error != nil) {
                return
            }
            
            if (data?["data"].boolValue)! { // email is taken
                print("Email Taken")
                self.fbOauthLogin(accessToken: accessToken)
            } else { // email is available
                print("Email Available")
                self.oauthRegister(json: json)
            }
            
        }
        
    }
    
    func oauthRegister(json: JSON) {
        let parameters: Parameters = [
            "username": "hoangFacebook",
            "email": json["email"].stringValue,
            "gender": json["gender"].stringValue,
            "first_name": json["first_name"].stringValue,
            "last_name": json["last_name"].stringValue
        ]
        let request = OauthRegisterRequestor.init(parameters: parameters)
        
        request.getJSON { data, error in
            
            if (error != nil) {
                return
            }
            
            let user = User.init(json: data!)
            print("User: \(user)")
            
        }
    }
    
    func fbOauthLogin(accessToken: String) {
        let parameters: Parameters = [
            "oauth_type": "facebook"
        ]
        let header: HTTPHeaders = [
            "Authorization": "bearer \(accessToken)"
        ]
        let request = OauthLoginRequestor.init(parameters: parameters,
                                               header: header)
        
        request.getJSON { data, error in
            
            if (error != nil) {
                return
            }
            
            if (data?["success"].boolValue)! {
                let user = User.init(json: data!)
                print("User: \(user)")
            }
            
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: animated)
        
        // Make the navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                                for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        NotificationCenter.default.removeObserver(self,
                                name: NSNotification.Name.UIKeyboardWillHide,
                                object: self.view.window)
        NotificationCenter.default.removeObserver(self,
                                name: NSNotification.Name.UIKeyboardWillShow,
                                object: self.view.window)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true,
                                                          animated: animated)
        
        NotificationCenter.default.addObserver(self,
                            selector: #selector(self.keyboardWillShow),
                            name: NSNotification.Name.UIKeyboardWillShow,
                            object: nil)
        NotificationCenter.default.addObserver(self,
                            selector: #selector(self.keyboardWillHide),
                            name: NSNotification.Name.UIKeyboardWillHide,
                            object: nil)
    }
    
    /* Overridden rules for checking the field before enabling the button
     */
    override func fieldCheck() {
        guard
            let username = usernameField.text, !username.isEmpty,
            let password = passwordField.text, !password.isEmpty
            else {
                signinButton.isEnabled = false
                signinButton.backgroundColor = disabledButtonColor
                return
        }
        signinButton.isEnabled = true
        signinButton.backgroundColor = buttonColor
    }
    
}
