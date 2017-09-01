//
//  CommentCreateView.swift
//  Zenyth
//
//  Created by Hoang on 8/30/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

/**
 View for making a comment
 */
class CommentCreateView: UIView {
    
    var textfield: PaddedTextField!
    var postButton: UIButton!
    
    static let GAP: CGFloat = 0.03
    static let TOP_INSET: CGFloat = 0.10
    static let COMMENT_WIDTH: CGFloat = 0.74
    static let COMMENT_HEIGHT: CGFloat = 0.80
    static let BUTTON_WIDTH: CGFloat = 0.18
    static let BUTTON_HEIGHT: CGFloat = 0.60
    static let BUTTON_TOP_INSET: CGFloat = 0.20
    static let GAP_B_FIELD_A_BUTTON: CGFloat = 0.015
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextfield()
        setupPostButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTextfield() {
        let width = self.frame.width * CommentCreateView.COMMENT_WIDTH
        let height = self.frame.height * CommentCreateView.COMMENT_HEIGHT
        let x = self.frame.width * CommentCreateView.GAP
        let y = self.frame.height * CommentCreateView.TOP_INSET
        let frame = CGRect(x: x, y: y, width: width, height: height)
        textfield = PaddedTextField(frame: frame)
        textfield.placeholder = "Add a comment ..."
        textfield.layer.borderColor = UIColor.darkGray.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.layer.cornerRadius = 10.0
        
        self.backgroundColor = .white
        self.addSubview(textfield)
    }
    
    func setupPostButton() {
        let width = self.frame.width * CommentCreateView.BUTTON_WIDTH
        let height = self.frame.height * CommentCreateView.BUTTON_HEIGHT
        let gap = self.frame.width * CommentCreateView.GAP_B_FIELD_A_BUTTON
        let x = textfield.frame.maxX + gap
        let y = self.frame.height * CommentCreateView.BUTTON_TOP_INSET
        let frame = CGRect(x: x, y: y, width: width, height: height)
        postButton = UIButton(type: .system)
        postButton.frame = frame
        postButton.layer.borderColor = UIColor.blue.cgColor
        postButton.layer.cornerRadius = 5.0
        postButton.layer.cornerRadius = 1.0
        postButton.setTitle("Comment", for: .normal)
        
        self.addSubview(postButton)
    }
}
