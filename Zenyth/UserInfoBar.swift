//
//  UserInfoBar.swift
//  Zenyth
//
//  Created by Hoang on 8/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class UserInfoBar: UIToolbar {
    
    var likeBarButton: UIBarButtonItem?
    var followerBarButton: UIBarButtonItem?
    var pinBarButton: UIBarButtonItem?
    
    var likeButton: InfoAsset?
    var followerButton: InfoAsset?
    var pinButton: InfoAsset?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        self.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let widthButton = frame.width * 0.33
        let heightButton = frame.height
        let buttonFrame = CGRect(x: 0, y: 0, width: widthButton, height: heightButton)
        
        likeButton = InfoAsset(image: #imageLiteral(resourceName: "like_icon"), frame: buttonFrame)
        followerButton = InfoAsset(image: #imageLiteral(resourceName: "followers_icon"), frame: buttonFrame)
        pinButton = InfoAsset(image: #imageLiteral(resourceName: "pin_icon"), frame: buttonFrame)
        
        likeBarButton = {
            let button = UIBarButtonItem(customView: likeButton!)
            return button
        }()
        
        followerBarButton = {
            let button = UIBarButtonItem(customView: followerButton!)
            return button
        }()
        
        pinBarButton = {
            let button = UIBarButtonItem(customView: pinButton!)
            return button
        }()
        
        let items: [UIBarButtonItem] = [likeBarButton!, flexibleSpace, followerBarButton!,
                                        flexibleSpace, pinBarButton!]
        self.setItems(items, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
