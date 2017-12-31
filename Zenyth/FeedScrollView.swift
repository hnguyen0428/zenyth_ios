//
//  FeedScrollView.swift
//  Zenyth
//
//  Created by Hoang on 8/23/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import Foundation
import UIKit

class FeedScrollView: UIScrollView {
    
    var feedViews: [FeedView] = [FeedView]()
    var numPinposts = 0
    
    weak var customDelegate: FeedScrollViewDelegate?
    weak var controller: UIViewController?
    
    static let VELOCITY_TO_SWITCH: CGFloat = 500
    static let SWITCH_DURATION: Double = 0.2
    
    init(frame: CGRect, controller: UIViewController) {
        self.controller = controller
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.contentSize.width = 0
        self.showsHorizontalScrollIndicator = false
        
        self.panGestureRecognizer.addTarget(self, action: #selector(snapToPin))
    }
    
    func addNewPost(pinpost: Pinpost) {
        let x = CGFloat(numPinposts) * self.frame.width
        let width = self.frame.width
        let height = self.frame.height
        let frame = CGRect(x: x, y: 0, width: width, height: height)
        let feedView = FeedView(controller!, frame: frame, pinpost: pinpost)
        self.feedViews.append(feedView)
        self.addSubview(feedView)
        self.contentSize.width += width
        numPinposts += 1
        
        // Adding target for comment button
        let commentButton = feedView.feedInfoView?.actionBar?.commentButton
        commentButton?.addTarget(self, action: #selector(transitionToExpandedPinpost),
                                 for: .touchUpInside)
    }
    
    /**
     Handling pin snapping while scrolling
     */
    func snapToPin(_ sender: UIPanGestureRecognizer) {
        // If the pinpost currently on is the last pinpost in the scrollview
        // load the next page
        
        let velocity = sender.velocity(in: self)
        var snapRight: Bool = false
        var snapLeft: Bool = false
        if velocity.x < -FeedScrollView.VELOCITY_TO_SWITCH {
            snapRight = true
        }
        if velocity.x > FeedScrollView.VELOCITY_TO_SWITCH {
            snapLeft = true
        }
        
        if sender.state == .ended {
            let x = self.contentOffset.x
            let y = self.contentOffset.y
            let index = CGFloat(calculateCurrentIndex())
            let feedWidth = self.frame.width
            let minX = index * feedWidth
            let maxX = (index + 1) * feedWidth
            
            // Duration of animation
            let duration: Double = FeedScrollView.SWITCH_DURATION
            
            if x > self.contentSize.width - feedWidth { // snap back to the left
                UIView.animate(withDuration: duration, animations:
                    { _ in
                        self.contentOffset = CGPoint(x: minX, y: y)
                }, completion: snappedBack)
                return
            }
            if x < 0 { // snap back to the right
                UIView.animate(withDuration: duration, animations:
                    { _ in
                        self.contentOffset = CGPoint(x: maxX, y: y)
                }, completion: snappedBack)
                return
            }
            
            let swipingRight = sender.translation(in: self).x > 0
            
            let enoughOfRightShown = (maxX - x)/self.frame.width < 0.70
            let enoughOfLeftShown = (maxX - x)/self.frame.width > 0.30
            
            if snapRight { // snap right if swiping left fast enough
                UIView.animate(withDuration: duration, animations:
                    { _ in
                        self.contentOffset = CGPoint(x: maxX, y: y)
                        //self.feedDragger!.frame.origin.y = newDraggerY
                }, completion: snappedRight)
                return
            }
            if snapLeft { // snap left if swiping right fast enough
                UIView.animate(withDuration: duration, animations:
                    { _ in
                        self.contentOffset = CGPoint(x: minX, y: y)
                        //self.feedDragger!.frame.origin.y = newDraggerY
                }, completion: snappedLeft)
                return
            }
            
            // snap right if enough of right is shown, else snap back left
            if !swipingRight {
                if enoughOfRightShown {
                    UIView.animate(withDuration: duration, animations:
                        { _ in
                            self.contentOffset = CGPoint(x: maxX, y: y)
                    }, completion: snappedRight)
                } else {
                    UIView.animate(withDuration: duration, animations:
                        { _ in
                            self.contentOffset = CGPoint(x: minX, y: y)
                    }, completion: snappedBack)
                }
                return
            }
            else {
                // snap left if enough of left is shown, else snap back right
                if enoughOfLeftShown {
                    UIView.animate(withDuration: duration, animations:
                        { _ in
                            self.contentOffset = CGPoint(x: minX, y: y)
                    }, completion: snappedLeft)
                } else {
                    UIView.animate(withDuration: duration, animations:
                        { _ in
                            self.contentOffset = CGPoint(x: maxX, y: y)
                    }, completion: snappedBack)
                }
            }
        }
    }
    
    func calculateCurrentIndex() -> Int {
        let contentOffset = self.contentOffset
        let x = contentOffset.x
        
        let feedWidth = self.frame.width
        let index = floor(x/feedWidth)
        return Int(index)
    }
    
    func getCurrentFeedView() -> FeedView {
        return feedViews[calculateCurrentIndex()]
    }
    
    func snappedBack(_: Bool) {
        let index = calculateCurrentIndex()
        let feedView = feedViews[index]
        customDelegate?.didSnapBack?(toFeedView: feedView,
                                     feedScrollView: self,
                                     index: index)
    }
    
    func snappedLeft(_: Bool) {
        self.snappedToNewPin()
    }
    
    func snappedRight(_: Bool) {
        self.snappedToNewPin()
    }
    
    func snappedToNewPin() {
        let index = calculateCurrentIndex()
        let feedView = feedViews[index]
        customDelegate?.didSnap(toNewFeedView: feedView,
                                feedScrollView: self,
                                index: index)
    }
    
    func transitionToExpandedPinpost(_ button: UIButton) {
        let feedView = getCurrentFeedView()
        let controller = ExpandedFeedController()
        controller.pinpostId = feedView.pinpost.id
        controller.shouldShowKeyboard = true
        
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

@objc protocol FeedScrollViewDelegate: class {
    func didSnap(toNewFeedView feedView: FeedView, feedScrollView: FeedScrollView, index: Int)
    @objc optional func didSnapBack(toFeedView feedView: FeedView, feedScrollView: FeedScrollView, index: Int)
}
