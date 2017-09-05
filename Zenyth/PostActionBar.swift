//
//  PostActionBar.swift
//  Zenyth
//
//  Created by Hoang on 8/22/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class PostActionBar: UIToolbar {
    
    weak var likeButton: UIButton?
    weak var bookmarkButton: UIButton?
    weak var commentButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Adding buttons
        let likeButtonImage = #imageLiteral(resourceName: "like_icon")
        let bookmarkButtonImage = #imageLiteral(resourceName: "bookmark_icon")
        let commentButtonImage = #imageLiteral(resourceName: "Comment_icon")
        
        // Width to height ratio of icon size
        let ratioLikeIcon = likeButtonImage.size.width / likeButtonImage.size.height
        let ratioBookmarkIcon = bookmarkButtonImage.size.width / bookmarkButtonImage.size.height
        let ratioCommentIcon = commentButtonImage.size.width / commentButtonImage.size.height
        
        let buttonHeight = self.frame.height * 0.80
        
        let likeBarButton: UIBarButtonItem = {
            let buttonWidth = buttonHeight * ratioLikeIcon
            let buttonFrame = CGRect(x: 0, y: 0,
                                     width: buttonWidth, height: buttonHeight)
            let button = UIButton(frame: buttonFrame)
            button.setImage(#imageLiteral(resourceName: "like_icon"), for: .normal)
            button.backgroundColor = UIColor.clear
            button.contentMode = .scaleAspectFit
            self.likeButton = button
            let barbutton = UIBarButtonItem(customView: button)
            return barbutton
        }()
        
        let bookmarkBarButton: UIBarButtonItem = {
            let buttonWidth = buttonHeight * ratioBookmarkIcon
            let buttonFrame = CGRect(x: 0, y: 0,
                                     width: buttonWidth, height: buttonHeight)
            let button = UIButton(frame: buttonFrame)
            button.setImage(#imageLiteral(resourceName: "bookmark_icon"), for: .normal)
            button.backgroundColor = UIColor.clear
            button.contentMode = .scaleAspectFit
            self.bookmarkButton = button
            let barbutton = UIBarButtonItem(customView: button)
            return barbutton
        }()
        
        let commentBarButton: UIBarButtonItem = {
            let buttonWidth = buttonHeight * ratioCommentIcon
            let buttonFrame = CGRect(x: 0, y: 0,
                                     width: buttonWidth, height: buttonHeight)
            let button = UIButton(frame: buttonFrame)
            button.setImage(#imageLiteral(resourceName: "Comment_icon"), for: .normal)
            button.backgroundColor = UIColor.clear
            button.contentMode = .scaleAspectFit
            self.commentButton = button
            let barbutton = UIBarButtonItem(customView: button)
            return barbutton
        }()
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let items: [UIBarButtonItem] = [likeBarButton, flex, bookmarkBarButton,
                                        flex, commentBarButton]
        self.setItems(items, animated: false)
        self.backgroundColor = UIColor.clear
        self.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        debugPrint("Deinitializing \(self)")
    }
}
