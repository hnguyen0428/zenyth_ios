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
    var commentCreateView: CommentCreateView?
    var defaultFrame: CGRect?
    
    static let COMMENT_CREATE_VIEW_HEIGHT: CGFloat = 0.07
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    func setupCommentCreateView() {
        let width = view.frame.width
        let height = view.frame.height * ExpandedFeedController.COMMENT_CREATE_VIEW_HEIGHT
        let x = CGFloat(0)
        let y = toolbar!.frame.origin.y - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        self.defaultFrame = frame
        commentCreateView = CommentCreateView(frame: frame)
        
        commentCreateView?.postButton.addTarget(self, action: #selector(createComment),
                                                for: .touchUpInside)
        
        view.addSubview(commentCreateView!)
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
                
                self.setupCommentCreateView()
                self.hideKeyboardWhenTappedAround()
                
                let commentButton = self.expandedFeedView.feedInfoView.actionBar?.commentButton
                commentButton?.addTarget(self, action: #selector(self.showKeyboard), for: .touchUpInside)
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
    
    func createComment(_ button: UIButton) {
        if let text = commentCreateView?.textfield.text {
            CommentManager().createComment(onPinpostId: pinpostId,
                                           text: text,
                                           onSuccess:
                { comment in
                    self.expandedFeedView.addComment(comment: comment)
                    self.commentCreateView?.textfield.resignFirstResponder()
                    self.commentCreateView?.textfield.text = ""
            })
        }
    }
    
    override func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        expandedFeedView.addGestureRecognizer(tap)
    }
    
    func showKeyboard() {
        commentCreateView?.textfield.becomeFirstResponder()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let newY = frame.origin.y - defaultFrame!.height
        let newFrame = CGRect(x: defaultFrame!.origin.x, y: newY,
                              width: defaultFrame!.width, height: defaultFrame!.height)
        commentCreateView!.frame = newFrame
    }
    
    func keyboardWillHide(notification: NSNotification) {
        commentCreateView!.frame = defaultFrame!
    }
}
