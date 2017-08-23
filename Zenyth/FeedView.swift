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
        
        if hasThumbnail {
            self.setupThumbnailView()
            _ = self.setupProfilePic()
            self.topRounded(radius: 25.0)
        }
        else {
            let imageContainer = self.setupProfilePic()
            let extraHeight = profilePicView!.frame.height/2
            
            let newHeight = feedInfoView!.frame.height + extraHeight
            let heightLost = self.frame.height - newHeight
            let newY = self.frame.origin.y + heightLost
            
            self.frame = CGRect(x: self.frame.origin.x, y: newY,
                                width: self.frame.width, height: newHeight)
            feedInfoView!.frame.origin = CGPoint(x: 0, y: extraHeight)
            feedInfoView!.topRounded(radius: 25.0)
            
            let profileFrame = profilePicView!.frame
            let newProfileFrame = CGRect(x: imageContainer.frame.origin.x, y: 0,
                                         width: profileFrame.width, height: profileFrame.height)
            imageContainer.frame = newProfileFrame
        }
        
        
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
    
    func setupProfilePic() -> UIView {
        let width = self.frame.width * FeedView.PROFILE_PIC_SIZE
        let height = width
        let margin = self.frame.width * FeedView.MARGIN
        let x = margin
        let y = feedInfoView!.frame.origin.y - height/2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        profilePicView = UIImageView()
        let container = profilePicView!.roundedImageWithShadow(frame: frame)
        self.addSubview(container)
        return container
    }
    
    func setThumbnailImage(image: UIImage) {
        self.thumbnailView?.image = image
    }
    
    func setProfileImage(image: UIImage) {
        self.profilePicView?.image = image
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled
                && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
}
