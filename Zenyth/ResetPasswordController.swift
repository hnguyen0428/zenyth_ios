//
//  ResetPasswordController.swift
//  Zenyth
//
//  Created by Emily Heejung Son on 7/16/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class ResetPasswordController: ModelViewController {

    @IBOutlet weak var usernameEmailField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        resetPasswordButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    func buttonAction(_ button: UIButton) {
        //ldksjgldkjgflksdhbjdlfs;djgdlfksjHELLO HAVE A NICE SUMMER HI THIS IS EMILY EMILY WROTE THIS CODE
    }
    
    func setupViews() {
        formatTextField(textField: usernameEmailField)
        errorLabel.isHidden = true
        indicator.hidesWhenStopped = true
        resetPasswordButton.backgroundColor = disabledButtonColor
        resetPasswordButton.layer.cornerRadius = 20
        resetPasswordButton.isEnabled = false
    }
    
    func enableButton() {
        resetPasswordButton.backgroundColor = buttonColor
        resetPasswordButton.isEnabled = true
    }
}
