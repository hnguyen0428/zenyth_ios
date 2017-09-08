//
//  ProfileController.swift
//  Zenyth
//
//  Created by Hoang on 7/21/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import GoogleMaps

class ProfileController: HomeController, GMSMapViewDelegate, PinThumbnailDelegate {
    
    weak var profileView: ProfileView?
    var profileViewDefaultFrame: CGRect?
    weak var mapView: MapView?
    var user: User? = nil
    var userId: UInt32 = 0
    
    weak var feedDragger: UIButton?
    var profileShown: Bool = true
    
    static let WIDTH_OF_DRAGGER: CGFloat = 0.11
    static let DRAGGER_HIDDEN: CGFloat = 0.30
    static let Y_OF_DRAGGER_WHEN_HIDDEN: CGFloat = 0.03
    
    // This is to readjust the center of the map when profile view is shown
    static let READJUSTED_CENTER_Y: CGFloat = 0.75
    
    var pinposts: [Pinpost]? = nil
    var savedZoom: Float?
    var savedCoord: CLLocationCoordinate2D?
    var mapOrigin: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: false)
        self.renderView()
        
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)
        profileView?.settingsButton?.addTarget(self, action: #selector(transitionToSettings), for: .touchUpInside)
    
//        profileView?.userInfoBar?.followerButton?.addTarget(self, action: #selector(transitionToFollowersList), for: .touchUpInside)

    }
    
    override func setupViews() {
        super.setupViews()
    }
    
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
        if let origin = self.mapOrigin {
            mapView.frame.origin = origin
        }
        else {
            mapView.center.y = view.frame.height * ProfileController.READJUSTED_CENTER_Y
        }
        mapView.delegate = self
        view.insertSubview(mapView, at: 0)
    }
    
    func setupFeedDragger() {
        let width = self.view.frame.width * ProfileController.WIDTH_OF_DRAGGER
        let height = width
        let x = self.profileView!.center.x - width/2
        let y = self.profileView!.frame.maxY - height * ProfileController.DRAGGER_HIDDEN
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let feedDragger = UIButton(frame: frame)
        self.feedDragger = feedDragger
        feedDragger.setImage(#imageLiteral(resourceName: "up_icon"), for: .normal)
        feedDragger.addTarget(self, action: #selector(toggleFeed), for: .touchUpInside)
        view.insertSubview(feedDragger, belowSubview: profileView!)
    }
    
    func renderView() {
        let loggedInUserId = UserDefaults.standard.object(forKey: "id") as! UInt32
        var frame: CGRect!
        if loggedInUserId == self.userId {
            if self.navigationController?.viewControllers.first == self {
                self.navigationItem.leftBarButtonItem = nil
            }
        }
        let bar = self.navigationController?.navigationBar
        frame = CGRect(x: 0, y: bar!.frame.maxY, width: view.frame.width,
                       height: view.frame.height/2)
        
        let indicator = requestLoading(view: self.view)
        self.readProfile(userId: userId, handler:
            { user in
                // Render the pins onto the map
                let pinposts = user.pinposts
                
                self.navigationItem.title = user.username
                let group = DispatchGroup()
                
                var foreign = false
                var status: String? = nil
                if loggedInUserId != self.userId {
                    foreign = true
                    group.enter()
                    UserManager().getRelationship(withUserHavingUserId: self.userId,
                                                  onSuccess:
                        { relationship in
                            if let rel = relationship {
                                if rel.status {
                                    status = "Following"
                                }
                                else {
                                    status = "Request Sent"
                                }
                            }
                            else {
                                status = "Not following"
                            }
                            group.leave()
                    })
                }
                
                group.notify(queue: .main) {
                    if let view = self.profileView {
                        view.removeFromSuperview()
                        self.profileView = nil
                    }
                    
                    let profileView = ProfileView(self, frame: frame,
                                                   user: user, foreign: foreign,
                                                   followStatus: status)
                    self.profileView = profileView
                    
                    self.view.addSubview(profileView)
                    self.profileViewDefaultFrame = profileView.frame
                    self.setupFeedDragger()
                    
                    self.pinposts = pinposts
                    self.mapView?.loadMarkers(pinposts: pinposts)
                    
                    self.requestDoneLoading(view: self.view, indicator: indicator)
                }
        })
    }
    
    func readProfile(userId: UInt32, handler: @escaping (User) -> Void) {
        if let usr = self.user {
            handler(usr)
        }
        else {
            UserManager().readProfile(ofUserId: userId,
                                      onSuccess:
                { user in
                    self.user = user
                    handler(user)
            })
        }
    }
    
    func followUser(_ button: UIButton) {
        RelationshipManager().sendFollowerRequest(toRequesteeId: self.userId,
                                                  onSuccess:
            { relationship in
                if relationship.status {
                    self.profileView?.configureActionButton(status: "Following",
                                                            controller: self)
                }
                else {
                    self.profileView?.configureActionButton(status: "Request Sent",
                                                            controller: self)
                }
        })
                                                  
    }
    
    func unfollowUser(_ button: UIButton) {
        let alert = UIAlertController(title: "Unfollow \(user!.username)",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Unfollow", style: .default, handler:
            { action in
                RelationshipManager().unfollowUser(withUserId: self.userId,
                                                   onSuccess:
                    { json in
                        if json["success"].boolValue {
                            self.profileView?.configureActionButton(status: "Not following",
                                                                    controller: self)
                        }
                })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func toggleFeed(_ button: UIButton) {
        if profileShown { // hide profile
            let newButtonY = self.view.frame.height * ProfileController.Y_OF_DRAGGER_WHEN_HIDDEN
            let height = profileView!.frame.height
            UIView.animate(withDuration: 0.5, animations:
                {
                    self.profileView?.frame.origin.y = -height
                    self.feedDragger?.frame.origin.y = newButtonY
                    self.mapView?.center.y = self.view.center.y
            }, completion:
                { action in
                    self.profileShown = false
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    self.feedDragger?.setImage(#imageLiteral(resourceName: "down_icon"), for: .normal)
            })
        } else { // show profile
            let newPVY = self.profileViewDefaultFrame!.origin.y
            let maxY = self.profileViewDefaultFrame!.maxY
            let newButtonY = maxY - feedDragger!.frame.height * ProfileController.DRAGGER_HIDDEN
            let newMapY = self.view.frame.height * ProfileController.READJUSTED_CENTER_Y
            
            UIView.animate(withDuration: 0.5, animations:
                {
                    self.profileView?.frame.origin.y = newPVY
                    self.feedDragger?.frame.origin.y = newButtonY
                    self.mapView?.center.y = newMapY
            }, completion:
                { action in
                    self.profileShown = true
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.feedDragger?.setImage(#imageLiteral(resourceName: "up_icon"), for: .normal)
            })
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let id = marker.userData as! UInt32
        transitionToExpandedPin(id: id)
        return true
    }
    
    func didLongPress(on pinpost: Pinpost) {
        let coord = CLLocationCoordinate2D(latitude: pinpost.latitude,
                                           longitude: pinpost.longitude)
        self.mapView?.animate(toLocation: coord)
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
    
    func transitionToEditProfile() {
        let controller = EditProfileController()
        self.navigationController?.pushViewController(controller, animated: true)
        controller.user = self.user
        controller.profileImage = self.profileView?.profilePicture?.image
    }
    
    func transitionToSettings() {
        let controller = SettingsController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func transitionToFollowersList() {
        
        let controller = FollowersController()
        
        controller.userId = self.userId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if profileShown {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
        
        if self.mapView == nil {
            self.setupMap()
            if let pinposts = self.pinposts {
                self.mapView?.loadMarkers(pinposts: pinposts)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView?.removeFromSuperview()
        mapView = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.savedZoom = mapView?.camera.zoom
        self.savedCoord = mapView?.camera.target
        self.mapOrigin = mapView?.frame.origin
    }
    
    deinit {
        print("Deinitializing")
    }
}
