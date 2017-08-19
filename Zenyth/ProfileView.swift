//
//  ProfileView.swift
//  Zenyth
//
//  Created by Hoang on 8/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    var profilePicture: UIImageView?
    var bioText: UITextView?
    var usernameLabel: UILabel?
    var settingsButton: UIButton?
    var topPinLabel: UILabel?
    
    init(view: UIView) {
        let height = view.frame.height / 2
        let width = view.frame.width
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        super.init(frame: frame)
        
        profilePicture = UIImageView()
        profilePicture?.backgroundColor = UIColor.red
        
        self.addSubview(profilePicture!)
        profilePicture?.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 15.0, leftConstant: 15.0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        self.backgroundColor = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
