//
//  ModelViewController.swift
//  Zenyth
//
//  Created by Hoang on 7/12/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

/// The model view controller that other starter controllers should extend from
/// in order to get basic UI features
class ModelViewController: UIViewController, UITextFieldDelegate {
    
    var backgroundView: UIImageView!
    
    /**
     Called once the view is loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Add this controller as delegate to all textfields so that
        // textFieldShouldReturn() function can trigger
        for subview in view.subviews {
            if subview is UITextField {
                let textField = subview as! UITextField
                textField.delegate = self
            }
        }
        
    }
    
    /** 
     Setup the background and the back button of the navigation bar
     */
    func setup() {
        //self.scrollView = UIScrollView(frame: view.frame)
        //self.view.addSubview(scrollView)
        backgroundView = {
            let imageView = UIImageView(frame: self.view.frame)
            imageView.backgroundColor = .white
            return imageView
        }()
        self.view.insertSubview(backgroundView, at: 0)
        
        let backButton: UIButton = {
            let frame = CGRect(x: 0, y: 0, width: 15,
                               height: 25)
            let button = UIButton(frame: frame)
            button.contentMode = .scaleAspectFill
            button.backgroundColor = .clear
            button.setImage(#imageLiteral(resourceName: "back"), for: .normal)
            button.addTarget(self, action: #selector(onPressingBack),
                             for: .touchUpInside)
            return button
        }()
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    /** 
     Check if the textfields are all filled out corresponding to the
     requirements before the button is enabled
     
     - Parameter textField: textfield being edited
     */
    func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        fieldCheck()
        
    }
    
    /** 
     To be overridden by the class that extends from this class
     */
    func fieldCheck() {}
    
    /**
     Action done by pressing the back button on navigation controller's
     toolbar
     */
    func onPressingBack() {
        self.navigationController?.popViewController(animated: false)
    }
    
    /**
     When pressing next on the textfield, move on to the next textfield.
     This is done by setting the tag number of the next textfield to be just
     1 more than the current textfield's tag
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else if let nextField = textField.superview?.viewWithTag(textField.tag - 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    /**
     Transition to the Home page of the app. Called when successfully logged in
     */
    func transitionToHome() {
        //let storyboard = UIStoryboard(name: "Home", bundle: nil);
//        let mapController: MapController =
//            storyboard.instantiateInitialViewController()
//                as! MapController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.makeKeyAndVisible()
        let homeController = HomeController()
        
        UIView.transition(with: appDelegate.window!, duration: 0.3, options: .transitionCrossDissolve,
                          animations: {
                            appDelegate.window!.rootViewController = homeController
        }, completion: nil)
    }
    
}
