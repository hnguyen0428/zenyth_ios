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


class LoginController: RegisterController, GIDSignInUIDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var gplusButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var userIconBorder: UIImageView!
    @IBOutlet weak var passwordIconBorder: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var bars: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    
    /* Signup View */
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var errorLabelOne: UILabel!
    @IBOutlet weak var errorLabelTwo: UILabel!
    @IBOutlet weak var indicatorOne: UIActivityIndicatorView!
    @IBOutlet weak var indicatorTwo: UIActivityIndicatorView!
    @IBOutlet weak var tabOne: UIButton!
    @IBOutlet weak var tabTwo: UIButton!
    @IBOutlet weak var tabThree: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var textLabelOne: UILabel!
    @IBOutlet weak var textLabelTwo: UILabel!
    @IBOutlet weak var iconOne: UIImageView!
    @IBOutlet weak var iconTwo: UIImageView!
    @IBOutlet weak var iconOneBorder: UIImageView!
    @IBOutlet weak var iconTwoBorder: UIImageView!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    var currentTab: Int = 1
    var mask: UIView?
    var grabbed: Bool = false
    let genderData = ["", "Male", "Female", "Non-binary"]
    var validUsername: Bool = false
    var validEmail: Bool = false
    var validPw: Bool = false
    var checkTimer: Timer? = nil
    
    /* End Signup View */
    
    let facebookNoEmailMessage = "Your facebook account does not contain an " +
                        "email. Please make an account through our signup page"
    var oauthJSON: JSON? = nil
    var fbToken: String? = nil
    
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
                    print(user.toJSON())
                    self.transitionToHome()
            }, onFailure: { json in
                self.requestDoneLoading(view: self.view, indicator: indicator)
                let error = json["error"]["message"].stringValue
                self.displayAlert(view: self, title: "Login Failed",
                                  message: error)
            })
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
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // custom Google+
        gplusButton.addTarget(self, action: #selector(handleCustomGoogleLogin),
                              for: .touchUpInside)
        
        setupViews()
        setupSignupView()
        usernameField.addTarget(self, action: #selector(editingChanged),
                                for: .editingChanged)
        passwordField.addTarget(self, action: #selector(editingChanged),
                                for: .editingChanged)
        
        signupButton.addTarget(self, action: #selector(showSignupView), for: .touchUpInside)
        
    }
    
    /* Setup images for the buttons and setups textfields
     */
    func setupViews() {
        formatImageView(imageView: userIconBorder, color: UIColor.white.cgColor)
        formatImageView(imageView: passwordIconBorder, color: UIColor.white.cgColor)
        
        fbButton.imageView?.contentMode = .scaleAspectFill
        gplusButton.imageView?.contentMode = .scaleAspectFill
        
        signinButton.backgroundColor = disabledButtonColor
        signinButton.layer.cornerRadius = 20
        signinButton.isEnabled = false
        
        signupButton.backgroundColor = blueButtonColor
        signupButton.layer.cornerRadius = 20
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        
        formatTextField(textField: usernameField, color: UIColor.white.cgColor)
        formatTextField(textField: passwordField, color: UIColor.white.cgColor)
        
        scrollView.insertSubview(passwordIcon, belowSubview: signupView)
        scrollView.insertSubview(userIcon, belowSubview: signupView)
        scrollView.insertSubview(userIconBorder, belowSubview: signupView)
        scrollView.insertSubview(passwordIconBorder, belowSubview: signupView)
        scrollView.insertSubview(bars, belowSubview: signupView)
        scrollView.insertSubview(logo, belowSubview: signupView)
        
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
                signinButton.backgroundColor = disabledButtonColor
                return
        }
        signinButton.isEnabled = true
        signinButton.backgroundColor = blueButtonColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "oauthToUsernameSegue" {
            let resultVC = segue.destination as! UsernameEmailController
            resultVC.messageFromOauth = "changeButtonTargetFB"
            resultVC.oauthJSON = self.oauthJSON
            resultVC.fbToken = self.fbToken
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return genderData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return genderData[row]
    }
    
    /* Called whenever the user picks an item on the pickerview
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        self.gender = genderData[row]
        textFieldOne.text = genderData[row]
        checkAllFields()
    }
    
    /* Clears all fields of registration
     */
    override func clearInfo() {
        super.clearInfo()
        clearTextFields()
        self.validPw = false
        self.validEmail = false
        self.validUsername = false
    }
    
}
