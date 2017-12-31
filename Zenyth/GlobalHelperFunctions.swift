//
//  GlobalHelperFunctions.swift
//  Zenyth
//
//  Created by Hoang on 8/14/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation

/**
 Check if a string is an email
 
 - Parameter email: email string to be checked
 - Returns: Boolean value
 */
func isValidEmail(email: String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}


/**
 Check if username has a valid length
 
 - Parameter username: username string to be checked
 - Returns: Boolean value
 */
func isValidLengthUsername(username: String) -> Bool {
    let count = username.characters.count
    if count < minimumUsernameLength || count > maximumUsernameLength {
        return false
    }
    return true
}

/**
 Check if username string contains valid characters
 
 - Parameter username: username string to be checked
 */
func isValidCharactersUsername(username: String) -> Bool {
    let usernameRegEx = "[A-Z0-9a-z_]*"
    
    let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
    return usernameTest.evaluate(with: username)
}

/**
 Check if username is valid
 
 - Parameter username: username to be checked
 - Returns: Boolean value
 */
func isValidUsername(username: String) -> Bool {
    return isValidLengthUsername(username: username) &&
        isValidCharactersUsername(username: username)
}

/**
 Check if a string is alpha numeric
 
 - Parameter testStr: string to be checked
 - Returns: Boolean value
 */
func isAlphaNumeric(testStr:String) -> Bool {
    let regEx = "[A-Z0-9a-z]*"
    
    let test = NSPredicate(format:"SELF MATCHES %@", regEx)
    return test.evaluate(with: testStr)
}

/**
 Check if the password has a valid length
 
 - Parameter password: password string to be checked
 - Returns: Boolean value
 */
func isValidLengthPassword(password: String) -> Bool {
    let count = password.characters.count
    if count < minimumPasswordLength || count > maximumPasswordLength {
        return false
    }
    return true
}

/**
 Check if the password is a valid password
 
 - Parameter password: password string to be checked
 - Returns: Boolean value
 */
func isValidPassword(password: String) -> Bool {
    return isAlphaNumeric(testStr: password) &&
        isValidLengthPassword(password: password)
}
