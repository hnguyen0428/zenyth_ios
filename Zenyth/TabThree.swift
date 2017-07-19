//
//  TabOne.swift
//  Zenyth
//
//  Created by Hoang on 7/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

extension LoginController {
    func setupTabThree() {
        clearTextFields()
        hideErrorLabel()
        enableButton(3)
        setupGenderPicker()
        setupDatePicker()
        iconOne.image = #imageLiteral(resourceName: "gendericon")
        iconTwo.image = #imageLiteral(resourceName: "calendar")
        enableSecureEntry(false)
        setTintColor(true)
        textLabelOne.text = "GENDER"
        textLabelTwo.text = "DATE OF BIRTH"
        if let text = gender {
            textFieldOne.text = text
        }
        if let text = dateOfBirth {
            textFieldTwo.text = text
        }
        textFieldOne.becomeFirstResponder()
    }
    
    /* Setups the gender picker
     */
    func setupGenderPicker() {
        let genderPicker = UIPickerView()
        textFieldOne.inputView = genderPicker
        genderPicker.delegate = self
    }
    
    /* Setups the gender picker
     */
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        textFieldTwo.inputView = datePicker
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
        textFieldTwo.text = date
        dateFormat.dateFormat = "yyyy-MM-dd"
        self.dateOfBirth = dateFormat.string(from: sender.date)
        checkAllFields()
    }
    
    func checkTabThree() -> Bool {
        let gender = self.gender ?? ""
        let dob = self.dateOfBirth ?? ""
        if gender == "" || dob == "" {
            return false
        }
        return true
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
