//
//  UIViewController+UIHelper.swift
//  Zenyth
//
//  Created by Hoang on 7/4/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import LBTAComponents

extension UIViewController {
    /* Format textfield so that it has only the line on the bottom
     */
    func formatTextField(textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = 1
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }

    /* Displays an alert with title and message and an OK button
     */
    func displayAlert(view: UIViewController, title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        view.present(alert, animated: true, completion: nil)
        
    }

    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
