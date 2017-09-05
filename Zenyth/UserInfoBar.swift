//
//  UserInfoBar.swift
//  Zenyth
//
//  Created by Hoang on 8/18/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class UserInfoBar: UIToolbar {
    
    weak var likeButton: InfoAsset?
    weak var followerButton: InfoAsset?
    weak var pinButton: InfoAsset?
    
    // UI Sizing
    static let WIDTH_OF_BUTTON: CGFloat = 0.33
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        self.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let widthButton = frame.width * UserInfoBar.WIDTH_OF_BUTTON
        let heightButton = frame.height
        let buttonFrame = CGRect(x: 0, y: 0, width: widthButton, height: heightButton)
        
        let likeButton = InfoAsset(image: #imageLiteral(resourceName: "like_icon"), frame: buttonFrame)
        self.likeButton = likeButton
        let followerButton = InfoAsset(image: #imageLiteral(resourceName: "followers_icon"), frame: buttonFrame)
        self.followerButton = followerButton
        let pinButton = InfoAsset(image: #imageLiteral(resourceName: "pin_icon"), frame: buttonFrame)
        self.pinButton = pinButton
        
        let likeBarButton: UIBarButtonItem = {
            let button = UIBarButtonItem(customView: likeButton)
            return button
        }()
        
        let followerBarButton: UIBarButtonItem = {
            let button = UIBarButtonItem(customView: followerButton)
            return button
        }()
        
        let pinBarButton: UIBarButtonItem = {
            let button = UIBarButtonItem(customView: pinButton)
            return button
        }()
        
        let items: [UIBarButtonItem] = [likeBarButton, flexibleSpace, followerBarButton,
                                        flexibleSpace, pinBarButton]
        self.setItems(items, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        debugPrint("Deinitializing \(self)")
    }
}
