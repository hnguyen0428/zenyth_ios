//
//  UserCell.swift
//  FollowersWindow
//
//  Created by Robert  Koepp on 9/2/17.
//  Copyright © 2017 Robert Koepp. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    // add button toggle
    let followButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
    static let LC_PROFILE_PIC: CGFloat = 8
    static let TC_PROFILE_PIC: CGFloat = 5
    static let WIDTH_PROFILE_PIC: CGFloat = 50
    
    static let LC_USERNAME: CGFloat = 8
    static let RC_USERNAME: CGFloat = -8
    static let HEIGHT_OF_USERNAME: CGFloat = 20
    static let CENTER_Y_USERNAME: CGFloat = -10
    
    static let TC_FULLNAME: CGFloat = 4
    static let LC_FULLNAME: CGFloat = 8
    static let RC_FULLNAME: CGFloat = -8
    static let HEIGHT_OF_FULLNAME: CGFloat = 20
    
    static let RC_BUTTON: CGFloat = -10
    
    var user: User? {
        didSet{
            
            //everytime a user is set in user cell
            if let image = user?.profilePicture {
                let url = URL(string: image.getURL(size: .small))
                profilePic.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "default_profile"))
            }
            else {
                profilePic.image = #imageLiteral(resourceName: "default_profile")
            }
            
            usernameLabel.text = user?.username
            fullnameLabel.text = user?.name()
        }
    }
    
    var followStatus: String? {
        didSet {
            if followStatus == "Following" {
                followButton.setTitle("Following", for: .normal)
            }
            else if followStatus == "Not following" {
                followButton.setTitle("Follow +", for: .normal)
            }
            else if followStatus == "Request sent" {
                followButton.setTitle("Request Sent", for: .normal)
            }
            followButton.setTitleColor(UIColor.white, for: .normal)
            followButton.backgroundColor = ProfileView.FOREIGN_BUTTON_COLOR
        }
    }
    
    var noFollowButton: Bool? {
        didSet {
            if noFollowButton! {
                followButton.removeFromSuperview()
            }
        }
    }
    
    // Simple way of defining a constant, non-mutable object
    // Curly braces indicates closure, and you execute the closure with () at the end,
    // gives you back the return value inside.
    
    private let profilePic: UIImageView = {
        
        let imageView = UIImageView()
        return imageView
        
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.text = "FullName"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // overide intializer
    // allows rendering
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let width = UserCell.WIDTH_PROFILE_PIC
        let height = width
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let container = profilePic.roundedImageWithShadow(frame: frame)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let tcProfilePic = UserCell.TC_PROFILE_PIC
        let bcProfilePic = tcProfilePic
        let lcProfilePic = UserCell.LC_PROFILE_PIC
        
        addSubview(container)
        
        container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: tcProfilePic).isActive = true
        container.topAnchor.constraint(equalTo: self.topAnchor, constant: lcProfilePic).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bcProfilePic).isActive = true
        container.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        let lcUsername = UserCell.LC_USERNAME
        let rcUsername = UserCell.RC_USERNAME
        let heightUsername = UserCell.HEIGHT_OF_USERNAME
        let centerYUsername = UserCell.CENTER_Y_USERNAME
        
        addSubview(usernameLabel)
        usernameLabel.leftAnchor.constraint(equalTo: container.rightAnchor, constant: lcUsername).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: rcUsername).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: heightUsername).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: centerYUsername).isActive = true
        
        let tcFullname = UserCell.TC_FULLNAME
        let lcFullname = UserCell.LC_FULLNAME
        let rcFullname = UserCell.RC_FULLNAME
        let heightFullname = UserCell.HEIGHT_OF_FULLNAME
        
        addSubview(fullnameLabel)
        fullnameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: tcFullname).isActive = true
        fullnameLabel.leftAnchor.constraint(equalTo: container.rightAnchor, constant: lcFullname).isActive = true
        fullnameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: rcFullname).isActive = true
        fullnameLabel.heightAnchor.constraint(equalToConstant: heightFullname).isActive = true
        
        
        followButton.setTitleColor(UIColor.black, for: .normal)
        followButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: ProfileView.TITLE_FONT_SIZE)
        followButton.layer.cornerRadius = ProfileView.FOREIGN_BUTTON_CORNER_RADIUS
        followButton.backgroundColor = .white
        followButton.setTitle("Loading", for: .normal)
        
        followButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        
        let rcButton = UserCell.RC_BUTTON
        
        addSubview(followButton)
        followButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: rcButton).isActive = true
        followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    
    func buttonAction(sender: UIButton!) {
        let title = followButton.currentTitle
        if(title == "Following") {
            
            let alert = UIAlertController(title: "Unfollow \(user!.username)",
                message: nil,
                preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Unfollow", style: .default, handler:
                { action in
                    RelationshipManager().unfollowUser(withUserId: self.user!.id,
                                                       onSuccess:
                        { json in
                            if json["success"].boolValue {
                                self.followButton.setTitle("Follow +", for: .normal)
                            }
                    })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        } else if (title == "Follow +") {
            
            RelationshipManager().sendFollowerRequest(toRequesteeId: self.user!.id,
                                                      onSuccess:
                { relationship in
                    if relationship.status {
                        self.followButton.setTitle("Following", for: .normal)
                    }
                    else {
                        self.followButton.setTitle("Request Sent", for: .normal)
                    }
            })
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//Notes
/*
 
 Auto layout needs to be provided with x coord, y coord, width, height (rectangle on where to render)
 */
