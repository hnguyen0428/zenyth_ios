//
//  ModelViewController.swift
//  Zenyth
//
//  Created by Hoang on 7/12/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class ModelViewController: UIViewController, UITextFieldDelegate {
    
    var backgroundView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        for subview in view.subviews {
            if subview is UITextField {
                let textField = subview as! UITextField
                textField.delegate = self
            }
        }
        
    }
    
    /* Setups the background
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
    
    /* Checks if the textfields are all filled out corresponding to the
     * requirements before the button is enabled
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
    
    /* To be overridden by the class that extends from this class
     */
    func fieldCheck() {}
    
    func onPressingBack() {
        self.navigationController?.popViewController(animated: false)
    }
    
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
    
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil);
        let mapController: MapController =
            storyboard.instantiateInitialViewController()
                as! MapController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        UIView.transition(with: appDelegate.window!, duration: 0.3, options: .transitionCrossDissolve,
                          animations: {
                            appDelegate.window!.rootViewController = mapController
        }, completion: nil)
    }
    
}
