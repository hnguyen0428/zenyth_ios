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

class LoginController: ModelViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var userIconBorder: UIImageView!
    @IBOutlet weak var passwordIconBorder: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var separator: UILabel!
    
    let facebookNoEmailMessage = "Your facebook account does not contain an " +
                        "email. Please make an account through our signup page"
    var oauthJSON: JSON? = nil
    var fbToken: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer that allows for scrolling once you enter keyboard mode
        NotificationCenter.default.addObserver(self,
                                    selector:#selector(self.keyboardWillShow),
                                    name: NSNotification.Name.UIKeyboardWillShow,
                                    object: nil)
        NotificationCenter.default.addObserver(self,
                                    selector: #selector(self.keyboardWillHide),
                                    name: NSNotification.Name.UIKeyboardWillHide,
                                    object: nil)
        
        signinButton.addTarget(self, action: #selector(loginButtonAction),
                               for: .touchUpInside)
        
        // The following is for the custom login button 
        // (may need to call set up views prior)
        fbButton.addTarget(self, action: #selector(handleCustomFBLogin),
                           for: .touchUpInside)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // custom Google+
        googleButton.addTarget(self, action: #selector(handleCustomGoogleLogin),
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
        fbButton.imageView?.contentMode = .scaleAspectFill
        googleButton.imageView?.contentMode = .scaleAspectFill
        
        signinButton.backgroundColor = disabledButtonColor
        signinButton.layer.cornerRadius = 20
        signinButton.isEnabled = false
        signinButton.setTitleColor(UIColor.white, for: .normal)
        
        fbButton.backgroundColor = blueButtonColor
        fbButton.layer.cornerRadius = 5
        fbButton.setTitleColor(UIColor.white, for: .normal)
        googleButton.backgroundColor = googleButtonColor
        googleButton.layer.cornerRadius = 5
        googleButton.setTitleColor(UIColor.white, for: .normal)
        
        separator.textColor = UIColor.white
        
        signupButton.setTitleColor(UIColor.white, for: .normal)
        forgotPasswordButton.setTitleColor(UIColor.white, for: .normal)
        
        usernameField.backgroundColor = textfieldColor
        usernameField.alpha = 0.7
        usernameField.layer.cornerRadius = 5
        passwordField.backgroundColor = textfieldColor
        passwordField.alpha = 0.7
        passwordField.layer.cornerRadius = 5
        
        userIconBorder.backgroundColor = textfieldColor
        userIconBorder.alpha = 0.7
        userIconBorder.layer.cornerRadius = 5
        passwordIconBorder.backgroundColor = textfieldColor
        passwordIconBorder.alpha = 0.7
        passwordIconBorder.layer.cornerRadius = 5
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func handleCustomGoogleLogin() {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    
    }
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logOut()
        FBSDKLoginManager().logIn(withReadPermissions: ["email",
                                                        "public_profile",
                                                        "user_birthday",
                                                        "user_friends"],
                                  from: self) { (result, err) in
            if err != nil {
                print ("FB login failed:", err ?? "")
                return
            }
            
            self.graphRequest()
        }
    }
    
    func loginButtonAction(_ sender: UIButton) {
        let text = usernameField.text!
        
        let indicator = requestLoading(view: self.view)
        if self.isValidEmail(email: text) {
            LoginManager().login(withEmail: text,
                                 password: passwordField.text!,
                                 onSuccess:
                { user, apiToken in
                    self.requestDoneLoading(view: self.view, indicator: indicator)
                    UserDefaults.standard.set(apiToken, forKey: "api_token")
                    UserDefaults.standard.synchronize()
                    self.transitionToHome()
            }, onFailure: { json in
                self.requestDoneLoading(view: self.view, indicator: indicator)
                let error = json["error"]["message"].stringValue
                self.displayAlert(view: self, title: "Login Failed",
                                  message: error)
            })
        } else if self.isValidCharactersUsername(username: text) {
            LoginManager().login(withUsername: text,
                                 password: passwordField.text!,
                                 onSuccess:
                { user, apiToken in
                    self.requestDoneLoading(view: self.view, indicator: indicator)
                    UserDefaults.standard.set(apiToken, forKey: "api_token")
                    UserDefaults.standard.synchronize()
                    print(user)
                    self.transitionToHome()
            }, onFailure: { json in
                self.requestDoneLoading(view: self.view, indicator: indicator)
                let error = json["error"]["message"].stringValue
                self.displayAlert(view: self, title: "Login Failed",
                                  message: error)
            })
        }
    }
    
    func graphRequest() {
    
        // not firAuth anymore
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        self.fbToken = accessTokenString
        
        print("Successfully logged in with facebook...")
        FBSDKGraphRequest(graphPath: "/me", parameters:
            ["fields": "last_name, first_name, email, gender, birthday"])
            .start { (connnection, result, err) in
            
            if err != nil {
                
                print("Failed to start graph request:", err ?? "")
                return
            }
            let json = JSON(result)
            if json["email"].string == nil {
                self.displayAlert(view: self, title: "No Email",
                                  message: self.facebookNoEmailMessage)
            }
            
            self.oauthJSON = json
            self.fbOauthHandle(json: json, accessToken: accessTokenString)
            
        }
    }
    
    func fbOauthHandle(json: JSON, accessToken: String) {
        
        // Checks if facebook email has already been used
        let email = json["email"].stringValue
        CredentialManager().validateEmail(email: email,
                                          onSuccess:
            { data in
                if data["taken"].boolValue {
                    print("Email Taken")
                    self.fbOauthLogin(accessToken: accessToken, json: json)
                } else { // email is available
                    print("Email Available")
                    self.performSegue(withIdentifier: "oauthToUsernameSegue",
                                      sender: self)
                }
        })
        
    }
    
    func fbOauthLogin(accessToken: String, json: JSON) {
        let email = json["email"].stringValue
        let oauthType = "facebook"

        let indicator = requestLoading(view: self.view)
        
        LoginManager().oauthLogin(withEmail: email,
                                  oauthType: oauthType,
                                  accessToken: accessToken,
                                  onSuccess:
            { user, apiToken in
                self.requestDoneLoading(view: self.view, indicator: indicator)
                UserDefaults.standard.set(apiToken, forKey: "api_token")
                UserDefaults.standard.synchronize()
                self.transitionToHome()
        }, onFailure: { json in
            self.requestDoneLoading(view: self.view, indicator: indicator)
            if json["data"]["mergeable"].boolValue {
                let message = json["message"].stringValue
                let alert = UIAlertController(title: nil,
                                              message: message,
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
                    action in
                    self.mergeAccount(accessToken: accessToken, email: email)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func mergeAccount(accessToken: String, email: String) {
        let indicator = self.requestLoading(view: self.view)
        let oauthType = "facebook"
        
        RegistrationManager().oauthMergeAccount(withEmail: email,
                                                oauthType: oauthType,
                                                accessToken: accessToken,
                                                onSuccess:
            { user, apiToken in
                self.requestDoneLoading(view: self.view, indicator: indicator)
                UserDefaults.standard.set(apiToken, forKey: "api_token")
                UserDefaults.standard.synchronize()
                self.transitionToHome()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: animated)
        
        self.navigationController?.view.backgroundColor = navigationBarColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true,
                                                          animated: animated)
    }
    
    /* Overridden rules for checking the field before enabling the button
     */
    override func fieldCheck() {
        guard
            let usernameEmail = usernameField.text, !usernameEmail.isEmpty &&
                                (isValidUsername(username: usernameEmail) ||
                                    isValidEmail(email: usernameEmail)),
            let password = passwordField.text, !password.isEmpty &&
                            isValidPassword(password: password)
            else {
                signinButton.isEnabled = false
                signinButton.backgroundColor = disabledButtonColor
                return
        }
        signinButton.isEnabled = true
        signinButton.backgroundColor = blueButtonColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "oauthToUsernameController" {
            let resultVC = segue.destination as! UsernameController
            resultVC.messageFromOauth = "changeButtonTargetFB"
            resultVC.oauthJSON = self.oauthJSON
            resultVC.fbToken = self.fbToken
        }
    }
}
