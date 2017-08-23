//
//  FeedController.swift
//  Zenyth
//
//  Created by Hoang on 7/20/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import GoogleMaps

class FeedController: HomeController, UIScrollViewDelegate {
    
    var mapView: MapView?
    var feedScrollView: FeedScrollView?
    
    // Save the next page and prev page of pagination
    var paginateObject: Paginate?
    var pageNum = 0
    
    static let paginate: UInt32 = 5

    // Y coordinate of feed in percent of view height
    static let Y_COORD_FEED: CGFloat = 0.35
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)
        feedScrollView!.panGestureRecognizer.addTarget(self, action: #selector(snapToPin))
    }
    
    override func setupViews() {
        super.setupViews()
        toolbar?.setHomeSelected()
        
        self.loadMap()
        self.setupScrollView()
        self.setupFeedView()
    }
    
    func loadMap() {
        mapView = MapView(frame: view.frame, controller: self)
        view.insertSubview(mapView!, at: 0)
        
        let recenterButtonSize = mapView!.recenterButton!.frame.size
        let recenterButtonX = mapView!.recenterButton!.frame.origin.x
        let recenterButtonY = view.frame.height * 0.1
        let recenterButtonNewOrigin = CGPoint(x: recenterButtonX,
                                              y: recenterButtonY)
        mapView!.recenterButton!.frame = CGRect(origin: recenterButtonNewOrigin,
                                                size: recenterButtonSize)
        
        let searchButtonSize = mapView!.searchButton!.frame.size
        let searchButtonX = mapView!.searchButton!.frame.origin.x
        let searchButtonY = recenterButtonY + recenterButtonSize.height +
            view.frame.height * 0.02
        let searchButtonNewOrigin = CGPoint(x: searchButtonX,
                                            y: searchButtonY)
        mapView!.searchButton!.frame = CGRect(origin: searchButtonNewOrigin,
                                              size: searchButtonSize)
    }
    
    func setupScrollView() {
        let feedWidth = self.view.frame.width
        let x = self.view.frame.origin.x
        let y = self.view.frame.height * FeedController.Y_COORD_FEED
        let feedHeight = self.toolbar!.frame.origin.y - y
        let frame = CGRect(x: x, y: y, width: feedWidth, height: feedHeight)
        feedScrollView = FeedScrollView(frame: frame, controller: self)
        feedScrollView!.delegate = self
        view.insertSubview(feedScrollView!, belowSubview: toolbar!)
    }
    
    func setupFeedView() {
        self.fetchFeed(handler:
            { pinposts in
                self.renderFeedScrollView(pinposts: pinposts)
        })
    }
    
    func renderFeedScrollView(pinposts: [Pinpost]) {
        let feedWidth = self.view.frame.width
        let y = self.feedScrollView!.frame.origin.y
        let feedHeight = self.toolbar!.frame.origin.y - y
        
        for i in 0..<pinposts.count {
            
            let x = CGFloat(i + self.pageNum * Int(FeedController.paginate)) * self.feedScrollView!.frame.width
            self.feedScrollView!.contentSize.width += self.feedScrollView!.frame.width
            let frame = CGRect(x: x, y: 0, width: feedWidth, height: feedHeight)
            
            let pinpost = pinposts[i]
            let creator = pinpost.creator!
            var name: String? = nil
            if let firstName = creator.firstName,
                let lastName = creator.lastName {
                name = "\(firstName) \(lastName)"
            } else if let firstName = creator.firstName {
                name = firstName
            } else if let lastName = creator.lastName {
                name = lastName
            }
            
            var hasThumbnail: Bool = false
            if pinpost.images.count > 0 {
                hasThumbnail = true
            }
            
            let feedView = FeedView(self, frame: frame,
                                    title: pinpost.title,
                                    description: pinpost.pinpostDescription,
                                    name: name,
                                    username: creator.username,
                                    hasThumbnail: hasThumbnail)
            self.feedScrollView?.addSubview(feedView)
            self.feedScrollView?.pinposts.append(pinpost)
            
            if hasThumbnail {
                self.renderPinImage(pinpost: pinpost, handler:
                    { image in
                        feedView.setThumbnailImage(image: image)
                })
            }
            
            self.renderProfileImage(creator: creator, handler:
                { image in
                    feedView.setProfileImage(image: image)
            })
        }
    }
    
    func loadNextPage() {
        let scrollView = feedScrollView!
        if scrollView.currentPinpostIndex == scrollView.pinposts.count - 1 {
            self.fetchNextPage(handler:
                { pinposts in
                    self.renderFeedScrollView(pinposts: pinposts)
            })
        }
    }
    
    func snapToPin(_ sender: UIPanGestureRecognizer) {
        let scrollView = feedScrollView!
        
        // If the pinpost currently on is the last pinpost in the scrollview
        // load the next page
        
        let velocity = sender.velocity(in: scrollView)
        var snapRight: Bool = false
        var snapLeft: Bool = false
        if velocity.x < -1200 {
            snapRight = true
        }
        if velocity.x > 1200 {
            snapLeft = true
        }
        
        if sender.state == .ended {
            let contentOffset = scrollView.contentOffset
            let x = contentOffset.x
            let y = contentOffset.y
            
            let feedWidth = scrollView.frame.width
            let index = floor(x/feedWidth)
            let minX = index * feedWidth
            let maxX = (index + 1) * feedWidth
            
            // Duration of animation
            var duration: Double = 0.2
            
            if x > scrollView.contentSize.width - feedWidth { // snap back to the left
                UIView.animate(withDuration: duration, animations:
                    { animation in
                        scrollView.contentOffset = CGPoint(x: minX, y: y)
                })
                return
            }
            if x < 0 { // snap back to the right
                UIView.animate(withDuration: duration, animations:
                    { animation in
                        scrollView.contentOffset = CGPoint(x: maxX, y: y)
                })
                return
            }
            
            let swipingRight = sender.translation(in: scrollView).x > 0
            
            let enoughOfRightShown = (maxX - x)/scrollView.frame.width < 0.70
            let enoughOfLeftShown = (maxX - x)/scrollView.frame.width > 0.30
            
            if snapRight { // snap right if swiping left fast enough
                duration = 0.15
                scrollView.currentPinpostIndex += 1
                UIView.animate(withDuration: duration, animations:
                    { animation in
                        scrollView.contentOffset = CGPoint(x: maxX, y: y)
                }, completion:
                    { action in
                        self.loadNextPage()
                })
                return
            }
            if snapLeft { // snap left if swiping right fast enough
                duration = 0.15
                scrollView.currentPinpostIndex -= 1
                UIView.animate(withDuration: duration, animations:
                    { animation in
                        scrollView.contentOffset = CGPoint(x: minX, y: y)
                })
                return
            }
            
            // snap right if enough of right is shown, else snap back left
            if !swipingRight {
                if enoughOfRightShown {
                    scrollView.currentPinpostIndex += 1
                    UIView.animate(withDuration: duration, animations:
                        { animation in
                            scrollView.contentOffset = CGPoint(x: maxX, y: y)
                    }, completion:
                        { action in
                            self.loadNextPage()
                    })
                } else {
                    UIView.animate(withDuration: duration, animations:
                        { animation in
                            scrollView.contentOffset = CGPoint(x: minX, y: y)
                    })
                }
                return
            }
            else {
                // snap left if enough of left is shown, else snap back right
                if enoughOfLeftShown {
                    scrollView.currentPinpostIndex -= 1
                    UIView.animate(withDuration: duration, animations:
                        { animation in
                            scrollView.contentOffset = CGPoint(x: minX, y: y)
                    })
                } else {
                    UIView.animate(withDuration: duration, animations:
                        { animation in
                            scrollView.contentOffset = CGPoint(x: maxX, y: y)
                    })
                }
            }
        }
    }
    
    /** Used to prevent deceleration animation
     */
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
    }
    
    func fetchNextPage(handler: PinpostsCallback? = nil) {
        if let url = paginateObject?.nextPageUrl {
            PinpostManager().fetchPinposts(fromURL: url,
                                           onSuccess:
                { (pinposts, paginate) in
                    self.paginateObject = paginate
                    self.pageNum += 1
                    handler?(pinposts)
            })
        }
        else {
            handler?([Pinpost]())
        }
    }
    
    func fetchPrevPage(handler: PinpostsCallback? = nil) {
        if let url = paginateObject?.prevPageUrl {
            PinpostManager().fetchPinposts(fromURL: url,
                                           onSuccess:
                { (pinposts, paginate) in
                    self.paginateObject = paginate
                    self.pageNum -= 1
                    handler?(pinposts)
            })
        }
        else {
            handler?([Pinpost]())
        }
    }
    
    
    func fetchFeed(handler: PinpostsCallback? = nil) {
        PinpostManager().fetchPinpostsFeed(paginate: FeedController.paginate,
                                           scope: "public",
                                           onSuccess:
            { (pinposts, paginate) in
                self.paginateObject = paginate
                handler?(pinposts)
        })
    }
    
    func renderProfileImage(creator: User, handler: @escaping (UIImage) -> Void) {
        if let profilePic = creator.profilePicture {
            let url = profilePic.getURL(size: "medium")
            ImageManager().getImageData(withUrl: url,
                                        onSuccess:
                { data in
                    if let image = UIImage(data: data) {
                        handler(image)
                    }
                    else {
                        handler(#imageLiteral(resourceName: "default_profile"))
                    }
            })
        }
        else {
            handler(#imageLiteral(resourceName: "default_profile"))
        }
        
    }
    
    func renderPinImage(pinpost: Pinpost, handler: @escaping (UIImage) -> Void) {
        let pinThumbnail = pinpost.images[0]
        let url = pinThumbnail.getURL()
        ImageManager().getImageData(withUrl: url,
                                    onSuccess:
            { data in
                if let image = UIImage(data: data){
                    handler(image)
                }
        })
    }
    
    func expandPost(_ sender: UITapGestureRecognizer) {
        print("Tapped")
    }
}
