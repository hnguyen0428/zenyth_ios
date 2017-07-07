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

class RegisterController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let genderData = ["Male", "Female", "Non-binary"]
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        var parameters = [String:String]()
        parameters["first_name"] = firstNameField.text
        parameters["last_name"] = lastNameField.text
        parameters["email"] = emailField.text
        parameters["password"] = passwordField.text
        parameters["password_confirmation"] = confirmPasswordField.text
        parameters["gender"] = genderField.text
        
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
        
        registerButton.backgroundColor = disabledButtonColor
        registerButton.layer.cornerRadius = 20
        registerButton.isEnabled = false
        
        formatTextField(textField: firstNameField)
        formatTextField(textField: lastNameField)
        formatTextField(textField: emailField)
        formatTextField(textField: passwordField)
        formatTextField(textField: confirmPasswordField)
        formatTextField(textField: genderField)
        
        setupGenderPicker()
    }
    
    func setupGenderPicker() {
        let genderPicker = UIPickerView()
        genderField.inputView = genderPicker
        genderPicker.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.tintColor = UIColor.white
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.backgroundColor = buttonColor
        toolBar.isTranslucent = true
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePicker))
        
        toolBar.setItems([doneButton], animated: true)
        
        genderField.inputAccessoryView = toolBar
    }
    
    func donePicker(sender: UIBarButtonItem) {
        genderField.resignFirstResponder()
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
            let gender = genderField.text, !gender.isEmpty
            else {
                registerButton.isEnabled = false
                registerButton.backgroundColor = disabledButtonColor
                return
        }
        registerButton.isEnabled = true
        registerButton.backgroundColor = buttonColor
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genderData[row]
    }
    
}
