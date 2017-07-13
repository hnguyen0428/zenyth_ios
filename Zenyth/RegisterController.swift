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

class RegisterController: ModelViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let genderData = ["", "Male", "Female", "Non-binary"]
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        let parameters: Parameters = [
            "username" : usernameField.text,
            "email" : emailField.text,
            "password" : passwordField.text,
            "password_confirmation" : confirmPasswordField.text,
            "gender" : genderField.text
        ]
        
        let requestor = RegisterRequestor(parameters: parameters)
        let request = requestor.execute()
        
        request.responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                
                if json["success"].boolValue {
                    
                    print("JSON: \(json)")
                    
                } else {
                    let errors = json["errors"].arrayValue
                    var errorString = ""
                    for item in errors {
                        errorString.append(item.stringValue + "\n")
                    }
                    // strip the newline character at the end
                    errorString.remove(at: errorString.index(before: errorString.endIndex))
                    
                    self.displayAlert(view: self, title: "Register Failed", message: errorString)
                    
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
        
        setupViews()
        usernameField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        for subview in view.subviews {
            if !(subview is UIScrollView) && !(subview is UIImageView) {
                print("Subview: ", subview)
                scrollView.addSubview(subview)
            }
        }
        
    }
    
    func setupViews() {
        registerButton.backgroundColor = disabledButtonColor
        registerButton.layer.cornerRadius = 20
        registerButton.isEnabled = false
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        emailField.autocorrectionType = UITextAutocorrectionType.no
        
        formatTextField(textField: usernameField)
        formatTextField(textField: emailField)
        formatTextField(textField: passwordField)
        formatTextField(textField: confirmPasswordField)
        formatTextField(textField: genderField)
        
        setupGenderPicker()
    }
    
    /* Setups the gender picker
     */
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
        genderField.isUserInteractionEnabled = true
        genderField.resignFirstResponder()
        fieldCheck()
    }
    
    /* Overridden rules for checking the field before enabling the button
     */
    override func fieldCheck() {
        
        guard
            let username = usernameField.text, !username.isEmpty,
            let email = emailField.text, !email.isEmpty && isValidEmail(testStr: email),
            let password = passwordField.text, !password.isEmpty &&
                            password.characters.count >= minimumPasswordLength,
            let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty &&
                            confirmPassword.characters.count >= minimumPasswordLength,
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
    
    /* Called whenever the user picks an item on the pickerview
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genderData[row]
    }
    
}
