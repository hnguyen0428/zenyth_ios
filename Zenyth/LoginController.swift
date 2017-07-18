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
    @IBOutlet weak var fboauthButton: UIButton!
    @IBOutlet weak var googleoauthButton: UIButton!
    
    var oauthJSON: JSON? = nil
    
    func loginButtonAction(_ sender: UIButton) {
        var key = ""
        let text = usernameField.text!
        if self.isValidEmail(email: text) {
            key = "email"
        } else if self.isValidCharactersUsername(username: text) {
            key = "username"
        }
        let parameters: Parameters = [
            key : usernameField.text!,
            "password" : passwordField.text!
        ]
        
        let request = LoginRequestor(parameters: parameters)
        
        let indicator = requestLoading(view: self.view)
        request.getJSON { data, error in
            self.requestDoneLoading(view: self.view, indicator: indicator)
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
        
        // REMOVE
        fboauthButton.addTarget(self, action: #selector(logoutFB),
                                for: .touchUpInside)
        googleoauthButton.addTarget(self, action: #selector(logoutGoogle),
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
    
    // REMOVE
    func logoutFB() {
        print("Logging out of FB")
        FBSDKLoginManager().logOut()
    }
    
    func logoutGoogle() {
        print("Logging out of Google")
        GIDSignIn.sharedInstance().signOut()
    }
    
    /* Setup images for the buttons and setups textfields
     */
    func setupViews() {
        let logoView: UIImageView = {
            // CHANGE: NO MAGIC NUMBER
            let width: CGFloat = 29.0
            let height: CGFloat = 52.0
            let frame = CGRect(x: self.view.center.x - (width/2),
                               y: self.view.center.y/3.5, width: width,
                               height: height)
            let imageView = UIImageView(frame: frame)
            imageView.image = #imageLiteral(resourceName: "Logo")
            return imageView
        }()
        scrollView.addSubview(logoView)
        
        fbButton.setImage(#imageLiteral(resourceName: "Facebook_Icon"), for: .normal)
        twitterButton.setImage(#imageLiteral(resourceName: "Twitter_Icon"), for: .normal)
        gplusButton.setImage(#imageLiteral(resourceName: "Google_Plus_Icon"), for: .normal)
        
        fbButton.imageView?.contentMode = .scaleAspectFit
        twitterButton.imageView?.contentMode = .scaleAspectFit
        gplusButton.imageView?.contentMode = .scaleAspectFit
        
        signinButton.backgroundColor = disabledBrown
        signinButton.layer.cornerRadius = 20
        signinButton.isEnabled = false
        
        fboauthButton.backgroundColor = disabledBrown
        fboauthButton.layer.cornerRadius = 20
        
        googleoauthButton.backgroundColor = disabledBrown
        googleoauthButton.layer.cornerRadius = 20
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        
        formatTextField(textField: usernameField)
        formatTextField(textField: passwordField)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func handleCustomGoogleLogin() {
    
        GIDSignIn.sharedInstance().signIn()
    
    }
    
    func handleCustomFBLogin() {
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
    
    func graphRequest() {
    
        // not firAuth anymore
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        print("Successfully logged in with facebook...")
        FBSDKGraphRequest(graphPath: "/me", parameters:
            ["fields": "last_name, first_name, email, gender, birthday"])
            .start { (connnection, result, err) in
            
            if err != nil {
                
                print("Failed to start graph request:", err ?? "")
                return
            }
            let json = JSON(result)
            print(json)
            self.oauthJSON = json
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
                self.performSegue(withIdentifier: "oauthToUsernameSegue",
                                  sender: self)
            }
            
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
                signinButton.backgroundColor = disabledBrown
                return
        }
        signinButton.isEnabled = true
        signinButton.backgroundColor = buttonColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "oauthToUsernameSegue" {
            let resultVC = segue.destination as! UsernameEmailController
            resultVC.messageFromOauth = "changeButtonTargetFB"
            resultVC.oauthJSON = self.oauthJSON
        }
    }
    
}
