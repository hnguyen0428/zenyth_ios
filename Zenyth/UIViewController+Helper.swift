//
//  UIViewController+UIHelper.swift
//  Zenyth
//
//  Created by Hoang on 7/4/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

/// Extension to UIViewController including helper methods
extension UIViewController {
    /** 
     Format textfield so that it has the line on the bottom
     
     - Parameter textField: textfield to be formatted
     - Parameter color: color of the bottom border
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
    
    /**
     Format the image view so that it has the line on the bottom
     
     - Parameter imageView: image view to be formatted
     - Parameter color: color of the bottom border
     */
    func formatImageView(imageView: UIImageView,
                         color: CGColor = UIColor.gray.cgColor) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: imageView.frame.size.height - width,
                              width:  imageView.frame.size.width,
                              height: imageView.frame.size.height)
        
        border.borderWidth = 1
        imageView.layer.addSublayer(border)
        imageView.layer.masksToBounds = true
    }
    
    /**
     Format the button so that it has the line on the bottom
     
     - Parameter button: button to be formatted
     */
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

    /** 
     Displays an alert with title and message and an OK button
     
     - Parameter view: the UIViewController that is calling this function
     - Parameter title: title of the alert
     - Parameter message: message of the alert
     */
    func displayAlert(view: UIViewController, title: String, message: String) {
        // Create the alert
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        // Add an action (button)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.default,
                                      handler: nil))
        
        // Show the alert
        view.present(alert, animated: true, completion: nil)
        
    }
    
    /**
     Create an activity indicator and put it in the center of the view and dim
     the view
     
     - Parameter view: the view that the indicator is presented on
     - Returns: UIActivityIndicatorView that is created
     */
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
    
    /**
     Stop the activity indicator and remove the dimmed mask from UIView
     
     - Parameter view: UIView
     - Parameter indicator: activity indicator to be stopped
     */
    func requestDoneLoading(view: UIView, indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        view.isUserInteractionEnabled = true
        view.mask = nil
    }

}
