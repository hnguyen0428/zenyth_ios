//
//  ModelViewController.swift
//  Zenyth
//
//  Created by Hoang on 7/12/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class ModelViewController: UIViewController {
    
    let minimumPasswordLength = 8
    var scrollView: UIScrollView!
    var backgroundView: UIImageView!
    var logoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    /* Setups the background
     */
    func setup() {
        self.scrollView = UIScrollView(frame: view.frame)
        self.view.addSubview(scrollView)
        
        backgroundView = {
            let imageView = UIImageView(frame: view.frame)
            imageView.image = background
            imageView.contentMode = .scaleAspectFill
            imageView.center = self.view.center
            imageView.clipsToBounds = true
            return imageView
        }()
        self.view.insertSubview(backgroundView, at: 0)
        
        logoView = {
            // CHANGE: NO MAGIC NUMBER
            let frame = CGRect(x: 173, y: 112, width: 29, height: 52)
            let imageView = UIImageView(frame: frame)
            imageView.image = #imageLiteral(resourceName: "Logo")
            return imageView
        }()
        self.view.insertSubview(logoView, at: 1)
        
        scrollView.addSubview(logoView)
        
        self.hideKeyboardWhenTappedAround()
        
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
    
}
