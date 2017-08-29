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
    var nameLabel: UILabel?
    var bioText: UITextView?
    var usernameLabel: UILabel?
    var editProfileButton: UIButton?
    var settingsButton: UIButton?
    var topPinLabel: UILabel?
    var pinView: PinView?
    var userInfoBar: UserInfoBar?
    
    var maxHeight: CGFloat = 0
    
    // Used for simulating request loading
    var requestLoadingMask: UIView?
    var indicator: UIActivityIndicatorView?
    
    init(_ controller: UIViewController, name: String? = nil, bio: String? = nil,
         username: String, pinpostImages: [UIImage]? = nil, friends: UInt32, likes: UInt32,
         numberOfPinposts: UInt32, profilePicture: UIImage) {
        let view = controller.view!
        let height = view.frame.height * 0.50
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        super.init(frame: frame)
        
        self.setupProfilePicture(profileImage: profilePicture)
        self.setupUsernameLabel(username: username)
        self.setupEditProfileButton()
        self.setupSettingsButton()
        
        if name != nil {
            self.setupNameLabel(name: name!)
        }
        if bio != nil {
            self.setupBioText(bio: bio!)
        }
        if let images = pinpostImages {
            self.setupTopPinLabel()
            self.setupPinView(images: images)
        }
        self.setupUserInfoBar(friends: friends, likes: likes,
                              numberOfPinposts: numberOfPinposts)
        

        maxHeight = maxHeight + 15.0
        let size = CGSize(width: self.frame.width, height: maxHeight)
        self.frame = CGRect(origin: self.frame.origin, size: size)
        self.backgroundColor = UIColor.clear
        self.bottomRoundedWithShadow(radius: 25.0)
        
        // Adding target for button
        settingsButton?.addTarget(controller, action: #selector(ProfileController.transitionToSettings),
                                  for: .touchUpInside)
        editProfileButton?.addTarget(controller, action: #selector(ProfileController.transitionToEditProfile),
                                     for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupProfilePicture(profileImage: UIImage) {
        let heightPicture = self.frame.height * 0.20
        let widthPicture = heightPicture
        let profilePictureFrame = CGRect(x: 0, y: 0, width: widthPicture,
                                         height: heightPicture)
        
        self.profilePicture = UIImageView()
        profilePicture!.image = profileImage
        let container = profilePicture!.roundedImageWithShadow(frame: profilePictureFrame)
        self.addSubview(container)
        
        let topConstant: CGFloat = 25.0
        let leftConstant: CGFloat = 10.0
        container.anchor(topAnchor, left: leftAnchor, bottom: nil,
                         right: nil, topConstant: topConstant, leftConstant: leftConstant,
                         bottomConstant: 0, rightConstant: 0,
                         widthConstant: profilePictureFrame.width,
                         heightConstant: profilePictureFrame.height)
        
        maxHeight = maxHeight + heightPicture + topConstant
    }
    
    func setupUsernameLabel(username: String) {
        let height = self.frame.height * 0.10
        let width = self.frame.width * 0.40
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        usernameLabel = UILabel(frame: frame)
        usernameLabel!.text = username
        
        self.addSubview(usernameLabel!)
        
        let topConstant: CGFloat = 10.0
        let leftConstant: CGFloat = 10.0
        usernameLabel?.anchor(profilePicture?.topAnchor,
                              left: profilePicture?.rightAnchor, bottom: nil,
                              right: nil, topConstant: topConstant, leftConstant: leftConstant,
                              bottomConstant: 0, rightConstant: 0,
                              widthConstant: frame.width, heightConstant: frame.height)
    }
    
    func setupEditProfileButton() {
        let height = self.frame.height * 0.08
        let width = self.frame.width * 0.30
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        editProfileButton = UIButton(frame: frame)
        editProfileButton!.setTitle("Edit Profile", for: .normal)
        editProfileButton!.setTitleColor(UIColor.black, for: .normal)
        editProfileButton!.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        editProfileButton!.layer.cornerRadius = 5
        editProfileButton!.layer.borderWidth = 1
        editProfileButton!.layer.borderColor = UIColor.lightGray.cgColor
        
        self.addSubview(editProfileButton!)
        editProfileButton!.anchor(usernameLabel?.bottomAnchor, left: usernameLabel?.leftAnchor,
                                  bottom: nil, right: nil, topConstant: 0, leftConstant: 0,
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
    
    func setupNameLabel(name: String) {
        let height = self.frame.height * 0.05
        let width = self.frame.width * 0.40
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        nameLabel = UILabel(frame: frame)
        nameLabel!.font = UIFont.boldSystemFont(ofSize: 15.0)
        nameLabel!.text = name
        
        self.addSubview(nameLabel!)
        let margin: CGFloat = 20.0
        let topConstant: CGFloat = 5.0
        nameLabel?.anchor(profilePicture?.bottomAnchor,
                          left: leftAnchor, bottom: nil,
                          right: nil, topConstant: topConstant, leftConstant: margin,
                          bottomConstant: 0, rightConstant: 0,
                          widthConstant: frame.width, heightConstant: frame.height)
        
        maxHeight = maxHeight + height + topConstant
    }
    
    func setupBioText(bio: String) {
        let height = self.frame.height * 0.20
        let width = self.frame.width * 0.90
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        bioText = UITextView(frame: frame)
        bioText!.isUserInteractionEnabled = false
        bioText!.font = UIFont(name: "Verdana", size: 15.0)
        bioText?.text = bio
        bioText?.backgroundColor = UIColor.clear
        
        self.addSubview(bioText!)
        
        let margin: CGFloat = 20.0
        let textHeight = bioText!.contentSize.height
        let topAnchor = nameLabel == nil ? profilePicture?.bottomAnchor : nameLabel?.bottomAnchor
        bioText?.anchor(topAnchor,
                        left: leftAnchor,
                        bottom: nil, right: rightAnchor, topConstant: 0,
                        leftConstant: margin, bottomConstant: 0, rightConstant: margin,
                        widthConstant: frame.width, heightConstant: textHeight)
        
        maxHeight = maxHeight + textHeight
    }
    
    func setupTopPinLabel() {
        let width = self.frame.width * 0.30
        let height = self.frame.height * 0.10
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        topPinLabel = UILabel(frame: frame)
        topPinLabel!.text = "Top Pins"
        topPinLabel!.textAlignment = NSTextAlignment.center
        topPinLabel!.font = UIFont(name: "MarkerFelt-Wide", size: 20.0)
        
        self.addSubview(topPinLabel!)
        
        var topAnchor: NSLayoutYAxisAnchor? = nil
        if bioText != nil {
            topAnchor = bioText?.bottomAnchor
        }
        else if nameLabel != nil {
            topAnchor = nameLabel?.bottomAnchor
        }
        else {
            topAnchor = profilePicture?.bottomAnchor
        }
        
        topPinLabel?.anchor(topAnchor!, left: centerXAnchor, bottom: nil,
                            right: nil, topConstant: 0, leftConstant: -(frame.width/2),
                            bottomConstant: 0, rightConstant: 0,
                            widthConstant: frame.width, heightConstant: frame.height)
        
        maxHeight = maxHeight + height
    }
    
    func setupPinView(images: [UIImage]) {
        pinView = PinView(view: self)
        
        for i in 0..<images.count {
            if i > 4 {
                break
            }
            pinView?.pinImages[i].image = images[i]
        }
        
        self.addSubview(pinView!)
        pinView?.anchor(topPinLabel?.bottomAnchor, left: nil, bottom: nil,
                        right: nil, topConstant: 0, leftConstant: 0,
                        bottomConstant: 0, rightConstant: 0,
                        widthConstant: pinView!.frame.width,
                        heightConstant: pinView!.frame.height)
        
        maxHeight = maxHeight + pinView!.frame.height
    }
    
    func setupUserInfoBar(friends: UInt32, likes: UInt32, numberOfPinposts: UInt32) {
        let width = self.frame.width * 0.75
        let height = self.frame.height * 0.08
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        userInfoBar = UserInfoBar(frame: frame)
        userInfoBar!.likeButton?.setTitle(String(likes), for: .normal)
        userInfoBar!.pinButton?.setTitle(String(numberOfPinposts), for: .normal)
        userInfoBar!.followerButton?.setTitle(String(friends), for: .normal)
        
        self.addSubview(userInfoBar!)
        let verticalMargin: CGFloat = 15.0
        
        var topAnchor: NSLayoutYAxisAnchor? = nil
        if pinView != nil {
            topAnchor = pinView?.bottomAnchor
        }
        else if bioText != nil {
            topAnchor = bioText?.bottomAnchor
        }
        else if nameLabel != nil {
            topAnchor = nameLabel?.bottomAnchor
        }
        else {
            topAnchor = profilePicture?.bottomAnchor
        }
        
        userInfoBar!.anchor(topAnchor, left: pinView?.leftAnchor,
                            bottom: nil, right: nil, topConstant: verticalMargin,
                            leftConstant: 25.0, bottomConstant: 0,
                            rightConstant: 0, widthConstant: frame.width,
                            heightConstant: frame.height)
        
        maxHeight = maxHeight + height + verticalMargin
    }
    
    func setImages(images: [UIImage]) {
        for i in 0..<images.count {
            pinView?.pinImages[i].image = images[i]
        }
    }
    
}
