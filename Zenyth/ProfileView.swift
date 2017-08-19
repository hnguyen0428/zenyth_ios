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
    
    // Used for simulating request loading
    var requestLoadingMask: UIView?
    var indicator: UIActivityIndicatorView?
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupProfilePicture() {
        let heightPicture = self.frame.height * 0.20
        let widthPicture = heightPicture
        let profilePictureFrame = CGRect(x: 0, y: 0, width: widthPicture,
                                         height: heightPicture)
        
        let container = UIView(frame: profilePictureFrame)
        container.clipsToBounds = false
        container.layer.masksToBounds = false
        container.layer.shadowPath = UIBezierPath(roundedRect: container.bounds,
                                                  cornerRadius: profilePictureFrame.height/2).cgPath
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        container.layer.shadowRadius = 2.0
        container.layer.shadowOpacity = 0.5
        
        let image = UIImageView(frame: container.bounds)
        image.layer.cornerRadius = profilePictureFrame.height/2
        image.clipsToBounds = true
        
        image.backgroundColor = UIColor.clear
        profilePicture = image
        container.addSubview(image)
        self.addSubview(container)
        
        container.anchor(topAnchor, left: leftAnchor, bottom: nil,
                               right: nil, topConstant: 25.0, leftConstant: 10.0,
                               bottomConstant: 0, rightConstant: 0,
                               widthConstant: profilePictureFrame.width,
                               heightConstant: profilePictureFrame.height)
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
        bioText!.isUserInteractionEnabled = false
        bioText!.font = UIFont.systemFont(ofSize: 17.0)
        bioText!.backgroundColor = UIColor.clear
        
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
    
    func requestLoading() {
        indicator = UIActivityIndicatorView(
            activityIndicatorStyle: .gray
        )
        indicator!.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicator!.center = self.center
        indicator!.hidesWhenStopped = true
        indicator!.startAnimating()
        requestLoadingMask = UIView(frame: self.frame)
        requestLoadingMask!.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        requestLoadingMask!.bottomRounded(radius: 25.0)
        self.addSubview(requestLoadingMask!)
        self.addSubview(indicator!)
        self.isUserInteractionEnabled = false
    }
    
    func requestDoneLoading() {
        indicator?.removeFromSuperview()
        requestLoadingMask?.removeFromSuperview()
        self.isUserInteractionEnabled = true
    }
    
}
