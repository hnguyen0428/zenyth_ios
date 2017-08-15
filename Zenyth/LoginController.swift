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

/// LoginController handling the Login process
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
    
    /// JSON containing information from OAuth account
    var oauthJSON: JSON? = nil
    
    /// Facebook access token
    var fbToken: String? = nil
    
    /**
     Set up button actions and the views, called when the view has been loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    /** 
     Setup all the text fields and button images
     */
    func setupViews() {
        // Setup signin button
        signinButton.backgroundColor = disabledButtonColor
        signinButton.layer.cornerRadius = 20
        signinButton.isEnabled = false
        signinButton.setTitleColor(UIColor.white, for: .normal)
        
        // Setup facebook button
        fbButton.backgroundColor = blueButtonColor
        fbButton.layer.cornerRadius = 5
        fbButton.setTitleColor(UIColor.white, for: .normal)
        
        // Setup google button
        googleButton.backgroundColor = googleButtonColor
        googleButton.layer.cornerRadius = 5
        googleButton.setTitleColor(UIColor.white, for: .normal)
        
        // Change color of the bar between the forgot password text and signup text
        separator.textColor = UIColor.white
        
        // Set color of text of button
        signupButton.setTitleColor(UIColor.white, for: .normal)
        forgotPasswordButton.setTitleColor(UIColor.white, for: .normal)
        
        // Format the text fields
        usernameField.backgroundColor = textfieldColor
        usernameField.alpha = 0.7
        usernameField.rightRoundedField()
        passwordField.backgroundColor = textfieldColor
        passwordField.alpha = 0.7
        passwordField.rightRoundedField()
        
        // Format the icons next to text fields
        userIconBorder.backgroundColor = textfieldColor
        userIconBorder.alpha = 0.7
        userIconBorder.leftRoundedImageView()
        passwordIconBorder.backgroundColor = textfieldColor
        passwordIconBorder.alpha = 0.7
        passwordIconBorder.leftRoundedImageView()
        
        // Set orange color of the background
        let height = signinButton.center.y
        let frame = CGRect(x: backgroundView.frame.origin.x,
                           y: backgroundView.frame.origin.y,
                           width: backgroundView.frame.width, height: height)
        let topOrange = UIImageView(frame: frame)
        topOrange.backgroundColor = backgroundOrange
        backgroundView.insertSubview(topOrange, at: 0)
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        
        self.hideKeyboardWhenTappedAround()
    }
    
    /**
     Handle Google OAuth signin
     */
    func handleCustomGoogleLogin() {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    
    }
    
    /**
     Handle Facebook OAuth signin
     */
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
    
    /**
     Login button action
     
     - Parameter sender: The login button
     */
    func loginButtonAction(_ sender: UIButton) {
        let text = usernameField.text!
        
        // Create activity indicator to indicate the request is being loaded
        let indicator = requestLoading(view: self.view)
        if isValidEmail(email: text) {
            LoginManager().login(withEmail: text,
                                 password: passwordField.text!,
                                 onSuccess:
                { user, apiToken in
                    self.requestDoneLoading(view: self.view, indicator: indicator)
                    
                    // Save the api token to UserDefaults for later usage
                    UserDefaults.standard.set(apiToken, forKey: "api_token")
                    UserDefaults.standard.synchronize()
                    self.transitionToHome()
            }, onFailure: { json in
                self.requestDoneLoading(view: self.view, indicator: indicator)
                let error = json["error"]["message"].stringValue
                self.displayAlert(view: self, title: "Login Failed",
                                  message: error)
            })
        } else if isValidCharactersUsername(username: text) {
            LoginManager().login(withUsername: text,
                                 password: passwordField.text!,
                                 onSuccess:
                { user, apiToken in
                    self.requestDoneLoading(view: self.view, indicator: indicator)
                    
                    // Save the api token to UserDefaults for later usage
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
    
    /**
     Make a facebook graph request to retrieve information
     */
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
    
    /**
     Handle Facebook OAuth. First check if the email has been taken. If yes then
     it will try to log the user in. If not then it will switch to UsernameController
     in order to prompt user to enter a username for the new account
     
     - Parameter json: JSON object retrieved from Facebook containing user data
     - Parameter accessToken: Facebook access token
     */
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
    
    /**
     Called when email has been taken. Attempt to log the user in with their
     Facebook
     
     - Parameter accessToken: Facebook access token
     - Parameter json: JSON object retrieved from facebook containing user data
     */
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
                
                // Save the api token to UserDefaults for later usage
                UserDefaults.standard.set(apiToken, forKey: "api_token")
                UserDefaults.standard.synchronize()
                self.transitionToHome()
        }, onFailure: { json in
            self.requestDoneLoading(view: self.view, indicator: indicator)
            // Login failed because an account has been created before with the
            // same email. Prompt user to merge account
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
    
    /**
     Called when user agrees to merge account. This will merge the new oauth
     account to the preexisted account
     
     - Parameter accessToken: Facebook access token
     - Parameter email: Facebook email
     */
    func mergeAccount(accessToken: String, email: String) {
        let indicator = self.requestLoading(view: self.view)
        let oauthType = "facebook"
        
        RegistrationManager().oauthMergeAccount(withEmail: email,
                                                oauthType: oauthType,
                                                accessToken: accessToken,
                                                onSuccess:
            { user, apiToken in
                self.requestDoneLoading(view: self.view, indicator: indicator)
                
                // Save the api token to UserDefaults for later usage
                UserDefaults.standard.set(apiToken, forKey: "api_token")
                UserDefaults.standard.synchronize()
                self.transitionToHome()
        })
    }
    
    /**
     Called when this view is about to be switched
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: animated)
        
        self.navigationController?.view.backgroundColor = navigationBarColor
    }
    
    /**
     Called when this view is about to appear
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true,
                                                          animated: animated)
    }
    
    /**
     Overridden rules for checking the field before enabling the button.
     Check if username field and password field are filled and if they fulfil
     the requirement.
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
    
    /**
     Prepare for the switch to the OAuth registration page by sending the
     JSON and Facebook token over so that the registration page can call
     the OAuth register network request with these info
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "oauthToUsernameController" {
            let resultVC = segue.destination as! UsernameController
            resultVC.messageFromOauth = "changeButtonTargetFB"
            resultVC.oauthJSON = self.oauthJSON
            resultVC.fbToken = self.fbToken
        }
    }
}
