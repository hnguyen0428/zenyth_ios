//
//  PersonalInfoController.swift
//  Zenyth
//
//  Created by Hoang on 8/11/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class PersonalInfoController: ModelViewController, UIPickerViewDelegate {
    
    
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var genderIconBorder: UIImageView!
    @IBOutlet weak var birthdayIconBorder: UIImageView!
    
    let genderData = ["", "Male", "Female", "Non-binary"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        signupButton.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        
        genderField.becomeFirstResponder()
    }
    
    func setupViews() {
        // Remove background
        backgroundView.removeFromSuperview()
        
        setupGenderPicker()
        setupDatePicker()
        
        signupButton.backgroundColor = disabledButtonColor
        signupButton.isEnabled = false
        signupButton.layer.cornerRadius = 20
        
        formatImageView(imageView: genderIconBorder, color: UIColor.darkGray.cgColor)
        formatImageView(imageView: birthdayIconBorder, color: UIColor.darkGray.cgColor)
        
        formatTextField(textField: genderField, color: UIColor.darkGray.cgColor)
        formatTextField(textField: birthdayField, color: UIColor.darkGray.cgColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let module = RegistrationModule.sharedInstance
        genderField.text = module.gender
        birthdayField.text = module.birthday
    }
    
    /* Setups the gender picker
     */
    func setupGenderPicker() {
        let genderPicker = UIPickerView()
        genderField.inputView = genderPicker
        genderPicker.delegate = self
    }
    
    /* Setups the gender picker
     */
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        birthdayField.inputView = datePicker
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(changeDOBValue),
                             for: .valueChanged)
    }
    
    /* When picker is picked, the dateOfBirth variable is updated and the
     * textfield is changed
     */
    func changeDOBValue(sender: UIDatePicker) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMMM dd, yyyy"
        let date = dateFormat.string(from: sender.date)
        birthdayField.text = date
        
        let module = RegistrationModule.sharedInstance
        module.setBirthday(birthday: date)
        fieldCheck()
    }
    
    /* Check if user passes the age limit
     */
    func notOfAge() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let now = Date()
        let module = RegistrationModule.sharedInstance
        let birthday = dateFormatter.date(from: module.birthday!)
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year],
                                                    from: birthday!, to: now)
        let age = ageComponents.year!
        
        return age < minimumAge
    }
    
    override func fieldCheck() {
        guard
            let gender = genderField.text, !gender.isEmpty,
            let birthday = birthdayField.text, !birthday.isEmpty
            else {
                signupButton.isEnabled = false
                signupButton.backgroundColor = disabledButtonColor
                return
        }
        signupButton.isEnabled = true
        signupButton.backgroundColor = blueButtonColor
    }
    
    /// Send sign up request to backend
    func signupAction(_ sender: UIButton) {
        // Convert to yyyy-MM-dd form for the backend to understand
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let module = RegistrationModule.sharedInstance
        let date = dateFormatter.date(from: module.birthday!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let birthday = dateFormatter.string(from: date!)
        let username = module.username
        let email = module.email
        let password = module.password
        let passwordConfirmation = module.passwordConfirmation
        let gender = module.gender
        
        if self.notOfAge() {
            self.displayAlert(view: self, title: "Not Eligible",
                              message: RegistrationModule.notOfAgeMessage)
            return
        }
        let indicator = requestLoading(view: self.view)
        
        RegistrationManager().register(withUsername: username!,
                                       email: email!,
                                       password: password!,
                                       passwordConfirmation: passwordConfirmation!,
                                       gender: gender!.lowercased(),
                                       birthday: birthday,
                                       onSuccess:
            { user, apiToken in
                self.requestDoneLoading(view: self.view, indicator: indicator)
                print(user)
                
                let alert = UIAlertController(
                    title: RegistrationModule.signupSuccessfulMessage,
                    message: RegistrationModule.checkEmailMessage,
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(title: "OK",
                                              style: UIAlertActionStyle.default, handler:
                    { action in
                        RegistrationModule.sharedInstance.clearInfo()
                        self.navigationController?.popToRootViewController(animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
        })
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        let gender = genderData[row]
        genderField.text = gender
        let module = RegistrationModule.sharedInstance
        module.setGender(gender: gender)
        fieldCheck()
    }
}
