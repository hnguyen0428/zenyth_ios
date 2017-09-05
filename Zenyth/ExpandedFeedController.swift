//
//  ExpandedFeedController.swift
//  Zenyth
//
//  Created by Hoang on 8/30/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class ExpandedFeedController: HomeController, ImageViewControllerDelegate,
                            ImagesScrollerDelegate {
    
    weak var expandedFeedView: ExpandedFeedView?
    weak var commentCreateView: CommentCreateView?
    var pinpostId: UInt32!
    var pinpost: Pinpost?
    var defaultFrame: CGRect?
    
    var shouldShowKeyboard = false
    
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
    
    /**
     Action for the button at the top to pop back to the previous page
     */
    func popBack(_ pg: UIPanGestureRecognizer) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionFromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    /**
     Setting up the comment field at the bottom used to create a comment
     */
    func setupCommentCreateView() {
        let width = view.frame.width
        let height = view.frame.height * ExpandedFeedController.COMMENT_CREATE_VIEW_HEIGHT
        let x = CGFloat(0)
        let y = toolbar!.frame.origin.y - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        self.defaultFrame = frame
        let commentCreateView = CommentCreateView(frame: frame)
        self.commentCreateView = commentCreateView
        
        commentCreateView.postButton!.addTarget(self, action: #selector(createComment),
                                                for: .touchUpInside)
        
        view.addSubview(commentCreateView)
        
        if shouldShowKeyboard {
            commentCreateView.textfield?.becomeFirstResponder()
        }
    }
    
    /**
     Network request for getting pinpost information
     */
    func readPinpost(handler: @escaping (Pinpost) -> Void) {
        PinpostManager().readPinpostInfo(withPinpostId: self.pinpostId,
                                         onSuccess:
            { pinpost in
                handler(pinpost)
        })
    }
    
    /**
     Render the whole expanded feed view
     */
    func renderPinpostView() {
        self.readPinpost(handler:
            { pinpost in
                self.pinpost = pinpost
                let height = self.view.frame.height - self.toolbar!.frame.height
                let frame = CGRect(x: 0, y: 0,
                                   width: self.view.frame.width, height: height)
                let expandedFeedView = ExpandedFeedView(controller: self,
                                                        frame: frame,
                                                        pinpost: pinpost)
                expandedFeedView.imagesScroller.customDelegate = self
                self.expandedFeedView = expandedFeedView
                self.view.addSubview(expandedFeedView)
                
                self.setupCommentCreateView()
                self.hideKeyboardWhenTappedAround()
                
                let commentButton = expandedFeedView.feedInfoView.actionBar?.commentButton
                commentButton?.addTarget(self, action: #selector(self.showKeyboard), for: .touchUpInside)
        })
    }
    
    /**
     Network request for creating a comment
     */
    func createComment(_ button: UIButton) {
        if let text = commentCreateView?.textfield?.text {
            CommentManager().createComment(onPinpostId: pinpostId,
                                           text: text,
                                           onSuccess:
                { comment in
                    self.expandedFeedView!.addComment(comment: comment)
                    self.commentCreateView?.textfield?.resignFirstResponder()
                    self.commentCreateView?.textfield?.text = ""
            })
        }
    }
    
    /**
     Hide the keyboard when tapped outside
     */
    override func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        expandedFeedView!.addGestureRecognizer(tap)
    }
    
    /**
     Show the keyboard
     */
    func showKeyboard() {
        commentCreateView?.textfield?.becomeFirstResponder()
    }
    
    /**
     When keyboard is shown, push up the comment field
     */
    func keyboardWillShow(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let newY = frame.origin.y - defaultFrame!.height
        let newFrame = CGRect(x: defaultFrame!.origin.x, y: newY,
                              width: defaultFrame!.width, height: defaultFrame!.height)
        commentCreateView!.frame = newFrame
        expandedFeedView!.contentSize.height += frame.height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        commentCreateView!.frame = defaultFrame!
        expandedFeedView!.contentSize.height -= frame.height
    }
    
    /**
     Execute these actions when the view is about to appear
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func didLongSwipeVertically(sender: ImageViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTapped(on image: Image, sender: ImagesScroller) {
        let imageVC = ImageViewController()
        imageVC.delegate = self
        imageVC.image = image
        
        self.present(imageVC, animated: true, completion: nil)
    }
    
    deinit {
        print("Deinitializing")
    }
}
