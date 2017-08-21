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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.renderView()
        self.navigationController?.setNavigationBarHidden(true,
                                                          animated: false)
        
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)
        profileView?.editProfileButton?.addTarget(self, action: #selector(transitionToEditProfile), for: .touchUpInside)
        profileView?.settingsButton?.addTarget(self, action: #selector(transitionToSettings), for: .touchUpInside)
    }
    
    override func setupViews() {
        super.setupViews()
        toolbar?.setProfileSelected()
        
        let profileFrame = CGRect(x: 0, y: 0, width: view.frame.width,
                                  height: view.frame.height/2)
        profileView = ProfileView(frame: profileFrame)
        view.addSubview(profileView!)
        
        let mapWidth = view.frame.width
        let mapHeight = view.frame.height - toolbar!.frame.height
        let mapFrame = CGRect(x: 0, y: 0, width: mapWidth,
                              height: mapHeight)
        mapView = MapView(frame: mapFrame, view: self.view)
        view.insertSubview(mapView!, at: 0)
    }
    
    func renderView() {
        let userId = UserDefaults.standard.object(forKey: "id") as! UInt32
        profileView?.requestLoading()
        
        self.readProfile(userId: userId, handler:
            { user in
                self.user = user
                self.profileView?.requestDoneLoading()
                if user.profilePicture != nil {
                    self.renderProfileImage(handler: nil)
                } else {
                    let defaultProfile = #imageLiteral(resourceName: "default_profile")
                    self.profileView?.profilePicture?.image = defaultProfile
                    self.profileImage = defaultProfile
                }
                
                self.renderPinImages(pinposts: user.pinposts, handler: nil)
                
                self.renderUserInfo(user: user)
        })
    }
    
    func renderUserInfo(user: User) {
        self.profileView?.usernameLabel?.text = user.username
        self.profileView?.setFollowersCount(count: user.friends)
        
        if let biography = user.biography {
            self.profileView?.bioText?.text = biography
        }
        
        if let likes = user.likes {
            self.profileView?.setLikesCount(count: likes)
        }
        
        if let pinposts = user.numberOfPinposts {
            self.profileView?.setPinpostsCount(count: pinposts)
        }
        
        if let firstName = user.firstName,
            let lastName = user.lastName {
            let name = "\(firstName) \(lastName)"
            self.profileView?.setName(name)
        } else if let firstName = user.firstName {
            self.profileView?.setName(firstName)
        } else if let lastName = user.lastName {
            self.profileView?.setName(lastName)
        }
    }
    
    func readProfile(userId: UInt32, handler: @escaping (User) -> Void) {
        UserManager().readProfile(ofUserId: userId,
                                  onSuccess:
            { user in
                self.user = user
                handler(user)
        })
    }
    
    func renderProfileImage(handler: Handler? = nil) {
        if profileImage == nil {
            self.profileView?.profilePicture!.imageFromUrl(withUrl: self.user!.profilePicture!.url, handler:
                { data in
                    self.profileImage = UIImage(data: data)
                    handler?()
            })
        } else {
            self.profileView?.profilePicture!.image = profileImage!
        }
    }
    
    func renderPinImages(pinposts: [Pinpost], handler: Handler? = nil) {
        var images: [Image] = [Image]()
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
            let url = images[i].url
            group.enter()
            self.profileView?.pinView?.pinImages[i].imageFromUrl(withUrl: url, handler:
                { data in
                    group.leave()
            })
        }
        
        group.notify(queue: .main) {
            handler?()
        }
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
}
