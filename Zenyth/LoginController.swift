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
import Firebase
import GoogleSignIn
//import TwitterKit


class LoginController: ModelViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    
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
            "username" : usernameField.text,
            "password" : passwordField.text
        ]
        
        let requestor = LoginRequestor(parameters: parameters)
        let request = requestor.execute()
        
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if json["success"].boolValue {
                    print("JSON: \(json)")
                    let token = json["data"]["api_token"]
                    UserDefaults.standard.set(token.stringValue, forKey: "api_token")
                    UserDefaults.standard.synchronize()
                } else {
                    let errors = json["errors"].arrayValue
                    var errorString = ""
                    for item in errors {
                        errorString.append(item.stringValue + "\n")
                    }
                    // strip the newline character at the end
                    errorString.remove(at: errorString.index(before: errorString.endIndex))
                    
                    displayAlert(view: self, title: "Login Failed", message: errorString)
                    
                }
                break
                
            case .failure(let error):
                print(error)
                debugPrint(response)
                break
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The following is for the custom login button (may need to call set up views prior
        fbButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
        // delete default facebook
        setupDefaultFBButton()
        
        // delete (default google sign in button
        setupDefaultGoogleButton()
        
        // custom Google+
        gplusButton.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        
        setupViews()
        usernameField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        for subview in view.subviews {
            if !(subview is UIScrollView) && !(subview is UIImageView) {
                print("Subview: ", subview)
                scrollView.addSubview(subview)
            }
        }
        
    }
    
    func handleCustomGoogleLogin() {
    
        GIDSignIn.sharedInstance().signIn()
    
    }
    
    // delete this one -- testing purposes to log out 
    func setupDefaultFBButton() {
    
        // the following is for the generic default login button
        /////////////////////////
    
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        //frame's are obselete, only use constraints
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
    
        loginButton.delegate = self
    
        // needed this
        loginButton.readPermissions = ["email", "public_profile"]
    
    }
    
    
    // delete this one tho
    func setupDefaultGoogleButton() {
        
        //add google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }

    func handleCustomFBLogin() {

        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            
            if err != nil {
                
                print ("FB login failed:", err ?? "")
                return
            }
            
            self.showFBEmailAddress()
        }

        
    }
    
    
    ///////////////////////////
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        showFBEmailAddress()
        
    }
    
    func showFBEmailAddress() {
    
        // not firAuth anymore
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
        })
        
        print ("*************** CHECK ME OUT, FACEBOOK", accessTokenString)
        let FBTokenStringCount = accessTokenString.characters.count
        print (FBTokenStringCount)
        
        print("Successfully logged in with facebook...")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connnection, result, err) in
            
            if err != nil {
                
                print("Failed to start graph request:", err ?? "")
                return
            }
            print (result ?? "")
            
        }
    }
    
    ////////////////////////
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Make the navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /* Overridden rules for checking the field before enabling the button
     */
    override func fieldCheck() {
        guard
            let username = usernameField.text, !username.isEmpty,
            let password = passwordField.text, !password.isEmpty &&
                (passwordField.text?.characters.count)! >= minimumPasswordLength
            else {
                signinButton.isEnabled = false
                signinButton.backgroundColor = disabledButtonColor
                return
        }
        signinButton.isEnabled = true
        signinButton.backgroundColor = buttonColor
    }
    
}
