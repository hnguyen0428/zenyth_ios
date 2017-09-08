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
    
    //Simple way of defining a constant, non-mutable object
    // Curly braces indicates closure, and you execute the closure with () at the end,
    // gives you back the return value inside.
    
    private let profilePic: UIImageView = {
        
        let imageView = UIImageView()
        
//        // allows for auto resizing
//        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        let container = profilePic.roundedImageWithShadow(frame: frame)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(container)
        container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true // pin to left w/ 8 pixels of padding
        container.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        container.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.leftAnchor.constraint(equalTo: container.rightAnchor, constant: 8).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true // pushes left 8 pixels
        usernameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        
        addSubview(fullnameLabel)
        fullnameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4).isActive = true
        fullnameLabel.leftAnchor.constraint(equalTo: container.rightAnchor, constant: 8).isActive = true
        fullnameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        fullnameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // button management
        
        
        // round
        //followButton.layer.borderWidth = .5
        followButton.layer.cornerRadius = 8
        
        followButton.setTitle("Following", for: .normal)
        followButton.setTitleColor(UIColor.black, for: .normal)
        
        followButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(followButton)
        
        followButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
    }
    
    
    func buttonAction(sender: UIButton!) {
        
        if(followButton.currentTitle == "Following") {
            
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(UIColor.white, for: .normal)
            
            followButton.backgroundColor = .blue
            
            //followButton.titleLabel?.textAlignment = .center
            
            print("Button tapped")
            
        } else {
            
            followButton.setTitle("Following", for: .normal)
            followButton.setTitleColor(UIColor.black, for: .normal)
            followButton.backgroundColor = nil
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
