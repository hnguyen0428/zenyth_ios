//
//  PinpostFormController.swift
//  Zenyth
//
//  Created by Hoang on 8/23/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class PinpostFormController: UIViewController, UITextViewDelegate {
    
    var pinpostForm: PinpostForm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let heightNavbar = self.navigationController!.navigationBar.frame.height
        let y = heightNavbar
        let frame = CGRect(x: 0, y: y, width: view.frame.width,
                           height: view.frame.height - heightNavbar)
        pinpostForm = PinpostForm(frame: frame)
        pinpostForm.descriptionField.delegate = self
        
        view.addSubview(pinpostForm)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Give a description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
