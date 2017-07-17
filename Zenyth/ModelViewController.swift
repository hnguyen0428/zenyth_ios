//
//  ModelViewController.swift
//  Zenyth
//
//  Created by Hoang on 7/12/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class ModelViewController: UIViewController, UITextFieldDelegate {
    
    var scrollView: UIScrollView!
    var backgroundView: UIImageView!
    var logoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Add observer that allows for scrolling once you enter keyboard mode
        NotificationCenter.default.addObserver(self,
                                selector:#selector(self.keyboardWillShow),
                                name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                selector: #selector(self.keyboardWillHide),
                                name: NSNotification.Name.UIKeyboardWillHide,
                                object: nil)
        
        for subview in view.subviews {
            if subview is UITextField {
                let textField = subview as! UITextField
                textField.delegate = self
            }
        }
        
        // Add all subviews to allow for scroll once the keyboard pops up
        for subview in view.subviews {
            if !(subview is UIScrollView) && !(subview is UIImageView) {
                scrollView.addSubview(subview)
            }
        }
        
    }
    
    /* Setups the background
     */
    func setup() {
        self.scrollView = UIScrollView(frame: view.frame)
        self.view.addSubview(scrollView)
        
        backgroundView = {
            let imageView = UIImageView(frame: scrollView.frame)
            imageView.image = background
            imageView.contentMode = .scaleAspectFill
            imageView.center = self.view.center
            imageView.clipsToBounds = true
            return imageView
        }()
        self.view.insertSubview(backgroundView, at: 0)
        
        logoView = {
            // CHANGE: NO MAGIC NUMBER
            let width: CGFloat = 29.0
            let height: CGFloat = 52.0
            let frame = CGRect(x: view.center.x - (width/2),
                               y: view.center.y/3.5, width: width,
                               height: height)
            let imageView = UIImageView(frame: frame)
            imageView.image = #imageLiteral(resourceName: "Logo")
            return imageView
        }()
        
        scrollView.addSubview(logoView)
        
        self.hideKeyboardWhenTappedAround()
        
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
        self.navigationController?.popViewController(animated: true)
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
    
}
