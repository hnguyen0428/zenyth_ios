//
//  RegisterController.swift
//  Zenyth
//
//  Created by Hoang on 7/14/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class RegistrationModule {
    
    var username: String?
    var email: String?
    var password: String?
    var passwordConfirmation: String?
    var gender: String?
    var birthday: String?
    
    static let sharedInstance = RegistrationModule()
    
    private init() {}
    
    static let usernameTakenMessage = "is already taken!"
    static let usernameAvailableMessage = "is available!"
    static let emailTakenMessage = "Email is already taken!"
    static let emailAvailableMessage = "Email is available!"
    static let passwordLengthError = "Password must be in between 8 to 16 characters"
    static let passwordAlphaNumericError = "Password must be alpha numeric"
    static let confirmPasswordNotMatchError = "Confirmation password does not match"
    static let activityIndicatorChecking = "     Checking"
    static let invalidEmailMessage = "This field must be an email"
    static let usernameRules = "Username must be between 3 to 20 characters"
    static let usernameInvalidCharacters = "Username can only contain [a-zA-Z0-9] and _"
    static let checkEmailMessage = "Please Check Your Email"
    static let signupSuccessfulMessage = "Signup Successful"
    static let notOfAgeMessage = "You're too young!"
    
    static let mergeMessageGoogle = "A Google account with the same email" +
                        " has already been created. Do you want to merge?"
    static let mergeMessageFacebook = "A Facebook account with the same email" +
                        " has already been created. Do you want to merge?"
    static let mergeMessageRegular = "An account with the same email" +
                        " has already been created. Do you want to merge?"

    func setUsername(username: String) {
        self.username = username
    }
    
    func setEmail(email: String) {
        self.email = email
    }
    
    func setPassword(password: String) {
        self.password = password
    }
    
    func setPasswordConfirmation(passwordConfirmation: String) {
        self.passwordConfirmation = passwordConfirmation
    }
    
    func setGender(gender: String) {
        self.gender = gender
    }
    
    func setBirthday(birthday: String) {
        self.birthday = birthday
    }
    
    func clearInfo() {
        username = nil
        email = nil
        password = nil
        passwordConfirmation = nil
        gender = nil
        birthday = nil
    }
    
    func printInfo() {
        print(username)
        print(email)
        print(password)
        print(passwordConfirmation)
        print(gender)
        print(birthday)
    }
    
}
