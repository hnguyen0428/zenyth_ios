//
//  FeedController.swift
//  Zenyth
//
//  Created by Hoang on 7/20/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import GoogleMaps

class FeedController: HomeController, UIScrollViewDelegate, GMSMapViewDelegate {
    
    weak var mapView: MapView?
    weak var feedScrollView: FeedScrollView?
    weak var feedDragger: UIButton?
    
    // Save the next page and prev page of pagination
    var paginateObject: Paginate?
    var pageNum = 0
    
    // For the feed to know where to start adding on to the previous pins on
    // the scroll view
    var startIndex = 0
    var loading: Bool = false
    
    var feedShown: Bool = false
    
    static let paginate: UInt32 = 10

    // Y coordinate of feed in percent of view height
    static let Y_COORD_FEED: CGFloat = 0.35
    static let WIDTH_OF_DRAGGER: CGFloat = 0.11
    static let HEIGHT_OF_FEED: CGFloat = 0.60
    
    // Percent of dragger shown
    static let DRAGGER_SHOWN: CGFloat = 0.70
    
    static let WIDTH_OF_PIN: CGFloat = 0.15
    static let MIN_ZOOM_TO_LOAD: Float = 10.0

    // Timer before loading the pins onto the map
    var timer: Timer? = nil
    
    var savedZoom: Float?
    var savedCoord: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)
        feedScrollView!.panGestureRecognizer.addTarget(self, action: #selector(snapToPin))
        feedDragger?.addTarget(self, action: #selector(toggleFeed), for: .touchUpInside)
    }
    
    override func setupViews() {
        super.setupViews()
        toolbar?.setHomeSelected()
        
        self.setupScrollView()
        self.setupFeedView()
    }
    
    /**
     Loading the map
     */
    func setupMap() {
        var mapView: MapView!
        if let zoom = self.savedZoom,
            let coord = self.savedCoord {
            mapView = MapView(frame: view.frame, controller: self, zoom: zoom, coord: coord)
        }
        else {
            mapView = MapView(frame: view.frame, controller: self, zoom: defaultZoom)
        }
        self.mapView = mapView
        view.insertSubview(mapView, at: 0)
        
        let recenterButtonSize = mapView.recenterButton!.frame.size
        let recenterButtonX = mapView.recenterButton!.frame.origin.x
        let recenterButtonY = view.frame.height * 0.1
        let recenterButtonNewOrigin = CGPoint(x: recenterButtonX,
                                              y: recenterButtonY)
        mapView.recenterButton!.frame = CGRect(origin: recenterButtonNewOrigin,
                                                size: recenterButtonSize)
        
        let searchButtonSize = mapView.searchButton!.frame.size
        let searchButtonX = mapView.searchButton!.frame.origin.x
        let searchButtonY = recenterButtonY + recenterButtonSize.height +
            view.frame.height * 0.02
        let searchButtonNewOrigin = CGPoint(x: searchButtonX,
                                            y: searchButtonY)
        mapView.searchButton!.frame = CGRect(origin: searchButtonNewOrigin,
                                              size: searchButtonSize)
        mapView.delegate = self
    }
    
    func setupScrollView() {
        let feedWidth = self.view.frame.width
        let x = self.view.frame.origin.x
        let y = toolbar!.frame.origin.y
        let feedHeight = self.view.frame.height * FeedController.HEIGHT_OF_FEED
        let frame = CGRect(x: x, y: y, width: feedWidth, height: feedHeight)
        let feedScrollView = FeedScrollView(frame: frame, controller: self)
        self.feedScrollView = feedScrollView
        feedScrollView.delegate = self
        view.insertSubview(feedScrollView, belowSubview: toolbar!)
        
        let draggerWidth = view.frame.width * FeedController.WIDTH_OF_DRAGGER
        let draggerHeight = draggerWidth
        let draggerX = feedScrollView.center.x - draggerWidth/2
        let draggerY = toolbar!.frame.origin.y - draggerHeight * FeedController.DRAGGER_SHOWN

        let draggerFrame = CGRect(x: draggerX, y: draggerY,
                                  width: draggerWidth, height: draggerHeight)
        let feedDragger = UIButton(frame: draggerFrame)
        self.feedDragger = feedDragger
        feedDragger.setImage(#imageLiteral(resourceName: "up_icon"), for: .normal)

        view.insertSubview(feedDragger, belowSubview: feedScrollView)
    }
    
    /**
     Rendering the feed at the beginning
     */
    func setupFeedView() {
        self.fetchFeed(handler:
            { pinposts in
                self.renderFeedScrollView(pinposts: pinposts)
        })
    }
    
    /**
     Add FeedView objects to the FeedScrollView
     */
    func renderFeedScrollView(pinposts: [Pinpost], handler: Handler? = nil) {
        // Set loading to true so that only one request to render the feed
        // can fire at a time
        
        let feedWidth = self.view.frame.width
        let feedHeight = self.view.frame.height * FeedController.HEIGHT_OF_FEED
        
        for i in 0..<pinposts.count {
            let x = CGFloat(i + startIndex) * self.feedScrollView!.frame.width
            self.feedScrollView!.contentSize.width += self.feedScrollView!.frame.width
            let frame = CGRect(x: x, y: 0, width: feedWidth, height: feedHeight)
            
            let pinpost = pinposts[i]
            
            let feedView = FeedView(self, frame: frame, pinpost: pinpost)
            self.feedScrollView?.addSubview(feedView)
            self.feedScrollView?.feedViews.append(feedView)
            
        }
        self.startIndex += pinposts.count
    }
    
    /**
     Render the next page of pinposts
     */
    func loadNextPage() {
        let scrollView = feedScrollView!
        if scrollView.currentPinpostIndex == scrollView.feedViews.count - 1 {
            self.fetchNextPage(handler:
                { pinposts in
                    self.renderFeedScrollView(pinposts: pinposts)
            })
        }
    }
    
    /**
     Handling pin snapping while scrolling
     */
    func snapToPin(_ sender: UIPanGestureRecognizer) {
        let scrollView = feedScrollView!
        
        // If the pinpost currently on is the last pinpost in the scrollview
        // load the next page
        
        let velocity = sender.velocity(in: scrollView)
        var snapRight: Bool = false
        var snapLeft: Bool = false
        if velocity.x < -FeedScrollView.VELOCITY_TO_SWITCH {
            snapRight = true
        }
        if velocity.x > FeedScrollView.VELOCITY_TO_SWITCH {
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
            let duration: Double = FeedScrollView.SWITCH_DURATION
            
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
                scrollView.currentPinpostIndex += 1
                let feedView = scrollView.feedViews[scrollView.currentPinpostIndex]
                let topY = feedView.topY + scrollView.frame.origin.y
                let newDraggerY = topY - feedDragger!.frame.height * FeedController.DRAGGER_SHOWN

                UIView.animate(withDuration: duration, animations:
                    { animation in
                        scrollView.contentOffset = CGPoint(x: maxX, y: y)
                        self.feedDragger!.frame.origin.y = newDraggerY
                }, completion:
                    { action in
                        self.loadNextPage()
                })
                return
            }
            if snapLeft { // snap left if swiping right fast enough
                scrollView.currentPinpostIndex -= 1
                let feedView = scrollView.feedViews[scrollView.currentPinpostIndex]
                let topY = feedView.topY + scrollView.frame.origin.y
                let newDraggerY = topY - feedDragger!.frame.height * FeedController.DRAGGER_SHOWN
                UIView.animate(withDuration: duration, animations:
                    { animation in
                        scrollView.contentOffset = CGPoint(x: minX, y: y)
                        self.feedDragger!.frame.origin.y = newDraggerY
                })
                return
            }
            
            // snap right if enough of right is shown, else snap back left
            if !swipingRight {
                if enoughOfRightShown {
                    scrollView.currentPinpostIndex += 1
                    let feedView = scrollView.feedViews[scrollView.currentPinpostIndex]
                    let topY = feedView.topY + scrollView.frame.origin.y
                    let newDraggerY = topY - feedDragger!.frame.height * FeedController.DRAGGER_SHOWN

                    UIView.animate(withDuration: duration, animations:
                        { animation in
                            scrollView.contentOffset = CGPoint(x: maxX, y: y)
                            self.feedDragger!.frame.origin.y = newDraggerY
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
                    let feedView = scrollView.feedViews[scrollView.currentPinpostIndex]
                    let topY = feedView.topY + scrollView.frame.origin.y
                    let newDraggerY = topY - feedDragger!.frame.height * FeedController.DRAGGER_SHOWN

                    UIView.animate(withDuration: duration, animations:
                        { animation in
                            scrollView.contentOffset = CGPoint(x: minX, y: y)
                            self.feedDragger!.frame.origin.y = newDraggerY
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
    
    /** 
     Used to prevent deceleration animation
     */
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
    }
    
    /**
     Get more pinposts on the next page
     */
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
    
    /**
     Fetch the previous page of pinposts
     */
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
    
    /**
     Fetching the pinposts
     */
    func fetchFeed(handler: PinpostsCallback? = nil) {
        PinpostManager().fetchPinpostsFeed(paginate: FeedController.paginate,
                                           scope: "public",
                                           onSuccess:
            { (pinposts, paginate) in
                self.paginateObject = paginate
                handler?(pinposts)
        })
    }
    
    /**
     Closing/Showing the feed
     */
    func toggleFeed(_ button: UIButton) {
        if feedScrollView?.feedViews.count == 0 { // if there is no pinpost do nothing
            return
        }
        
        if feedShown { // hide feed
            let feedY = feedScrollView!.frame.origin.y
            let newButtonY = toolbar!.frame.origin.y - feedDragger!.frame.height *
                FeedController.DRAGGER_SHOWN
            let height = feedScrollView!.frame.height
            UIView.animate(withDuration: 0.5, animations:
                {
                    self.feedScrollView?.frame.origin.y = feedY + height
                    self.feedDragger?.frame.origin.y = newButtonY
            }, completion:
                { action in
                    self.feedShown = false
                    self.feedDragger?.setImage(#imageLiteral(resourceName: "up_icon"), for: .normal)
            })
        } else { // show feed
            let feedY = feedScrollView!.frame.origin.y
            let buttonY = feedDragger!.frame.origin.y
            let height = feedScrollView!.frame.height
            let currentFeedView = feedScrollView!.feedViews[feedScrollView!.currentPinpostIndex]
            let feedViewHeight = currentFeedView.hasThumbnail ?
                currentFeedView.frame.height :
                currentFeedView.frame.height - currentFeedView.profilePicView!.frame.height/2
            
            UIView.animate(withDuration: 0.5, animations:
                {
                    self.feedScrollView?.frame.origin.y = feedY - height
                    self.feedDragger?.frame.origin.y = buttonY - feedViewHeight
            }, completion:
                { action in
                    self.feedShown = true
                    self.feedDragger?.setImage(#imageLiteral(resourceName: "down_icon"), for: .normal)
            })
        }
    }
    
    /**
     Show the profile of the creator of this post
     */
    func showProfile(_ sender: UITapGestureRecognizer) {
        let currentFeedView = feedScrollView!.feedViews[feedScrollView!.currentPinpostIndex]
        let pinpost = currentFeedView.pinpost
        let userId = pinpost!.creator!.id
        
        let profileController = ProfileController()
        profileController.userId = userId
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    /**
     Handling long press
     */
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        PinpostForm.shared.pressedCoordinate = coordinate
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate, completionHandler:
            { response, error in
                if let address = response?.firstResult() {
                    PinpostForm.shared.location = address
                }
        })
        transitionToPinpostForm()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if mapView.camera.zoom < FeedController.MIN_ZOOM_TO_LOAD {
            return
        }
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(fetchMarkers), userInfo: nil, repeats: false)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    func fetchMarkers() {
        guard mapView != nil else {return}
        let visibleRegion = mapView!.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: visibleRegion)
        
        let northWest = CLLocationCoordinate2DMake(bounds.northEast.latitude,
                                                   bounds.southWest.longitude)
        let southEast = CLLocationCoordinate2DMake(bounds.southWest.latitude,
                                                   bounds.northEast.longitude)
        
        PinpostManager().fetchPinpostByFrame(withTopLeftLat: northWest.latitude,
                                             topLeftLong: northWest.longitude,
                                             bottomRightLat: southEast.latitude,
                                             bottomRightLong: southEast.longitude,
                                             onSuccess:
            { pinposts in
                self.loadMarkers(pinposts: pinposts)
        })
    }
    
    func loadMarkers(pinposts: [Pinpost]) {
        self.mapView?.loadMarkers(pinposts: pinposts)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let id = marker.userData as! UInt32
        transitionToExpandedPin(id: id)
        return true
    }
    
    func transitionToExpandedPin(id: UInt32) {
        let controller = ExpandedFeedController()
        controller.pinpostId = id
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromBottom
        
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    func transitionToPinpostForm() {
        let controller = PinpostFormController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if mapView == nil {
            self.setupMap()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView?.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.savedZoom = mapView?.camera.zoom
        self.savedCoord = mapView?.camera.target
    }
    
    deinit {
        print("Deinitializing")
    }
}
