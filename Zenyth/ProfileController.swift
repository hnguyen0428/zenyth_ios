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
    var profileImage: UIImage? = nil
    var pinpostImages: [UIImage]? = nil
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
                
                if user.profilePicture != nil {
                    group.enter()
                    self.renderProfileImage(handler:
                        { image in
                            group.leave()
                            self.profileImage = image
                    })
                } else {
                    let defaultProfile = #imageLiteral(resourceName: "default_profile")
                    self.profileImage = defaultProfile
                }
                
                var pinImages: [UIImage]? = nil
                if user.pinposts.count > 0 {
                    // Used to send in to the constructor of ProfileView so that
                    // it creates the pin view
                    pinImages = [UIImage]()
                }
                
                var name: String? = nil
                if let firstName = user.firstName,
                    let lastName = user.lastName {
                    name = "\(firstName) \(lastName)"
                } else if let firstName = user.firstName {
                    name = firstName
                } else if let lastName = user.lastName {
                    name = lastName
                }
                
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
                                                   name: name,
                                                   bio: user.biography,
                                                   username: user.username,
                                                   pinpostImages: pinImages,
                                                   followers: user.followers, likes: user.likes!,
                                                   numberOfPinposts: user.numberOfPinposts!,
                                                   profilePicture: self.profileImage!,
                                                   foreign: foreign, followStatus: status)
                    
                    // Detecting if the images have already been rendered before
                    if self.pinpostImages == nil {
                        self.renderPinImages(pinposts: user.pinposts, handler:
                            { images in
                                self.pinpostImages = images
                                self.profileView?.setImages(images: self.pinpostImages!)
                        })
                    } else {
                        self.profileView?.setImages(images: self.pinpostImages!)
                    }
                    
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
    
    func renderProfileImage(handler: @escaping (UIImage) -> Void) {
        if profileImage == nil {
            ImageManager().getImageData(withUrl: user!.profilePicture!.getURL(size: "small"),
                                        onSuccess:
                { data in
                    handler(UIImage(data: data)!)
            })
        } else {
            self.profileView?.profilePicture!.image = profileImage!
            handler(profileImage!)
        }
    }
    
    func renderPinImages(pinposts: [Pinpost], handler: @escaping ([UIImage]) -> Void) {
        var images: [Image] = [Image]()
        var uiimages: [UIImage] = [UIImage](repeating: UIImage(), count: 5)
        
        for pinpost in pinposts {
            if let image = pinpost.images.first {
                images.append(image)
            }
        }
        
        let group = DispatchGroup()
        
        for i in 0..<images.count {
            if i > 4 {
                break
            }
            let url = images[i].getURL(size: "medium")
            
            group.enter()
            ImageManager().getImageData(withUrl: url, onSuccess:
                { data in
                    let image = UIImage(data: data)
                    if let img = image {
                        uiimages[i] = img
                    }
                    group.leave()
            })
        }
        
        group.notify(queue: .main) {
            handler(uiimages)
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
        controller.profileImage = self.profileImage
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
