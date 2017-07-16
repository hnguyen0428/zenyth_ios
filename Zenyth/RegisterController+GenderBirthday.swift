//
//  RegisterController+GenderBirthday.swift
//  Zenyth
//
//  Created by Hoang on 7/14/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class GenderBirthdayController: RegisterController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let genderData = ["", "Male", "Female", "Non-binary"]
    
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        
        let parameters: Parameters = [
            "username" : username!,
            "email" : email!,
            "password" : password!,
            "password_confirmation" : confirmPassword!,
            "gender" : gender!,
            "birthday" : dateOfBirth!
        ]
        
        let request = RegisterRequestor(parameters: parameters)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        self.view.mask = UIView(frame: self.view.frame)
        self.view.mask?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(indicator)
        self.view.isUserInteractionEnabled = false
        
        request.getJSON { data, error in
            indicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.view.mask = nil
            if (error != nil) {
                return
            }
            if (data?["success"].boolValue)! {
                let user = User.init(json: data!)
                print("User: \(user)")
                let alert = UIAlertController(title: self.signupSuccessfulMessage,
                                              message: self.checkEmailMessage,
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let errors = (data?["errors"].arrayValue)!
                var errorString = ""
                for item in errors {
                    errorString.append(item.stringValue + "\n")
                }
                // strip the newline character at the end
                errorString.remove(at: errorString.index(before: errorString.endIndex))
                
                self.displayAlert(view: self, title: "Login Failed", message: errorString)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        for subview in view.subviews {
            if !(subview is UIScrollView) && !(subview is UIImageView) {
                scrollView.addSubview(subview)
            }
        }
    }
    
    func setupViews() {
        signupButton.backgroundColor = disabledButtonColor
        signupButton.layer.cornerRadius = 20
        signupButton.isEnabled = false
        
        formatTextField(textField: genderField)
        formatTextField(textField: dobField)
        
        setupGenderPicker()
        setupDatePicker()
        
        genderField.text = gender
        dobField.text = dateOfBirth
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
    
    /* Setups the gender picker
     */
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        dobField.inputView = datePicker
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(changeDOBValue), for: .valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.tintColor = UIColor.white
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.backgroundColor = buttonColor
        toolBar.isTranslucent = true
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePicker))
        
        toolBar.setItems([doneButton], animated: true)
        
        dobField.inputAccessoryView = toolBar
    }
    
    func donePicker(sender: UIBarButtonItem) {
        genderField.isUserInteractionEnabled = true
        genderField.resignFirstResponder()
        dobField.isUserInteractionEnabled = true
        dobField.resignFirstResponder()
    }
    
    func changeDOBValue(sender: UIDatePicker) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMMM dd, yyyy"
        let date = dateFormat.string(from: sender.date)
        dobField.text = date
        dateFormat.dateFormat = "yyyy-MM-dd"
        self.dateOfBirth = dateFormat.string(from: sender.date)
        fieldCheck()
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
        self.gender = genderData[row]
        genderField.text = genderData[row]
        fieldCheck()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fieldCheck()
        navigationController?.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let passwordVC = viewController as? PasswordController {
            passwordVC.username = username
            passwordVC.email = email
            passwordVC.gender = genderField.text
            passwordVC.dateOfBirth = dobField.text
        }
    }
    
    /* Overridden rules for checking the field before enabling the button
     */
    override func fieldCheck() {
        
        guard
            let gender = genderField.text, !gender.isEmpty,
            let birthdate = dobField.text, !birthdate.isEmpty
            else {
                signupButton.isEnabled = false
                signupButton.backgroundColor = disabledButtonColor
                return
        }
        signupButton.isEnabled = true
        signupButton.backgroundColor = buttonColor
        
    }
    
}
