//
//  ProfileView.swift
//  Zenyth
//
//  Created by Hoang on 8/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    weak var profilePicture: UIImageView?
    weak var nameLabel: UILabel?
    weak var bioText: UITextView?
    weak var usernameLabel: UILabel?
    weak var actionButton: UIButton? // Either edit profile or follow
    weak var settingsButton: UIButton?
    weak var topPinLabel: UILabel?
    weak var pinView: PinView?
    weak var userInfoBar: UserInfoBar?
    
    weak var controller: UIViewController?
    
    var maxHeight: CGFloat = 0
    
    // Constants for ui sizing
    static let HEIGHT_OF_PICTURE: CGFloat = 0.20
    
    // Username
    static let HEIGHT_OF_USERNAME_LABEL: CGFloat = 0.10
    static let WIDTH_OF_USERNAME_LABEL: CGFloat = 0.40
    static let USERNAME_TOP_INSET: CGFloat = 0.06
    static let USERNAME_LEFT_INSET: CGFloat = 0.03
    
    // Action button
    static let HEIGHT_OF_ACTION_BUTTON: CGFloat = 0.08
    static let WIDTH_OF_ACTION_BUTTON: CGFloat = 0.30
    static let TITLE_FONT_SIZE: CGFloat = 15.0
    static let EDIT_PROFILE_CORNER_RADIUS: CGFloat = 5.0
    static let FOREIGN_BUTTON_CORNER_RADIUS: CGFloat = 10.0
    static let FOREIGN_BUTTON_COLOR: UIColor = UIColor(r: 0, g: 131, b: 129)
    static let BORDER_WIDTH: CGFloat = 1.0
    
    // Settings button
    static let HEIGHT_OF_SETTINGS_BUTTON: CGFloat = 0.08
    
    // Name
    static let HEIGHT_OF_NAME_LABEL: CGFloat = 0.06
    static let WIDTH_OF_NAME_LABEL: CGFloat = 0.40
    static let NAME_LEFT_INSET: CGFloat = 0.05
    static let NAME_TOP_INSET: CGFloat = 0.01
    static let NAME_FONT_SIZE: CGFloat = 15.0
    
    // Biography
    static let HEIGHT_OF_BIO: CGFloat = 0.20
    static let WIDTH_OF_BIO: CGFloat = 0.90
    static let BIO_LEFT_INSET: CGFloat = 0.06
    static let BIO_FONT: String = "Verdana"
    static let BIO_FONT_SIZE: CGFloat = 15.0
    
    // Top Pins
    static let HEIGHT_OF_TOP_PINS: CGFloat = 0.10
    static let WIDTH_OF_TOP_PINS: CGFloat = 0.30
    static let TOP_PINS_FONT: String = "MarkerFelt-Wide"
    static let TOP_PINS_FONT_SIZE: CGFloat = 20.0
    
    // Pin view
    static let HEIGHT_OF_PIN_VIEW: CGFloat = 0.15
    
    // User info bar
    static let HEIGHT_OF_BAR: CGFloat = 0.08
    static let WIDTH_OF_BAR: CGFloat = 0.75
    static let BAR_TOP_INSET: CGFloat = 0.03
    static let BAR_LEFT_INSET: CGFloat = 0.08
    
    // General
    static let LEFT_INSET: CGFloat = 0.02
    static let RIGHT_INSET: CGFloat = 0.02
    static let TOP_INSET: CGFloat = 0.04
    
    init(_ controller: UIViewController, frame: CGRect, user: User,
         foreign: Bool = false, followStatus: String? = nil) {
        self.controller = controller
        super.init(frame: frame)
        
        self.setupProfilePicture(user: user)
        self.setupUsernameLabel(username: user.username)
        
        self.setupActionButton(foreign: foreign, followStatus: followStatus,
                               controller: controller)
        if !foreign {
            self.setupSettingsButton()
        }
        
        if let name = user.name() {
            self.setupNameLabel(name: name)
        }
        if let bio = user.biography {
            self.setupBioText(bio: bio)
        }
        if user.pinposts.count > 0 {
            self.setupTopPinLabel()
            self.setupPinView(pinposts: user.pinposts)
        }
        self.setupUserInfoBar(followers: user.followers!, likes: user.likes!,
                              numberOfPinposts: user.numberOfPinposts!)
        
        
        maxHeight = maxHeight + 15.0
        let size = CGSize(width: self.frame.width, height: maxHeight)
        self.frame = CGRect(origin: self.frame.origin, size: size)
        self.backgroundColor = UIColor.clear
        self.bottomRoundedWithShadow(radius: 25.0)
        
        // Adding target for button
        settingsButton?.addTarget(controller, action: #selector(ProfileController.transitionToSettings),
                                  for: .touchUpInside)
        
        if !foreign {
            actionButton?.addTarget(controller, action: #selector(ProfileController.transitionToEditProfile),
                                    for: .touchUpInside)
        }
        
        self.userInfoBar?.followerButton?.addTarget(controller, action: #selector(ProfileController.transitionToFollowersList), for: .touchUpInside)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupProfilePicture(user: User) {
        let heightPicture = self.frame.height * ProfileView.HEIGHT_OF_PICTURE
        let widthPicture = heightPicture
        let profilePictureFrame = CGRect(x: 0, y: 0, width: widthPicture,
                                         height: heightPicture)
        
        let profilePicture = UIImageView()
        self.profilePicture = profilePicture
        if let image = user.profilePicture {
            let url = URL(string: image.getURL(size: .small))
            profilePicture.sd_setImage(with: url,
                                       placeholderImage: #imageLiteral(resourceName: "default_profile"))
        }
        else {
            profilePicture.image = #imageLiteral(resourceName: "default_profile")
        }
        
        let container = profilePicture.roundedImageWithShadow(frame: profilePictureFrame)
        self.addSubview(container)
        
        let topConstant: CGFloat = self.frame.height * ProfileView.TOP_INSET
        let leftConstant: CGFloat = self.frame.width * ProfileView.LEFT_INSET
        container.anchor(topAnchor, left: leftAnchor, bottom: nil,
                         right: nil, topConstant: topConstant, leftConstant: leftConstant,
                         bottomConstant: 0, rightConstant: 0,
                         widthConstant: widthPicture,
                         heightConstant: heightPicture)
        
        maxHeight = maxHeight + heightPicture + topConstant
    }
    
    func setupUsernameLabel(username: String) {
        let height = self.frame.height * ProfileView.HEIGHT_OF_USERNAME_LABEL
        let width = self.frame.width * ProfileView.WIDTH_OF_USERNAME_LABEL
        let usernameLabel = UILabel()
        self.usernameLabel = usernameLabel
        usernameLabel.text = username
        
        self.addSubview(usernameLabel)
        
        let topConstant: CGFloat = self.frame.height * ProfileView.USERNAME_TOP_INSET
        let leftConstant: CGFloat = self.frame.width * ProfileView.USERNAME_LEFT_INSET
        usernameLabel.anchor(topAnchor,
                              left: profilePicture?.rightAnchor, bottom: nil,
                              right: nil, topConstant: topConstant, leftConstant: leftConstant,
                              bottomConstant: 0, rightConstant: 0,
                              widthConstant: width, heightConstant: height)
    }
    
    func setupActionButton(foreign: Bool, followStatus: String? = nil,
                           controller: UIViewController) {
        let height = self.frame.height * ProfileView.HEIGHT_OF_ACTION_BUTTON
        let width = self.frame.width * ProfileView.WIDTH_OF_ACTION_BUTTON
        let actionButton = UIButton()
        self.actionButton = actionButton
        if !foreign {
            actionButton.setTitle("Edit Profile", for: .normal)
            actionButton.setTitleColor(UIColor.black, for: .normal)
            actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: ProfileView.TITLE_FONT_SIZE)
            
            actionButton.layer.cornerRadius = ProfileView.EDIT_PROFILE_CORNER_RADIUS
            actionButton.layer.borderWidth = ProfileView.BORDER_WIDTH
            actionButton.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            if let status = followStatus {
                configureActionButton(status: status, controller: controller)
            }
        }
        
        self.addSubview(actionButton)
        actionButton.anchor(usernameLabel?.bottomAnchor, left: usernameLabel?.leftAnchor,
                             bottom: nil, right: nil, topConstant: 0, leftConstant: 0,
                             bottomConstant: 0, rightConstant: 0,
                             widthConstant: width, heightConstant: height)
    }
    
    func configureActionButton(status: String, controller: UIViewController) {
        if let button = actionButton {
            if status == "Request Sent" {
                button.removeTarget(nil, action: nil, for: .allEvents)
                button.addTarget(controller, action: #selector(ProfileController.unfollowUser),
                                 for: .touchUpInside)
                button.setTitle("Request Sent", for: .normal)
            }
            else if status == "Following" {
                button.removeTarget(nil, action: nil, for: .allEvents)
                button.addTarget(controller, action: #selector(ProfileController.unfollowUser),
                                 for: .touchUpInside)
                button.setTitle("Following", for: .normal)
            }
            else if status == "Not following" {
                button.removeTarget(nil, action: nil, for: .allEvents)
                button.addTarget(controller, action: #selector(ProfileController.followUser),
                                 for: .touchUpInside)
                button.setTitle("Follow +", for: .normal)
            }
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: ProfileView.TITLE_FONT_SIZE)
            button.layer.cornerRadius = ProfileView.FOREIGN_BUTTON_CORNER_RADIUS
            button.backgroundColor = ProfileView.FOREIGN_BUTTON_COLOR
        }
        else {
            return
        }
    }
    
    func setupSettingsButton() {
        let image = #imageLiteral(resourceName: "settings_icon")
        let height = self.frame.height * ProfileView.HEIGHT_OF_SETTINGS_BUTTON
        let width = height
        let settingsButton = UIButton()
        self.settingsButton = settingsButton
        settingsButton.setImage(image, for: .normal)
        
        self.addSubview(settingsButton)
        let topConstant = self.frame.height * ProfileView.TOP_INSET
        let rightConstant = self.frame.width * ProfileView.RIGHT_INSET
        settingsButton.anchor(topAnchor, left: nil, bottom: nil,
                               right: rightAnchor, topConstant: topConstant,
                               leftConstant: 0, bottomConstant: 0,
                               rightConstant: rightConstant, widthConstant: width,
                               heightConstant: height)
    }
    
    func setupNameLabel(name: String) {
        let height = self.frame.height * ProfileView.HEIGHT_OF_NAME_LABEL
        let width = self.frame.width * ProfileView.WIDTH_OF_NAME_LABEL
        let nameLabel = UILabel()
        self.nameLabel = nameLabel
        nameLabel.font = UIFont.boldSystemFont(ofSize: ProfileView.NAME_FONT_SIZE)
        nameLabel.text = name
        
        self.addSubview(nameLabel)
        let leftConstant: CGFloat = self.frame.width * ProfileView.NAME_LEFT_INSET
        let topConstant: CGFloat = self.frame.height * ProfileView.NAME_TOP_INSET
        nameLabel.anchor(profilePicture?.bottomAnchor,
                          left: leftAnchor, bottom: nil,
                          right: nil, topConstant: topConstant, leftConstant: leftConstant,
                          bottomConstant: 0, rightConstant: 0,
                          widthConstant: width, heightConstant: height)
        
        maxHeight = maxHeight + height + topConstant
    }
    
    func setupBioText(bio: String) {
        let height = self.frame.height * ProfileView.HEIGHT_OF_BIO
        let width = self.frame.width * ProfileView.WIDTH_OF_BIO
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let bioText = UITextView(frame: frame)
        self.bioText = bioText
        bioText.isUserInteractionEnabled = false
        bioText.font = UIFont(name: ProfileView.BIO_FONT, size: ProfileView.BIO_FONT_SIZE)
        bioText.text = bio
        bioText.backgroundColor = UIColor.clear
        
        self.addSubview(bioText)
        
        let leftConstant: CGFloat = self.frame.width * ProfileView.BIO_LEFT_INSET
        let rightConstant = leftConstant
        let textHeight = bioText.contentSize.height
        let topAnchor = nameLabel == nil ? profilePicture?.bottomAnchor : nameLabel?.bottomAnchor
        bioText.anchor(topAnchor,
                        left: leftAnchor,
                        bottom: nil, right: rightAnchor, topConstant: 0,
                        leftConstant: leftConstant, bottomConstant: 0, rightConstant: rightConstant,
                        widthConstant: width, heightConstant: textHeight)
        
        maxHeight = maxHeight + textHeight
    }
    
    func setupTopPinLabel() {
        let width = self.frame.width * ProfileView.WIDTH_OF_TOP_PINS
        let height = self.frame.height * ProfileView.HEIGHT_OF_TOP_PINS
        
        let topPinLabel = UILabel()
        self.topPinLabel = topPinLabel
        topPinLabel.text = "Top Pins"
        topPinLabel.textAlignment = NSTextAlignment.center
        topPinLabel.font = UIFont(name: ProfileView.TOP_PINS_FONT,
                                   size: ProfileView.TOP_PINS_FONT_SIZE)
        
        self.addSubview(topPinLabel)
        
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
        
        topPinLabel.anchor(topAnchor!, left: centerXAnchor, bottom: nil,
                            right: nil, topConstant: 0, leftConstant: -(width/2),
                            bottomConstant: 0, rightConstant: 0,
                            widthConstant: width, heightConstant: height)
        
        maxHeight = maxHeight + height
    }
    
    func setupPinView(pinposts: [Pinpost]) {
        let height = self.frame.width * ProfileView.HEIGHT_OF_PIN_VIEW
        let width = self.frame.width
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let pinView = PinView(controller!, frame: frame, pinposts: pinposts)
        self.pinView = pinView
        self.addSubview(pinView)
        pinView.anchor(topPinLabel?.bottomAnchor, left: self.leftAnchor, bottom: nil,
                        right: self.rightAnchor, topConstant: 0, leftConstant: 0,
                        bottomConstant: 0, rightConstant: 0,
                        widthConstant: width,
                        heightConstant: height)
        
        maxHeight = maxHeight + pinView.frame.height
    }
    
    func setupUserInfoBar(followers: UInt32, likes: UInt32, numberOfPinposts: UInt32) {
        let width = self.frame.width * ProfileView.WIDTH_OF_BAR
        let height = self.frame.height * ProfileView.HEIGHT_OF_BAR
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let userInfoBar = UserInfoBar(frame: frame)
        self.userInfoBar = userInfoBar
        userInfoBar.likeButton?.setTitle(String(likes), for: .normal)
        userInfoBar.pinButton?.setTitle(String(numberOfPinposts), for: .normal)
        userInfoBar.followerButton?.setTitle(String(followers), for: .normal)
        
        self.addSubview(userInfoBar)
        
        
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
        
        let topConstant: CGFloat = self.frame.height * ProfileView.BAR_TOP_INSET
        let leftConstant: CGFloat = self.frame.width * ProfileView.BAR_LEFT_INSET
        
        userInfoBar.anchor(topAnchor, left: pinView?.leftAnchor,
                            bottom: nil, right: nil, topConstant: topConstant,
                            leftConstant: leftConstant, bottomConstant: 0,
                            rightConstant: 0, widthConstant: width,
                            heightConstant: height)
        
        maxHeight = maxHeight + height + topConstant
    }
    
}
