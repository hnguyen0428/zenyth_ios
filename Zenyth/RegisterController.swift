//
//  HomeDatasourceController.swift
//  Zenyth
//
//  Created by Hoang on 7/3/17.
//  Copyright © 2017 Hoang. All rights reserved.
//


import LBTAComponents
import Alamofire
import SwiftyJSON

class RegisterController: UIViewController {
    
    var gender:String? = nil
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func maleButtonAction(_ sender: UIButton) {
        femaleButton.backgroundColor = .clear
        maleButton.backgroundColor = buttonBlue
        gender = "Male"
        fieldCheck()
    }
    
    @IBAction func femaleButtonAction(_ sender: UIButton) {
        maleButton.backgroundColor = .clear
        femaleButton.backgroundColor = buttonBlue
        gender = "Female"
        fieldCheck()
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        var parameters = [String:String]()
        parameters["first_name"] = firstNameField.text
        parameters["last_name"] = lastNameField.text
        parameters["email"] = emailField.text
        parameters["password"] = passwordField.text
        parameters["password_confirmation"] = confirmPasswordField.text
        parameters["gender"] = gender
        
        let route = "register"
        let urlString = serverAddress + route
        let url = URL(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in switch response.result {
            
            case .success(let value):
                let json = JSON(value)
                
                if json["register"].boolValue {
                    
                    print("JSON: \(json)")
                    
                } else if let errors = json["errors"].array {
                    
                    var errorString = ""
                    for value in errors {
                        errorString.append(value.string! + "\n")
                    }
                    // strip the newline character at the end
                    errorString.remove(at: errorString.index(before: errorString.endIndex))
                    
                    // create the alert
                    let alert = UIAlertController(title: "Register Failed", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
                    
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
        firstNameField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        lastNameField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
    }
    
    func setupViews() {
        firstNameField.backgroundColor = .clear
        lastNameField.backgroundColor = .clear
        emailField.backgroundColor = .clear
        passwordField.backgroundColor = .clear
        confirmPasswordField.backgroundColor = .clear
        
        maleButton.layer.borderWidth = 1
        maleButton.layer.cornerRadius = 5
        maleButton.layer.borderColor = UIColor.white.cgColor
        
        femaleButton.layer.borderWidth = 1
        femaleButton.layer.cornerRadius = 5
        femaleButton.layer.borderColor = UIColor.white.cgColor
        
        registerButton.backgroundColor = disabledButtonBlue
        registerButton.layer.cornerRadius = 20
        registerButton.isEnabled = false
        
        formatTextField(textField: firstNameField)
        formatTextField(textField: lastNameField)
        formatTextField(textField: emailField)
        formatTextField(textField: passwordField)
        formatTextField(textField: confirmPasswordField)
    }
    
    func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        fieldCheck()
        
    }
    
    func fieldCheck() {
        
        guard
            let firstName = firstNameField.text, !firstName.isEmpty,
            let lastName = lastNameField.text, !lastName.isEmpty,
            let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty,
            let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty,
            gender != nil
            else {
                registerButton.isEnabled = false
                registerButton.backgroundColor = disabledButtonBlue
                return
        }
        registerButton.isEnabled = true
        registerButton.backgroundColor = buttonBlue
        
    }
    
}
