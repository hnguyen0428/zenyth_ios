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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
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
            imageView.image = #imageLiteral(resourceName: "blurrybottom")
            imageView.contentMode = .scaleAspectFill
            imageView.center = self.view.center
            imageView.clipsToBounds = true
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
