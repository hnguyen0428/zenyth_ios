//
//  ProfileController.swift
//  Zenyth
//
//  Created by Hoang on 7/21/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit

class ProfileController: HomeController {
    
    var profileView: ProfileView?
    var mapView: MapView?
    var user: User? = nil
    var userId: UInt32 = 0
    var shouldSetProfileSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: false)
        self.renderView()
        
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)
        profileView?.settingsButton?.addTarget(self, action: #selector(transitionToSettings), for: .touchUpInside)
        profileView?.userInfoBar?.followerButton?.addTarget(self, action: #selector(transitionToFollowersList), for: .touchUpInside)
    }
    
    override func setupViews() {
        super.setupViews()
        
        if shouldSetProfileSelected {
            toolbar?.setProfileSelected()
        }
        
        mapView = MapView(frame: view.frame, controller: self)
        view.insertSubview(mapView!, at: 0)
    }
    
    func renderView() {
        let loggedInUserId = UserDefaults.standard.object(forKey: "id") as! UInt32
        var frame: CGRect!
        if loggedInUserId == self.userId {
            self.navigationItem.leftBarButtonItem = nil
        }
        let bar = self.navigationController?.navigationBar
        frame = CGRect(x: 0, y: bar!.frame.maxY, width: view.frame.width,
                       height: view.frame.height/2)
        
        let indicator = requestLoading(view: self.view)
        self.readProfile(userId: userId, handler:
            { user in
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
                    
                    self.profileView = ProfileView(self, frame: frame,
                                                   user: user, foreign: foreign,
                                                   followStatus: status)
                    
                    
                    self.view.addSubview(self.profileView!)
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
//        let controller = FollowersListController()
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
