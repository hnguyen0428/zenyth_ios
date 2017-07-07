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

class LoginController: UIViewController {
    
    
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var gplusButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        var parameters = [String:String]()
        parameters["email"] = emailField.text
        parameters["password"] = passwordField.text
        
        let route = "login"
        let urlString = serverAddress + route
        let url = URL(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if json["login"].boolValue {
                    
                    print("JSON: \(json)")
                    
                } else if let errors = json["errors"].array {
                    
                    var errorString = ""
                    for value in errors {
                        errorString.append(value.string! + "\n")
                    }
                    // strip the newline character at the end
                    errorString.remove(at: errorString.index(before: errorString.endIndex))
                    
                    // create the alert
                    let alert = UIAlertController(title: "Login Failed", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView: UIImageView = {
            let imageView = UIImageView(frame: view.frame)
            imageView.image = background
            imageView.contentMode = .scaleAspectFill
            imageView.center = self.view.center
            imageView.clipsToBounds = true
            return imageView
        }()
        
        self.view.insertSubview(backgroundView, at: 0)
        
        setupViews()
        emailField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
    }
    
    func setupViews() {
        fbButton.setImage(#imageLiteral(resourceName: "Facebook_Icon"), for: .normal)
        twitterButton.setImage(#imageLiteral(resourceName: "Twitter_Icon"), for: .normal)
        gplusButton.setImage(#imageLiteral(resourceName: "Google_Plus_Icon"), for: .normal)
        
        fbButton.imageView?.contentMode = .scaleAspectFit
        twitterButton.imageView?.contentMode = .scaleAspectFit
        gplusButton.imageView?.contentMode = .scaleAspectFit
        
        emailField.backgroundColor = .clear
        passwordField.backgroundColor = .clear
        
        signinButton.backgroundColor = disabledButtonBlue
        signinButton.layer.cornerRadius = 20
        signinButton.isEnabled = false
        
        formatTextField(textField: emailField)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty
            else {
                signinButton.isEnabled = false
                signinButton.backgroundColor = disabledButtonBlue
                return
        }
        signinButton.isEnabled = true
        signinButton.backgroundColor = buttonBlue
    }
    
}
