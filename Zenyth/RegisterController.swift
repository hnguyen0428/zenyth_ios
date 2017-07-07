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
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorMessages: UITextView!
    
    @IBAction func maleButtonAction(_ sender: UIButton) {
        femaleButton.backgroundColor = .clear
        maleButton.backgroundColor = buttonBlue
        gender = "Male"
    }
    
    @IBAction func femaleButtonAction(_ sender: UIButton) {
        maleButton.backgroundColor = .clear
        femaleButton.backgroundColor = buttonBlue
        gender = "Female"
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        var parameters = [String:String]()
        parameters["first_name"] = firstName.text
        parameters["last_name"] = lastName.text
        parameters["email"] = email.text
        parameters["password"] = password.text
        parameters["password_confirmation"] = confirmPassword.text
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
                    
                    self.self.errorMessages.text = ""
                    for value in errors {
                        self.self.errorMessages.insertText(value.string! + "\n")
                    }
                    self.self.errorMessages.isHidden = false
                    
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
        
    }
    
    func setupViews() {
        firstName.backgroundColor = .clear
        lastName.backgroundColor = .clear
        email.backgroundColor = .clear
        password.backgroundColor = .clear
        confirmPassword.backgroundColor = .clear
        
        maleButton.layer.borderWidth = 1
        maleButton.layer.cornerRadius = 5
        maleButton.layer.borderColor = UIColor.white.cgColor
        
        femaleButton.layer.borderWidth = 1
        femaleButton.layer.cornerRadius = 5
        femaleButton.layer.borderColor = UIColor.white.cgColor
        
        registerButton.backgroundColor = buttonBlue
        registerButton.layer.cornerRadius = 20
        
        errorMessages.isHidden = true
        errorMessages.backgroundColor = .clear
        
        formatTextField(textField: firstName)
        formatTextField(textField: lastName)
        formatTextField(textField: email)
        formatTextField(textField: password)
        formatTextField(textField: confirmPassword)
    }
}
