//
//  PersonalInfoController.swift
//  Zenyth
//
//  Created by Hoang on 8/11/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

/// PersonalInfoController handling the personal info page
class PersonalInfoController: ModelViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var genderIconBorder: UIImageView!
    @IBOutlet weak var birthdayIconBorder: UIImageView!
    
    /// Options for the gender picker view
    let genderData = ["", "Male", "Female", "Non-binary"]
    
    /**
     Setup views and button target
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        signupButton.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        
        /// Make the gender picker show up as soon as the user get to the page
        genderField.becomeFirstResponder()
    }
    
    /**
     Setup views
     */
    func setupViews() {
        // Remove background
        backgroundView.removeFromSuperview()
        
        setupGenderPicker()
        setupDatePicker()
        
        // Setup signup button
        signupButton.backgroundColor = disabledButtonColor
        signupButton.isEnabled = false
        signupButton.layer.cornerRadius = 20
        
        // Format imageviews and textfields
        formatImageView(imageView: genderIconBorder, color: UIColor.darkGray.cgColor)
        formatImageView(imageView: birthdayIconBorder, color: UIColor.darkGray.cgColor)
        formatTextField(textField: genderField, color: UIColor.darkGray.cgColor)
        formatTextField(textField: birthdayField, color: UIColor.darkGray.cgColor)
    }
    
    /**
     Called when view has appeared.
     Check for validity of gender field and birthday field
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let module = RegistrationModule.sharedInstance
        genderField.text = module.gender
        birthdayField.text = module.birthday
        fieldCheck()
    }
    
    /** 
     Setup the gender picker
     */
    func setupGenderPicker() {
        let genderPicker = UIPickerView()
        genderField.inputView = genderPicker
        genderPicker.delegate = self
    }
    
    /** 
     Setup the date picker
     */
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        birthdayField.inputView = datePicker
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(changeDOBValue),
                             for: .valueChanged)
    }
    
    /** 
     When picker is picked, the date is saved to the RegistrationModule and the
     birthday textfield is changed
     
     - Parameter sender: the date picker
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
    
    /** 
     Check if user passes the age limit
     
     - Returns: Boolean indicating if user passes the age limit
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
    
    /**
     Check if gender and birthday textfields have been filled out
     */
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
    
    /**
     Signup button action
     
     - Parameter sender: signup button
     */
    func signupAction(_ sender: UIButton) {
        // Convert to yyyy-MM-dd form for the backend to understand
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let module = RegistrationModule.sharedInstance
        let date = dateFormatter.date(from: module.birthday!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let birthday = dateFormatter.string(from: date!)
        
        // Retrieve information from the RegistrationModule
        let username = module.username
        let email = module.email
        let password = module.password
        let passwordConfirmation = module.passwordConfirmation
        let gender = module.gender
        
        // Check if the user is of age to register
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
                LoginController.saveLoggedInUserInfo(user: user, apiToken: apiToken)
                
                
                let alert = UIAlertController(
                    title: RegistrationModule.signupSuccessfulMessage,
                    message: RegistrationModule.checkEmailMessage,
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(title: "OK",
                                              style: UIAlertActionStyle.default, handler:
                    { action in
                        RegistrationModule.sharedInstance.clearInfo()
                        self.transitionToHome()
                }))
                
                self.present(alert, animated: true, completion: nil)
        })
    }
    
    /**
     Return the number of components in picker view. Conforming to the
     UIPickerViewDelegate protocol
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**
     Return the number of options in the picker view. Conforming to the
     UIPickerViewDelegate protocol
     */
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return genderData.count
    }
    
    /**
     Return the information to display for each row in the picker view.
     Conforming to the UIPickerViewDelegate protocol
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return genderData[row]
    }
    
    /**
     Called when a row in the gender picker has been picked. Save the information
     to RegistrationModule and update the gender textfield.
     Conforming to the UIPickerViewDelegate protocol
     */

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        let gender = genderData[row]
        genderField.text = gender
        let module = RegistrationModule.sharedInstance
        module.setGender(gender: gender)
        fieldCheck()
    }
}
