//
//  ExpandedFeedView.swift
//  Zenyth
//
//  Created by Hoang on 8/30/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

/**
 The whole expanded feed view
 */
class ExpandedFeedView: UIScrollView {
    
    weak var imagesScroller: ImagesScroller!
    weak var commentsView: CommentsView!
    weak var feedInfoView: FeedInfoView!
    weak var profilePicView: UIImageView!
    weak var returnButton: UIButton!
    
    var pinpost: Pinpost!
    
    var maxHeight: CGFloat = 0
    weak var controller: UIViewController?
    
    // Constants for UI sizing
    static let CELL_HEIGHT: CGFloat = 0.08
    static let FEED_INFO_HEIGHT: CGFloat = 0.40
    static let WIDTH_OF_PROFILE_PIC: CGFloat = 0.18
    static let PIC_LEFT_INSET: CGFloat = 0.03
    static let BUTTON_TOP_INSET: CGFloat = 0.03
    
    static let WIDTH_OF_RETURN_BUTTON: CGFloat = 0.11
    
    init(controller: UIViewController, frame: CGRect, pinpost: Pinpost) {
        self.controller = controller
        super.init(frame: frame)
        self.pinpost = pinpost
        
        setupImagesScroller(pinpost: pinpost)
        setupFeedInfoView(pinpost: pinpost)
        
        if let comments = pinpost.comments {
            setupCommentsView(comments: comments)
        }
        
        setupProfilePicView(user: pinpost.creator!)
        setupReturnButton()
        
        maxHeight += imagesScroller.frame.height
        maxHeight += feedInfoView.frame.height
        maxHeight += commentsView.frame.height
        
        self.contentSize.height = maxHeight
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .white
        
        returnButton.addTarget(controller,
                               action: #selector(ExpandedFeedController.popBack),
                               for: .touchUpInside)
        
        let tg = UITapGestureRecognizer(target: self, action: #selector(gotoProfile))
        profilePicView.isUserInteractionEnabled = true
        profilePicView.addGestureRecognizer(tg)
    }
    
    func setupImagesScroller(pinpost: Pinpost) {
        let width = self.frame.width
        let height = width
        let x = CGFloat(0)
        let y = CGFloat(0)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let imagesScroller = ImagesScroller(frame: frame, images: pinpost.images)
        self.imagesScroller = imagesScroller
        self.addSubview(imagesScroller)
    }
    
    func setupProfilePicView(user: User) {
        let width = self.frame.width * ExpandedFeedView.WIDTH_OF_PROFILE_PIC
        let height = width
        let x = self.frame.width * ExpandedFeedView.PIC_LEFT_INSET
        let y = feedInfoView.frame.origin.y - height/2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let profilePicView = UIImageView(frame: frame)
        self.profilePicView = profilePicView
        
        if let image = user.profilePicture {
            let url = URL(string: image.getURL(size: .small))
            profilePicView.sd_setImage(with: url,
                                       placeholderImage: #imageLiteral(resourceName: "default_profile"))
        }
        else {
            profilePicView.image = #imageLiteral(resourceName: "default_profile")
        }
        
        let container = profilePicView.roundedImageWithShadow(frame: frame)
        self.addSubview(container)
    }
    
    func setupFeedInfoView(pinpost: Pinpost) {
        let width = self.frame.width
        let height = self.frame.height * ExpandedFeedView.FEED_INFO_HEIGHT
        let x = CGFloat(0)
        let y = imagesScroller.frame.maxY
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let feedInfoView = FeedInfoView(controller!, frame: frame, pinpost: pinpost)
        self.feedInfoView = feedInfoView
        feedInfoView.frame = CGRect(x: feedInfoView.frame.origin.x,
                                     y: feedInfoView.frame.origin.y,
                                     width: feedInfoView.frame.width,
                                     height: feedInfoView.maxHeight)
        
        self.addSubview(feedInfoView)
    }
    
    func setupCommentsView(comments: [Comment]) {
        let width = self.frame.width
        let height = self.frame.height * ExpandedFeedView.CELL_HEIGHT
        let x = CGFloat(0)
        let y = feedInfoView.frame.maxY
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let commentsView = CommentsView(commentFrame: frame, comments: comments)
        self.commentsView = commentsView
        self.addSubview(commentsView)
    }
    
    func setupReturnButton() {
        let width = self.frame.width * ExpandedFeedView.WIDTH_OF_RETURN_BUTTON
        let height = width
        let x = self.center.x - width/2
        let y = self.frame.height * ExpandedFeedView.BUTTON_TOP_INSET
        
        let frame = CGRect(x: x, y: y, width: width, height: height)

        let returnButton = UIButton(frame: frame)
        self.returnButton = returnButton
        returnButton.setImage(#imageLiteral(resourceName: "down_icon"), for: .normal)
        
        self.addSubview(returnButton)
    }
    
    func addComment(comment: Comment) {
        commentsView.append(comment: comment)
        self.contentSize.height += self.frame.height * ExpandedFeedView.CELL_HEIGHT
    }
    
    func gotoProfile(_ tg: UITapGestureRecognizer) {
        let controller = ProfileController()
        controller.userId = pinpost.creator!.id
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromBottom
        
        if let nc = self.window?.rootViewController as? UINavigationController {
            nc.view.layer.add(transition, forKey: nil)
            nc.pushViewController(controller, animated: false)
        }
    }
    
    deinit {
        debugPrint("Deinitializing \(self)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
