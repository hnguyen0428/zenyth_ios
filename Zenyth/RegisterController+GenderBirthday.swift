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

class GenderBirthdayController: RegisterController, UIPickerViewDelegate,
                                UIPickerViewDataSource {
    
    let genderData = ["", "Male", "Female", "Non-binary"]
    
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        
        if self.notOfAge() {
            self.displayAlert(view: self, title: "Not Eligible",
                              message: notOfAgeMessage)
            return
        }
        
        let parameters: Parameters = [
            "username" : username!,
            "email" : email!,
            "password" : password!,
            "password_confirmation" : confirmPassword!,
            "gender" : gender!,
            "birthday" : dateOfBirth!
        ]
        
        let request = RegisterRequestor(parameters: parameters)
        let indicator = UIActivityIndicatorView(
            activityIndicatorStyle: .whiteLarge
        )
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
                let alert = UIAlertController(
                    title: self.signupSuccessfulMessage,
                    message: self.checkEmailMessage,
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.default, handler: { action in
                    self.navigationController?.popToRootViewController(
                        animated: true
                    )
                })
                )
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let errors = (data?["errors"].arrayValue)!
                var errorString = ""
                for item in errors {
                    errorString.append(item.stringValue + "\n")
                }
                // strip the newline character at the end
                errorString.remove(
                    at: errorString.index(before: errorString.endIndex)
                )
                
                self.displayAlert(view: self, title: "Login Failed",
                                  message: errorString)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
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
        
        // Create a done button on the toolbar on the picker
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.tintColor = UIColor.white
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.backgroundColor = buttonColor
        toolBar.isTranslucent = true
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.done, target: self,
            action: #selector(donePicker)
        )
        
        toolBar.setItems([doneButton], animated: true)
        
        genderField.inputAccessoryView = toolBar
    }
    
    /* Setups the gender picker
     */
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        dobField.inputView = datePicker
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(changeDOBValue),
                             for: .valueChanged)
        
        // Create a done button on the toolbar on the picker
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.tintColor = UIColor.white
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.backgroundColor = buttonColor
        toolBar.isTranslucent = true
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonSystemItem.done, target: self,
            action: #selector(donePicker)
        )
        
        toolBar.setItems([doneButton], animated: true)
        
        dobField.inputAccessoryView = toolBar
    }
    
    /* Clicking done closes the pickerview
     */
    func donePicker(sender: UIBarButtonItem) {
        genderField.isUserInteractionEnabled = true
        genderField.resignFirstResponder()
        dobField.isUserInteractionEnabled = true
        dobField.resignFirstResponder()
    }
    
    /* When picker is picked, the dateOfBirth variable is updated and the
     * textfield is changed
     */
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
        genderField.text = genderData[row]
        fieldCheck()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check the fields everytime this screen appears
        fieldCheck()
        // Allow for the navigation controller to read data from this class
        navigationController?.delegate = self
    }
    
    /* Allow for passing data when pressing back on the navigation bar
     */
    func navigationController(_ navigationController: UINavigationController,
                    willShow viewController: UIViewController, animated: Bool) {
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
    
    /* Check if user passes the age limit
     */
    func notOfAge() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let now = Date()
        let birthday = dateFormatter.date(from: dateOfBirth!)
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year],
                                                    from: birthday!, to: now)
        let age = ageComponents.year!
        
        return age < minimumAge
    }
    
}
