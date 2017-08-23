//
//  FeedView.swift
//  Zenyth
//
//  Created by Hoang on 8/22/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class FeedView: UIView {
    
    var feedInfoView: FeedInfoView?
    var profilePicView: UIImageView?
    var thumbnailView: UIImageView?
    
    var maxHeight: CGFloat = 0
    
    // Height in percentage
    static let HEIGHT_OF_FEEDINFOVIEW: CGFloat = 0.45
    
    // Ratio of profile pic to width of feed view
    static let PROFILE_PIC_SIZE: CGFloat = 0.15
    // Left margin of profile pic
    static let MARGIN: CGFloat = 0.05
    
    init(frame: CGRect, controller: UIViewController,
         title: String, description: String, name: String? = nil,
         username: String, hasThumbnail: Bool) {
        super.init(frame: frame)
        
        self.setupFeedInfoView(title: title, description: description,
                               name: name, username: username)
        self.setupThumbnailView()
        self.setupProfilePic()
        
        self.topRounded(radius: 25.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupFeedInfoView(title: String, description: String,
                           name: String? = nil, username: String) {
        let width = self.frame.width
        let height = self.frame.height * FeedView.HEIGHT_OF_FEEDINFOVIEW
        let x: CGFloat = 0
        let y = self.frame.height - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        feedInfoView = FeedInfoView(frame: frame, title: title,
                                    description: description, name: name,
                                    username: username)
        
        self.addSubview(feedInfoView!)
    }
    
    func setupThumbnailView() {
        let width = self.frame.width
        let height = self.frame.height - feedInfoView!.frame.height
        let y: CGFloat = 0
        let x: CGFloat = 0
        let frame = CGRect(x: x, y: y, width: width, height: height)
        thumbnailView = UIImageView(frame: frame)
        thumbnailView?.contentMode = .scaleAspectFill
        thumbnailView?.clipsToBounds = true
        
        self.addSubview(thumbnailView!)
    }
    
    func setupProfilePic() {
        let width = self.frame.width * FeedView.PROFILE_PIC_SIZE
        let height = width
        let margin = self.frame.width * FeedView.MARGIN
        let x = margin
        let y = feedInfoView!.frame.origin.y - height/2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        profilePicView = UIImageView()
        let container = profilePicView!.roundedImageWithShadow(frame: frame)
        self.addSubview(container)
    }
    
    func setThumbnailImage(image: UIImage) {
        self.thumbnailView?.image = image
    }
    
    func setProfileImage(image: UIImage) {
        self.profilePicView?.image = image
    }
    
}
