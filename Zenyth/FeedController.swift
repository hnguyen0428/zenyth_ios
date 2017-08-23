//
//  FeedController.swift
//  Zenyth
//
//  Created by Hoang on 7/20/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import GoogleMaps

class FeedController: HomeController {
    
    var mapView: MapView?
    var feedView: FeedView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)
    }
    
    override func setupViews() {
        super.setupViews()
        toolbar?.setHomeSelected()
        
        self.loadMap()
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
    
    func setupFeedView() {
        self.fetchFeed(handler:
            { pinposts in
                var pinposts = pinposts
                let pinpost = pinposts.first
                
                
                let feedWidth = self.view.frame.width
                let x = self.view.frame.origin.x
                let y = self.view.frame.height * 0.35
                let feedHeight = self.toolbar!.frame.origin.y - y
                let frame = CGRect(x: x, y: y, width: feedWidth, height: feedHeight)
                
                let creator = pinpost!.creator!
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
                if pinpost!.images.count > 0 {
                    hasThumbnail = true
                }
                
                self.feedView = FeedView(frame: frame, controller: self,
                                         title: pinpost!.title,
                                         description: pinpost!.pinpostDescription,
                                         name: name,
                                         username: creator.username,
                                         hasThumbnail: hasThumbnail)
                self.view.insertSubview(self.feedView!, belowSubview: self.toolbar!)
                
                if hasThumbnail {
                    self.renderPinImage(pinpost: pinpost!, handler:
                        { image in
                            self.feedView?.setThumbnailImage(image: image)
                    })
                }
                
                self.renderProfileImage(creator: creator, handler:
                    { image in
                        self.feedView?.setProfileImage(image: image)
                })
        })
    }
    
    func fetchFeed(handler: PinpostsCallback? = nil) {
        PinpostManager().fetchPinpostsFeed(paginate: 20, scope: "public",
                                           onSuccess:
            { pinposts in
                handler?(pinposts)
        })
    }
    
    func renderFeed() {
        
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
}
