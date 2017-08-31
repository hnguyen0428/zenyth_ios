//
//  ExpandedFeedController.swift
//  Zenyth
//
//  Created by Hoang on 8/30/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class ExpandedFeedController: HomeController {
    
    var expandedFeedView: ExpandedFeedView!
    var pinpostId: UInt32!
    var pinpost: Pinpost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.backgroundColor = .white
        
        renderPinpostView()
    }
    
    func popBack(_ pg: UIPanGestureRecognizer) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionFromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    func readPinpost(handler: @escaping (Pinpost) -> Void) {
        PinpostManager().readPinpostInfo(withPinpostId: self.pinpostId,
                                         onSuccess:
            { pinpost in
                handler(pinpost)
        })
    }
    
    func renderPinpostView() {
        self.readPinpost(handler:
            { pinpost in
                self.pinpost = pinpost
                let height = self.view.frame.height - self.toolbar!.frame.height
                let frame = CGRect(x: 0, y: 0,
                                   width: self.view.frame.width, height: height)
                self.expandedFeedView = ExpandedFeedView(controller: self,
                                                         frame: frame,
                                                         pinpost: pinpost)
                
                self.view.addSubview(self.expandedFeedView)
                
                self.renderProfileImage(user: pinpost.creator!)
                self.renderPinpostImages(images: pinpost.images)
                self.renderCommentProfileImages()
        })
    }
    
    func renderProfileImage(user: User) {
        if let image = user.profilePicture {
            expandedFeedView.profilePicView.imageFromUrl(withUrl: image.getURL(size: "small"))
        }
    }
    
    func renderPinpostImages(images: [Image]) {
        let imagesScroller = expandedFeedView.imagesScroller
        for image in images {
            ImageManager().getImageData(withUrl: image.getURL(size: "large"),
                                        onSuccess:
                { data in
                    if let uiimage = UIImage(data: data) {
                        imagesScroller?.append(image: uiimage)
                    }
            })
        }
    }
    
    func renderCommentProfileImages() {
        let commentsView = expandedFeedView.commentsView
        let commentCells = commentsView!.commentCells
        for commentCell in commentCells {
            commentCell.renderProfilePic()
        }
    }
}
