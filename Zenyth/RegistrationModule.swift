//
//  RegistrationModule.swift
//  Zenyth
//
//  Created by Hoang on 7/14/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

/// Module used for registering the user
class RegistrationModule {
    
    var username: String?
    var email: String?
    var password: String?
    var passwordConfirmation: String?
    var gender: String?
    var birthday: String?
    
    /// A shared module singleton used to share info between different pages
    /// of registration
    static let sharedInstance = RegistrationModule()
    
    // Prevent instantiation of another module
    private init() {}
    
    /// MESSAGE CONSTANTS
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

    /**
     Set username
     - Parameter username: username to be set
     */
    func setUsername(username: String) {
        self.username = username
    }
    
    /**
     Set email
     - Parameter email: email to be set
     */
    func setEmail(email: String) {
        self.email = email
    }
    
    /**
     Set password
     - Parameter password: password to be set
     */
    func setPassword(password: String) {
        self.password = password
    }
    
    /**
     Set password confirmation
     - Parameter passwordConfirmation: password confirmation to be set
     */
    func setPasswordConfirmation(passwordConfirmation: String) {
        self.passwordConfirmation = passwordConfirmation
    }
    
    /**
     Set gender
     - Parameter gender: gender to be set
     */
    func setGender(gender: String) {
        self.gender = gender
    }
    
    /**
     Set birthday
     - Parameter birthday: birthday to be set
     */
    func setBirthday(birthday: String) {
        self.birthday = birthday
    }
    
    /**
     Clear the information of the module
     */
    func clearInfo() {
        username = nil
        email = nil
        password = nil
        passwordConfirmation = nil
        gender = nil
        birthday = nil
    }
    
}
