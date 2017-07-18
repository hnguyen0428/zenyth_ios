//
//  UIViewController+UIHelper.swift
//  Zenyth
//
//  Created by Hoang on 7/4/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import LBTAComponents
import UIKit

extension UIViewController {
    /* Format textfield so that it has only the line on the bottom
     */
    func formatTextField(textField: UITextField,
                         color: CGColor = disabledButtonColor.cgColor) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width,
                              width:  textField.frame.size.width,
                              height: textField.frame.size.height)
        
        border.borderWidth = 1
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func formatImageView(imageView: UIImageView) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: imageView.frame.size.height - width,
                              width:  imageView.frame.size.width,
                              height: imageView.frame.size.height)
        
        border.borderWidth = 1
        imageView.layer.addSublayer(border)
        imageView.layer.masksToBounds = true
    }
    
    func formatButton(button: UIButton) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: button.frame.size.width - width, y: 0,
                              width:  button.frame.size.width,
                              height: button.frame.size.height)
        
        border.borderWidth = 1
        button.layer.addSublayer(border)
        button.layer.masksToBounds = true
    }

    /* Displays an alert with title and message and an OK button
     */
    func displayAlert(view: UIViewController, title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.default,
                                      handler: nil))
        
        // show the alert
        view.present(alert, animated: true, completion: nil)
        
    }

    func isValidEmail(email: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isValidLengthUsername(username: String) -> Bool {
        let count = username.characters.count
        if count < minimumUsernameLength || count > maximumUsernameLength {
            return false
        }
        return true
    }
    
    func isValidCharactersUsername(username: String) -> Bool {
        let usernameRegEx = "[A-Z0-9a-z_]*"
        
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernameTest.evaluate(with: username)
    }
    
    func isValidUsername(username: String) -> Bool {
        return isValidLengthUsername(username: username) &&
                isValidCharactersUsername(username: username)
    }
    
    func isAlphaNumeric(testStr:String) -> Bool {
        let regEx = "[A-Z0-9a-z]*"
        
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with: testStr)
    }
    
    func isValidLengthPassword(password: String) -> Bool {
        let count = password.characters.count
        if count < minimumPasswordLength || count > maximumPasswordLength {
            return false
        }
        return true
    }
    
    func isValidPassword(password: String) -> Bool {
        return isAlphaNumeric(testStr: password) &&
                isValidLengthPassword(password: password)
    }
    
    func requestLoading(view: UIView) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(
            activityIndicatorStyle: .gray
        )
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        view.mask = UIView(frame: view.frame)
        view.mask?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(indicator)
        view.isUserInteractionEnabled = false
        return indicator
    }
    
    func requestDoneLoading(view: UIView, indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        view.isUserInteractionEnabled = true
        view.mask = nil
    }

}
