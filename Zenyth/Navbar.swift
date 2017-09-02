//
//  Navbar.swift
//  Zenyth
//
//  Created by Hoang on 8/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

/**
 The toolbar used to navigate the app at the bottom
 */
class Navbar: UIToolbar {
    
    var home: UIBarButtonItem?
    var notification: UIBarButtonItem?
    var profile: UIBarButtonItem?
    
    var homeButton: UIButton?
    var notificationButton: UIButton?
    var profileButton: UIButton?
    
    init(view: UIView) {
        let viewFrame = view.frame
        let height = viewFrame.height * 0.07
        let width = viewFrame.width
        let x = viewFrame.origin.x
        let y = viewFrame.height - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Instantiate the toolbar
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.barStyle = .default
        self.isUserInteractionEnabled = true
        
        let buttonHeightToBarHeightRatio: CGFloat = 0.60
        let widthToHeightHomeIcon: CGFloat = 46.0/43.0
        let widthToHeightNotificationIcon: CGFloat = 17.0/55.0
        let widthToHeightFollowerIcon: CGFloat = 48.0/54.0
        
        // Create home button
        home = {
            let heightOfButton = height * buttonHeightToBarHeightRatio
            let widthOfButton = heightOfButton * widthToHeightHomeIcon
            let buttonFrame = CGRect(x: 0, y: 0, width: widthOfButton,
                                     height: heightOfButton)
            let button = UIButton(type: .custom)
            button.frame = buttonFrame
            button.setImage(#imageLiteral(resourceName: "home_icon_black"), for: .normal)
            homeButton = button
            let barbutton = UIBarButtonItem(customView: button)
            return barbutton
        }()
        
        // Create notification button
        notification = {
            let heightOfButton = height * buttonHeightToBarHeightRatio
            let widthOfButton = heightOfButton * widthToHeightNotificationIcon
            let buttonFrame = CGRect(x: 0, y: 0, width: widthOfButton,
                                     height: heightOfButton)
            let button = UIButton(type: .custom)
            button.frame = buttonFrame
            button.setImage(#imageLiteral(resourceName: "notification_icon_black"), for: .normal)
            notificationButton = button
            let barbutton = UIBarButtonItem(customView: button)
            return barbutton
        }()
        
        // Create profile button
        profile = {
            let heightOfButton = height * buttonHeightToBarHeightRatio
            let widthOfButton = heightOfButton * widthToHeightFollowerIcon
            let buttonFrame = CGRect(x: 0, y: 0, width: widthOfButton,
                                     height: heightOfButton)
            let button = UIButton(type: .custom)
            button.frame = buttonFrame
            button.setImage(#imageLiteral(resourceName: "follower_icon_black"), for: .normal)
            profileButton = button
            let barbutton = UIBarButtonItem(customView: button)
            return barbutton
        }()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let items: [UIBarButtonItem] = [flexibleSpace, home!, flexibleSpace, notification!,
                                        flexibleSpace, profile!, flexibleSpace]
        
        self.setItems(items, animated: false)
        
        //  Create shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: -2.0)
        self.layer.shadowRadius = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setHomeSelected() {
        homeButton?.setImage(#imageLiteral(resourceName: "home_icon_selected"), for: .normal)
        notificationButton?.setImage(#imageLiteral(resourceName: "notification_icon_black"), for: .normal)
        profileButton?.setImage(#imageLiteral(resourceName: "follower_icon_black"), for: .normal)
    }
    
    func setNotificationSelected() {
        homeButton?.setImage(#imageLiteral(resourceName: "home_icon_black"), for: .normal)
        notificationButton?.setImage(#imageLiteral(resourceName: "notification_icon_selected"), for: .normal)
        profileButton?.setImage(#imageLiteral(resourceName: "follower_icon_black"), for: .normal)
    }
    
    func setProfileSelected() {
        homeButton?.setImage(#imageLiteral(resourceName: "home_icon_black"), for: .normal)
        notificationButton?.setImage(#imageLiteral(resourceName: "notification_icon_black"), for: .normal)
        profileButton?.setImage(#imageLiteral(resourceName: "follower_icon_selected"), for: .normal)
    }
}
