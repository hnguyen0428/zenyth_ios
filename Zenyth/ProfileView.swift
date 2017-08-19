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
    var pinView: PinView?
    var userInfoBar: UserInfoBar?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupProfilePicture()
        self.setupUsernameLabel()
        self.setupSettingsButton()
        self.setupBioText()
        self.setupTopPinLabel()
        self.setupPinView()
        self.setupUserInfoBar()
        
        self.backgroundColor = UIColor.clear
        self.bottomRoundedWithShadow(radius: 25.0)
        //self.bottomRounded(radius: 25.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupProfilePicture() {
        let heightPicture = self.frame.height * 0.20
        let widthPicture = heightPicture
        let profilePictureFrame = CGRect(x: 0, y: 0, width: widthPicture,
                                         height: heightPicture)
        profilePicture = UIImageView(frame: profilePictureFrame)
        
        
        self.addSubview(profilePicture!)
        profilePicture?.anchor(topAnchor, left: leftAnchor, bottom: nil,
                               right: nil, topConstant: 25.0, leftConstant: 10.0,
                               bottomConstant: 0, rightConstant: 0,
                               widthConstant: profilePictureFrame.width,
                               heightConstant: profilePictureFrame.height)
        
        profilePicture!.layer.masksToBounds = false
        profilePicture!.layer.cornerRadius = profilePicture!.frame.height/2
        profilePicture?.clipsToBounds = true
    }
    
    func setupUsernameLabel() {
        let height = self.frame.height * 0.10
        let width = self.frame.width * 0.40
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        usernameLabel = UILabel(frame: frame)
        
        self.addSubview(usernameLabel!)
        usernameLabel?.anchor(profilePicture?.topAnchor,
                              left: profilePicture?.rightAnchor, bottom: nil,
                              right: nil, topConstant: 10.0, leftConstant: 10.0,
                              bottomConstant: 0, rightConstant: 0,
                              widthConstant: frame.width, heightConstant: frame.height)
    }
    
    func setupSettingsButton() {
        let image = #imageLiteral(resourceName: "settings_icon")
        let height = self.frame.height * 0.08
        let width = height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        settingsButton = UIButton(frame: frame)
        settingsButton?.setImage(image, for: .normal)
        
        self.addSubview(settingsButton!)
        settingsButton?.anchor(topAnchor, left: nil, bottom: nil,
                               right: rightAnchor, topConstant: 30.0,
                               leftConstant: 0, bottomConstant: 0,
                               rightConstant: 15.0, widthConstant: frame.width,
                               heightConstant: frame.height)
    }
    
    func setupBioText() {
        let height = self.frame.height * 0.20
        let width = self.frame.width * 0.90
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        bioText = UITextView(frame: frame)
        
        bioText!.font = UIFont.systemFont(ofSize: 17.0)
        
        self.addSubview(bioText!)
        
        let margin: CGFloat = 20.0
        
        bioText?.anchor(profilePicture?.bottomAnchor,
                        left: leftAnchor,
                        bottom: nil, right: rightAnchor, topConstant: 15.0,
                        leftConstant: margin, bottomConstant: 0, rightConstant: margin,
                        widthConstant: frame.width, heightConstant: frame.height)
    }
    
    func setupTopPinLabel() {
        let width = self.frame.width * 0.30
        let height = self.frame.height * 0.10
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        topPinLabel = UILabel(frame: frame)
        topPinLabel!.text = "Top Pins"
        topPinLabel!.textAlignment = NSTextAlignment.center
        topPinLabel!.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        self.addSubview(topPinLabel!)
        topPinLabel?.anchor(bioText?.bottomAnchor, left: centerXAnchor, bottom: nil,
                            right: nil, topConstant: 0, leftConstant: -(frame.width/2),
                            bottomConstant: 0, rightConstant: 0,
                            widthConstant: frame.width, heightConstant: frame.height)
    }
    
    func setupPinView() {
        pinView = PinView(view: self)
        
        self.addSubview(pinView!)
        pinView?.anchor(topPinLabel?.bottomAnchor, left: nil, bottom: nil,
                        right: nil, topConstant: 0, leftConstant: 0,
                        bottomConstant: 0, rightConstant: 0,
                        widthConstant: pinView!.frame.width,
                        heightConstant: pinView!.frame.height)
    }
    
    func setupUserInfoBar() {
        let width = self.frame.width * 0.75
        let height = self.frame.height * 0.08
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        userInfoBar = UserInfoBar(frame: frame)
        
        self.addSubview(userInfoBar!)
        let verticalMargin: CGFloat = 15.0
        userInfoBar!.anchor(pinView?.bottomAnchor, left: pinView?.leftAnchor,
                            bottom: bottomAnchor, right: nil, topConstant: verticalMargin,
                            leftConstant: 25.0, bottomConstant: verticalMargin,
                            rightConstant: 0, widthConstant: frame.width,
                            heightConstant: frame.height)
    }
    
    func setLikesCount(count: UInt32) {
        userInfoBar?.likeButton?.setTitle(String(count), for: .normal)
    }
    
    func setPinpostsCount(count: UInt32) {
        userInfoBar?.pinButton?.setTitle(String(count), for: .normal)
    }
    
    func setFollowersCount(count: UInt32) {
        userInfoBar?.followerButton?.setTitle(String(count), for: .normal)
    }
    
    func setPinImage(image: UIImage, index: Int) {
        self.pinView?.pinImages[index].image = image
    }
    
}
