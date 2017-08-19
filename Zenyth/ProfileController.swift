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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar?.homeButton?.addTarget(self, action: #selector(transitionToFeed), for: .touchUpInside)
        toolbar?.notificationButton?.addTarget(self, action: #selector(transitionToNotification), for: .touchUpInside)
        toolbar?.profileButton?.addTarget(self, action: #selector(transitionToProfile), for: .touchUpInside)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.profileView?.requestLoading()
        let userId = UserDefaults.standard.object(forKey: "id") as! UInt32
        
        let group = DispatchGroup()
        group.enter()
        self.readProfile(userId: userId, handler:
            { user in
                let innerGroup = DispatchGroup()
                if let image = user.profilePicture {
                    innerGroup.enter()
                    self.renderProfileImage(image: image, handler:
                        {
                            innerGroup.leave()
                    })
                }
                
                innerGroup.enter()
                self.renderPinImages(pinposts: user.pinposts, handler:
                    {
                        innerGroup.leave()
                })
                
                self.profileView?.usernameLabel!.text = user.username
                self.profileView?.bioText?.text = user.biography
                self.profileView?.setLikesCount(count: user.likes!)
                self.profileView?.setFollowersCount(count: user.friends)
                self.profileView?.setPinpostsCount(count: user.numberOfPinposts!)
                
                innerGroup.notify(queue: .main) {
                    group.leave()
                }
        })
        
        group.notify(queue: .main) {
            self.profileView?.requestDoneLoading()
        }
    }
    
    func readProfile(userId: UInt32, handler: @escaping (User) -> Void) {
        UserManager().readProfile(ofUserId: userId,
                                  onSuccess:
            { user in
                handler(user)
        })
    }
    
    func renderProfileImage(image: Image, handler: @escaping (Void) -> Void) {
        self.profileView?.profilePicture!.imageFromUrl(withUrl: image.url, handler:
            {
                handler()
        })
    }
    
    func renderPinImages(pinposts: [Pinpost], handler: @escaping (Void) -> Void) {
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
                {
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            handler()
        }
    }
}
