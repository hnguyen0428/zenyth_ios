//
//  FeedView.swift
//  Zenyth
//
//  Created by Hoang on 8/22/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class FeedView: UIView {
    
    var feedInfoView: FeedInfoView?
    var profilePicView: UIImageView?
    var thumbnailView: UIImageView?
    var hasThumbnail: Bool = false
    var tgExpandPost: UITapGestureRecognizer!
    var tgProfile: UITapGestureRecognizer!
    var pinpost: Pinpost!
    var controller: UIViewController?
    
    var topY: CGFloat = 0
    
    // Height in percentage
    static let HEIGHT_OF_FEEDINFOVIEW: CGFloat = 0.45
    
    // Ratio of profile pic to width of feed view
    static let PROFILE_PIC_SIZE: CGFloat = 0.15
    // Left margin of profile pic
    static let MARGIN: CGFloat = 0.05
    
    static let ROUNDED_TOP_RADIUS: CGFloat = 40.0
    
    init(_ controller: UIViewController, frame: CGRect, pinpost: Pinpost) {
        self.controller = controller
        tgProfile = UITapGestureRecognizer(target: controller, action: #selector(FeedController.showProfile))
        self.pinpost = pinpost
        super.init(frame: frame)
        
        let hasThumbnail = pinpost.images.count > 0
        self.hasThumbnail = hasThumbnail
        self.setupFeedInfoView(pinpost: pinpost)
        
        if hasThumbnail {
            self.setupThumbnailView(image: pinpost.images.first!)
            _ = self.setupProfilePic(user: pinpost.creator!)
            self.topRounded(radius: FeedView.ROUNDED_TOP_RADIUS)
            self.topY = frame.origin.y
        }
        else {
            let imageContainer = self.setupProfilePic(user: pinpost.creator!)
            let extraHeight = profilePicView!.frame.height/2
            
            let newHeight = feedInfoView!.frame.height + extraHeight
            let heightLost = self.frame.height - newHeight
            let newY = self.frame.origin.y + heightLost
            self.topY = newY + extraHeight
            
            self.frame = CGRect(x: self.frame.origin.x, y: newY,
                                width: self.frame.width, height: newHeight)
            feedInfoView!.frame.origin = CGPoint(x: 0, y: extraHeight)
            feedInfoView!.topRounded(radius: FeedView.ROUNDED_TOP_RADIUS)
            
            let profileFrame = profilePicView!.frame
            let newProfileFrame = CGRect(x: imageContainer.frame.origin.x, y: 0,
                                         width: profileFrame.width, height: profileFrame.height)
            imageContainer.frame = newProfileFrame
        }
        
        tgExpandPost = UITapGestureRecognizer(target: self, action: #selector(self.expandPinpost))
        feedInfoView!.descriptionText!.addGestureRecognizer(tgExpandPost)
        profilePicView!.addGestureRecognizer(tgProfile)
        profilePicView!.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupFeedInfoView(pinpost: Pinpost) {
        let width = self.frame.width
        let height = self.frame.height * FeedView.HEIGHT_OF_FEEDINFOVIEW
        let x: CGFloat = 0
        let y = self.frame.height - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        feedInfoView = FeedInfoView(controller!, frame: frame, pinpost: pinpost)
        
        let shrunkenHeight = feedInfoView!.frame.height - feedInfoView!.maxHeight
        let newY = feedInfoView!.frame.origin.y + shrunkenHeight
        feedInfoView!.frame = CGRect(x: feedInfoView!.frame.origin.x, y: newY,
                                     width: feedInfoView!.frame.width,
                                     height: feedInfoView!.maxHeight)
        
        self.addSubview(feedInfoView!)
    }
    
    func setupThumbnailView(image: Image) {
        let width = self.frame.width
        let height = self.frame.height - feedInfoView!.frame.height
        let y: CGFloat = 0
        let x: CGFloat = 0
        let frame = CGRect(x: x, y: y, width: width, height: height)
        thumbnailView = UIImageView(frame: frame)
        thumbnailView?.contentMode = .scaleAspectFill
        thumbnailView?.clipsToBounds = true
        thumbnailView?.isUserInteractionEnabled = true
        thumbnailView?.imageFromUrl(withUrl: image.url)
        
        self.addSubview(thumbnailView!)
    }
    
    func setupProfilePic(user: User) -> UIView {
        let width = self.frame.width * FeedView.PROFILE_PIC_SIZE
        let height = width
        let margin = self.frame.width * FeedView.MARGIN
        let x = margin
        let y = feedInfoView!.frame.origin.y - height/2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        profilePicView = UIImageView()
        profilePicView?.image = #imageLiteral(resourceName: "default_profile")
        if let image = user.profilePicture {
            profilePicView?.imageFromUrl(withUrl: image.getURL(size: "small"))
        }
        
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
    
    func expandPinpost(_ tg: UITapGestureRecognizer) {
        let controller = ExpandedFeedController()
        controller.pinpostId = pinpost.id
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromBottom
        
        if let nc = self.window?.rootViewController as? UINavigationController {
            nc.view.layer.add(transition, forKey: nil)
            nc.pushViewController(controller, animated: false)
        }
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
